#!/bin/bash
AWS_ACCOUNT_ID=$(aws ec2 describe-security-groups --group-names 'Default' --query 'SecurityGroups[0].OwnerId' --output text)
for EACH_REGION in $AWS_REGIONS;do
    $(aws ecr get-login --region $EACH_REGION)
    REPOSITORIES=$(aws ecr describe-repositories --region $EACH_REGION | grep repositoryName | awk -F ':' {'print $2'} | awk -F '"' {'print $2'})
    JOB_EXISTS=$(echo $REPOSITORIES | grep --quiet $JOB_NAME && echo 'yes' || echo 'no')
    if [ "$JOB_EXISTS" == "no" ]; then
        echo -e  "\x1B[01;32mCreating $JOB_NAME Repository on $EACH_REGION\x1B[0m"
        aws ecr create-repository --repository-name $JOB_NAME --region $EACH_REGION
        aws ecr set-repository-policy --repository-name $JOB_NAME --policy-text "$(cat $HOME/admin_policy.json)" --region $EACH_REGION
    else
        echo -e "\x1B[01;32m$JOB_NAME already exists on $EACH_REGION\x1B[0m"
    fi
    PROJECT_NAME=$AWS_ACCOUNT_ID.dkr.ecr.$EACH_REGION.amazonaws.com/$JOB_NAME
    REPO_NAME="$PROJECT_NAME:$BRANCH.$BUILD_NUMBER"
    docker tag $JOB_NAME $REPO_NAME
    docker tag $REPO_NAME $PROJECT_NAME:latest
    IMAGES_TO_RETAIN=$(($IMAGES_TO_RETAIN+1))
    UNTAGGED_IMAGES=$(aws ecr list-images --repository-name $JOB_NAME --filter tagStatus=UNTAGGED | awk {'print \$\2'})
    for EACH_UNTAGGED in $UNTAGGED_IMAGES;do
     aws ecr batch-delete-image --repository-name $JOB_NAME --image-ids imageDigest=$EACH_UNTAGGED
    done
    IMAGES_TO_REMOVE=$(docker images --filter "label=project=$JOB_NAME" --format="{{.Repository}}:{{.Tag}}" | grep -v latest | grep $BRANCH | sort -r --version-sort | tail -n +$IMAGES_TO_RETAIN)
    for EACH_IMAGE in $IMAGES_TO_REMOVE;do
     TAG_NAME=$(echo $EACH_IMAGE | cut -f2 -d\:)
     aws ecr batch-delete-image --repository-name $JOB_NAME --image-ids imageTag=$TAG_NAME
     docker rmi $EACH_IMAGE;
     done
    echo -e "\x1B[01;32mPushing $PROJECT_NAME\x1b[0m"
    docker push  $PROJECT_NAME &
done
wait
