#!/usr/bin/env bash
BASE_DIRECTORY=$1
if [ "$#" -ne 1 ]; then
 echo "Usage: $0 GIT_REPO_DIRECTORY"
 exit 1
fi
cd $BASE_DIRECTORY
REMOTE_BRANCHES=$(git branch -r | grep -v master)
BUILD_FILES="Dockerfile build.sh start-server.sh stop-server.sh"
#echo $REMOTE_BRANCHES
for EACH_BRANCH in $REMOTE_BRANCHES; do
    OTHER_BRANCH=${EACH_BRANCH#origin/}
    "Working in $OTHER_BRANCH"
    git checkout $OTHER_BRANCH
    git checkout master $BUILD_FILES
    git add $BUILD_FILES
    git commit -m "Adding Build script files"
    git push origin $OTHER_BRANCH
done
cd -
