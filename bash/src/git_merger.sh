#!/usr/bin/env bash
BASE_DIRECTORY=$1
BRANCH_NAME=$2
if [ "$#" -ne 2 ]; then
 echo "Usage: $0 GIT_REPO_DIRECTORY BRANCH_NAME"
 exit 1
fi
cd $BASE_DIRECTORY
REMOTE_BRANCHES=$(git branch -r | grep -v $BRANCH_NAME)
#BUILD_FILES="Dockerfile build.sh start-server.sh stop-server.sh"
BUILD_FILES="Dockerfile build.sh setup.sh"
#echo $REMOTE_BRANCHES
for EACH_BRANCH in $REMOTE_BRANCHES; do
    OTHER_BRANCH=${EACH_BRANCH#origin/}
    echo "Working in $OTHER_BRANCH"
    git checkout $OTHER_BRANCH
    git checkout $BRANCH_NAME $BUILD_FILES
    git add $BUILD_FILES
    git commit -m "Adding Build script files"
    git push origin $OTHER_BRANCH
done
cd -
