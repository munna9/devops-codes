#!/usr/bin/env bash

AWS_REGIONS='us-east-1'
REPO_BASE_DIRECTORY='ecr'

ecr_push() {
   AWS_ACCOUNT_ID=$(aws ec2 describe-security-groups --group-names 'Default' --query 'SecurityGroups[0].OwnerId' --output text)
   BUILD_NAME=$1
   IMAGE_TAG=$2
   echo -e "\x1B[01;32mPushing $BUILD_NAME:$IMAGE_TAG to $AWS_ACCOUNT_ID \x1B[0m"
   for EACH_REGION in $AWS_REGIONS;do
    $(aws ecr get-login --region $EACH_REGION)
    REPOSITORIES=$(aws ecr describe-repositories --region $EACH_REGION | grep repositoryName | awk -F ':' {'print $2'} | awk -F '"' {'print $2'})
    JOB_EXISTS=$(echo $REPOSITORIES | grep --quiet $BUILD_NAME && echo 'yes' || echo 'no')
    if [ "$JOB_EXISTS" == "no" ]; then
        echo -e  "\x1B[01;32mCreating $BUILD_NAME Repository on $EACH_REGION\x1B[0m"
        aws ecr create-repository --repository-name $BUILD_NAME --region $EACH_REGION
        aws ecr set-repository-policy --repository-name $BUILD_NAME --policy-text "$(cat $HOME/admin_policy.json)" --region $EACH_REGION
    else
        echo -e "\x1B[01;32m$BUILD_NAME already exists on $EACH_REGION\x1B[0m"
    fi
    PROJECT_NAME=$AWS_ACCOUNT_ID.dkr.ecr.$EACH_REGION.amazonaws.com/$BUILD_NAME
    REPO_NAME="$PROJECT_NAME:$IMAGE_TAG"
    docker tag $BUILD_NAME:$IMAGE_TAG $REPO_NAME
    LATEST_IMAGE=$(ls -rd "$REPO_BASE_DIRECTORY/$BUILD_NAME"* | head -1)
    CURRENT_IMAGE="$REPO_BASE_DIRECTORY/$BUILD_NAME:$IMAGE_TAG"
    if [ "$LATEST_IMAGE" == "$CURRENT_IMAGE" ]; then
        echo -e "\x1B[01;32m Updating latest tag for $PROJECT_NAME/$IMAGE_NAME \x1B[0m"
        docker tag $BUILD_NAME:$IMAGE_TAG $PROJECT_NAME:latest
    fi
    UNTAGGED_IMAGES=$(aws ecr list-images --repository-name $BUILD_NAME --filter tagStatus=UNTAGGED | awk {'print $2'})
    for EACH_UNTAGGED in $UNTAGGED_IMAGES;do
     aws ecr batch-delete-image --repository-name $BUILD_NAME --image-ids imageDigest=$EACH_UNTAGGED
    done
    echo -e "\x1B[01;32mPushing $PROJECT_NAME\x1b[0m"
    docker push  $PROJECT_NAME &
   done
   wait
}

WHATPUSHED=$(git whatchanged -1 --format=%f $REPO_BASE_DIRECTORY | grep '^:' | cut -f5 -d ' ' | awk {'print $2'})
for EACH_CHANGE in $WHATPUSHED; do
    BASE_NAME=$(basename $EACH_CHANGE)
    BASE_PATH=$(dirname  $EACH_CHANGE)
    echo $BASE_PATH
    if [ "$BASE_NAME" == 'Dockerfile' ]; then
        if [ -f $EACH_CHANGE ]; then
            echo -e "\x1B[01;32mFound Docker configuration file at $EACH_CHANGE \x1B[0m"
            BASE_PATH=${BASE_PATH#$REPO_BASE_DIRECTORY/}
            read PROJECT_NAME IMAGE_NAME IMAGE_TAG <<< $(echo $BASE_PATH | awk -F'[/:]' '{print $1,$2,$3}')
            echo -e "\x1B[01;32mBuilding container from configuration file $EACH_CHANGE with tag $PROJECT_NAME/$IMAGE_NAME:$IMAGE_TAG \x1B[0m"
            REPO_NAME="$PROJECT_NAME/$IMAGE_NAME"
            BUILD_NAME="$REPO_NAME:$IMAGE_TAG"
            echo $BUILD_NAME
            docker build -t $BUILD_NAME $REPO_BASE_DIRECTORY/$BUILD_NAME
            ecr_push $REPO_NAME $IMAGE_TAG
        fi
    fi
done