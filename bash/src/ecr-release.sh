#!/bin/bash
AWS_ACCOUNT_ID=$(aws ec2 describe-security-groups --group-names 'Default' --query 'SecurityGroups[0].OwnerId' --output text)
for EACH_REGION in $AWS_REGIONS;do
    $(aws ecr get-login --region $EACH_REGION)
 	REPOSITORIES=$(aws ecr describe-repositories --region $EACH_REGION | grep repositoryName | awk -F ':' {'print $2'} | awk -F '"' {'print $2'})
    JOB_EXISTS=$(echo $REPOSITORIES | grep --quiet $IMAGE_NAME && echo 'yes' || echo 'no')
    if [ "$JOB_EXISTS" == "no" ]; then
    	echo -e "\x1B[01;31m$IMAGE_NAME doesn't exist.. \x1B[0m"
    	exit 1
    fi
    PROJECT_NAME=$AWS_ACCOUNT_ID.dkr.ecr.$EACH_REGION.amazonaws.com/$IMAGE_NAME
    REPO_NAME="$PROJECT_NAME:$RELEASE_NUMBER"
    if [ ${BACKUP_TAG} == true ]; then
    	docker tag $PROJECT_NAME:$TAG_NAME $PROJECT_NAME:$TAG_NAME.1
    fi
    docker tag $REPO_NAME $PROJECT_NAME:$TAG_NAME
    if [ "$?" == "1" ]; then
     echo -e "\x1B[01;31mTagging errors found... \x1B[0m"
     echo -e "\x1B[01;31m$TAG_ERRORS\x1B[0m"
     exit 1
    fi
    echo -e "\x1B[01;32mPushing $PROJECT_NAME... \x1B[0m"
    docker push $PROJECT_NAME &
done
wait
