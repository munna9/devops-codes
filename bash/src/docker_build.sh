#!/usr/bin/env bash
REPO_BASE_DIRECTORY='docker'
WHATPUSHED=$(git whatchanged -1 --format=%f $REPO_BASE_DIRECTORY | grep '^:' | cut -f5 -d ' ' | awk {'print $2'})
for EACH_CHANGE in $WHATPUSHED; do
    BASE_NAME=$(basename $EACH_CHANGE)
    BASE_PATH=$(dirname  $EACH_CHANGE)
    if [ "$BASE_NAME" == 'Dockerfile' ]; then
        if [ -f $EACH_CHANGE ]; then
            echo -e "\x1B[01;32mFound Docker configuration file at $EACH_CHANGE \x1B[0m"
            BASE_PATH=$(echo $BASE_PATH | sed 's#$REPO_BASE_DIRECTORY/##')
            read ORGANISATION REPO_NAME IMAGE_TAG <<< $(echo $BASE_PATH | awk -F'[/:]' '{print $1,$2,$3}')
            echo -e "\x1B[01;32mBuilding container from configuration file $EACH_CHANGE with tag $ORGANISATION/$REPO_NAME:$IMAGE_TAG \x1B[0m"
            BUILD_NAME="$ORGANISATION/$REPO_NAME:$IMAGE_TAG"
            docker build -t $BUILD_NAME $BUILD_NAME
            LATEST_IMAGE=$(ls -rd "$REPO_BASE_DIRECTORY/$ORGANISATION/$REPO_NAME"* | head -1)
            CURRENT_IMAGE="$REPO_BASE_DIRECTORY/$BUILD_NAME"
            if [ "$LATEST_IMAGE" == "$CURRENT_IMAGE" ]; then
                echo -e "\x1B[01;32m Updating latest tag for $ORGANISATION/$REPO_NAME \x1B[0m"
                docker tag $BUILD_NAME $ORGANISATION/$REPO_NAME:latest
                echo -e "\x1B[01;32m Publishing $ORGANISATION/$REPO_NAME:latest \x1B[0m"
                docker push $ORGANISATION/$REPO_NAME:latest
            fi
            echo -e "\x1B[01;32m Publishing $BUILD_NAME image \x1B[0m"
            docker push $BUILD_NAME
        fi
    fi
done