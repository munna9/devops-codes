#!/usr/bin/env bash


ecr_hub_push(){
    BUILD_NAME=$1
    IMAGE_NAME=$(echo $BUILD_NAME | cut -f1 -d :)
    AWS_ACCOUNT_ID=$(aws ec2 describe-security-groups --group-names 'Default' --query 'SecurityGroups[0].OwnerId' --output text)
    echo -e "\x1B[01;32mPushing $IMAGE_NAME to $AWS_ACCOUNT_ID \x1B[0m"
    for EACH_REGION in $AWS_REGIONS;do
        $(aws ecr get-login --region $EACH_REGION)
        REPOSITORIES=$(aws ecr describe-repositories --region $EACH_REGION | grep repositoryName | awk -F ':' {'print $2'} | awk -F '"' {'print $2'})
        JOB_EXISTS=$(echo $REPOSITORIES | grep --quiet $IMAGE_NAME && echo 'yes' || echo 'no')
        if [ "$JOB_EXISTS" == "no" ]; then
            echo -e  "\x1B[01;32mCreating $IMAGE_NAME Repository on $EACH_REGION\x1B[0m"
            aws ecr create-repository --repository-name $IMAGE_NAME --region $EACH_REGION
            aws ecr set-repository-policy --repository-name $IMAGE_NAME --policy-text "$(cat $HOME/admin_policy.json)" --region $EACH_REGION
        else
            echo -e "\x1B[01;32m$IMAGE_NAME already exists on $EACH_REGION\x1B[0m"
        fi
        PROJECT_NAME=$AWS_ACCOUNT_ID.dkr.ecr.$EACH_REGION.amazonaws.com/$IMAGE_NAME
        docker tag $BUILD_NAME $AWS_ACCOUNT_ID.dkr.ecr.$EACH_REGION.amazonaws.com/$BUILD_NAME
        LATEST_IMAGE=$(ls -rd "ecr/$IMAGE_NAME"* | head -1)
        PROJECT_PATH="ecr/$BUILD_NAME"
        if [ "$LATEST_IMAGE" == "$PROJECT_PATH" ]; then
            echo -e "\x1B[01;32m Updating latest tag for $BUILD_NAME \x1B[0m"
            docker tag $BUILD_NAME $IMAGE_NAME:latest
        fi
        UNTAGGED_IMAGES=$(aws ecr list-images --repository-name $IMAGE_NAME --filter tagStatus=UNTAGGED | awk {'print $2'})
        for EACH_UNTAGGED in $UNTAGGED_IMAGES;do
            aws ecr batch-delete-image --repository-name $IMAGE_NAME --image-ids imageDigest=$EACH_UNTAGGED
        done
        echo -e "\x1B[01;32mPushing $PROJECT_NAME\x1b[0m"
        echo docker push  $PROJECT_NAME &
    done
    wait
}
docker_hub_push () {
    BUILD_NAME=$1
    IMAGE_NAME=$(echo $BUILD_NAME | cut -f1 -d :)
    echo "39",$IMAGE_NAME
    LATEST_IMAGE=$(ls -rd "docker/$IMAGE_NAME"* | head -1)
    PROJECT_PATH="docker/$BUILD_NAME"
    if [ "$LATEST_IMAGE" == "$PROJECT_PATH" ]; then
        echo -e "\x1B[01;32m Updating latest tag for $BUILD_NAME \x1B[0m"
        docker tag $BUILD_NAME $IMAGE_NAME:latest
        docker push $IMAGE_NAME:latest
    fi
    echo docker push $BUILD_NAME
}

local_docker_build() {
    REPO_BASE_DIRECTORY=$1
    WHAT_PUSHED=$(git whatchanged -1 --format=%f $REPO_BASE_DIRECTORY | grep '^:' | cut -f5 -d ' ' | awk {'print $2'})
    echo "53",$WHAT_PUSHED
    for EACH_CHANGE in $WHAT_PUSHED;do
        BASE_NAME=$(basename $EACH_CHANGE)
        BASE_PATH=$(dirname  $EACH_CHANGE)
        PROJECT_PATH=${BASE_PATH#$REPO_BASE_DIRECTORY/}
        echo "Each change is" , $EACH_CHANGE
        read ORGANISATION IMAGE_NAME IMAGE_TAG <<< $(echo $PROJECT_PATH | awk -F'[/:]' '{print $1,$2,$3}')
        PROJECT_PATH="$REPO_BASE_DIRECTORY/$ORGANISATION/$IMAGE_NAME:$IMAGE_TAG"
        DOCKER_FILE="$PROJECT_PATH/Dockerfile"
        echo "\Docker file is $DOCKER_FILE \x1B[0m"
        if [ -e $DOCKER_FILE ];then
            echo -e "\x1B[01;32mFound Docker configuration file at $PROJECT_PATH \x1B[0m"
            REPO_NAME="$ORGANISATION/$IMAGE_NAME"
            BUILD_NAME=$REPO_NAME:$IMAGE_TAG
            echo -e "\x1B[01;32mBuilding container from configuration file $EACH_CHANGE with tag $ORGANISATION/$IMAGE_NAME:$IMAGE_TAG \x1B[0m"
            echo $(docker build -t $BUILD_NAME $PROJECT_PATH)
            docker build -t $BUILD_NAME $PROJECT_PATH
            if [ $REPO_BASE_DIRECTORY == 'docker' ]; then
                docker_hub_push $BUILD_NAME
            fi
            if [ $REPO_BASE_DIRECTORY == 'ecr' ]; then
                ecr_hub_push $BUILD_NAME
            fi
        fi
    done
}

################
# Main program
################
AWS_REGIONS=('us-east-1')
ROOT_DIRECTORIES=$(git whatchanged -1 | grep '^:'| cut -f5 -d ' ' | awk '{print $2}' | cut -f1 -d '/' | sort -u)
echo $ROOT_DIRECTORIES
for EACH_ROOT_DIR in $ROOT_DIRECTORIES;do
    if  [ "$EACH_ROOT_DIR" == 'docker' ] || [ "$EACH_ROOT_DIR" == 'ecr' ]; then
        local_docker_build $EACH_ROOT_DIR
    elif [ "$EACH_ROOT_DIR" == 'bash' ];then
        echo "In bash loop"
    fi
done
