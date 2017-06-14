#!/usr/bin/env bash
AWS_ACCOUNT_ID=$(aws ec2 describe-security-groups --group-names 'Default' --query 'SecurityGroups[0].OwnerId' --output text)
for EACH_REGION in $AWS_REGIONS;do
    $(aws ecr get-login --profile phemom --region $EACH_REGION)
    REPOSITORIES=$(aws ecr describe-repositories --profile phemom --region $EACH_REGION | grep repositoryName | awk -F ':' {'print $2'} | awk -F '"' {'print $2'})
    JOB_EXISTS=$(echo $REPOSITORIES | grep --quiet $IMAGE_NAME && echo 'yes' || echo 'no')
    if [ "$JOB_EXISTS" == "no" ]; then
        echo -e  "\x1B[01;32mCreating $JOB_NAME Repository on $EACH_REGION\x1B[0m"
        aws ecr create-repository --repository-name $IMAGE_NAME --profile phemom --region $EACH_REGION
        aws ecr set-repository-policy --repository-name $IMAGE_NAME --profile phemom --policy-text "$(cat $HOME/phemom_admin_policy.json)" --region $EACH_REGION
    fi
    PRE_PROD_PROJECT_NAME=$AWS_ACCOUNT_ID.dkr.ecr.$EACH_REGION.amazonaws.com/$IMAGE_NAME
    PRE_PROD_REPO_NAME="$PREPROD_PROJECT_NAME:$RELEASE_NUMBER"

    PROD_PROJECT_NAME=$PROD_AWS_ACCOUNT_ID.dkr.ecr.$EACH_REGION.amazonaws.com/$IMAGE_NAME
    if [ ${BACKUP_TAG} == true ]; then
        docker tag $PROD_PROJECT_NAME:$TAG_NAME $PROD_PROJECT_NAME:$TAG_NAME.1
    fi
    docker tag $PRE_PROD_REPO_NAME $PROD_PROJECT_NAME:$TAG_NAME
    if [ "$?" == "1" ]; then
        echo -e "\x1B[01;31mTagging errors found... \x1B[0m"
        exit 1
    fi
    echo -e "\x1B[01;32mPushing $PROJECT_NAME... \x1B[0m"
    docker push $PROD_PROJECT_NAME &
done
wait
