#!/usr/bin/env bash
echo -e "\x1B[01;32mUploading cookbook(s)"
${knife} upload /cookbooks --verbose --chef-repo-path=${WORKSPACE} --diff
echo -e "\x1B[0m"
echo -e "\x1B[01;32mUploading role(s)"
${knife} upload /roles --verbose --purge --chef-repo-path=${WORKSPACE}
echo -e "\x1B[0m"
echo -e "\x1B[01;32mUploading cookbook(s)"
${knife} upload /environments --verbose --purge --chef-repo-path=${WORKSPACE}
echo -e "\x1B[0m"
WHATPUSHED=$(git whatchanged -1  --format=%f | grep '^:' | cut -f5 -d ' ' | sed 's/^[AMD]\t*//g' | cut -f1 -d'/' | sort -u)
for EACH_CHANGE in $WHATPUSHED; do
    if [ "${EACH_CHANGE}" == "data_bags" ]; then
        DATABAG_NAMES=$(git whatchanged -1  --format=%f data_bags | grep '^:' | cut -f5 -d ' ' | sed 's/^[AMD]\t*//g'  | cut -f2 -d '/' | sort -u)
        for EACH_ITEM in $DATABAG_NAMES; do
            if [ -d $EACH_ITEM ]; then
                echo -e "\x1B[01;32mUploading $EACH_ITEM data_bag configuration...\x1B[0m"
                ${knife} data bag from file $EACH_ITEM data_bags/$EACH_ITEM
            fi
        done
    fi
    if [ "${EACH_CHANGE}" == "nodes" ]; then
        NODES=$(git whatchanged -1  --format=%f nodes | grep '^:' | cut -f5 -d ' ' | sed 's/^[AMD]\t*//g'  | cut -f2 -d '/' | sort -u)
        for EACH_NODE in $NODES; do
            echo -e "\x1B[01;32mUploading $EACH_NODE node configuration...\x1B[0m"
            ${knife} node from file $EACH_ITEM data_bags/$EACH_ITEM
        done
    fi
done