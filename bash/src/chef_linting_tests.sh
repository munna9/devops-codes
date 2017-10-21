#!/usr/bin/env bash
WHATPUSHED=$(git whatchanged -1  --format=%f | grep '^:' | cut -f5 -d ' ' | sed 's/^[AMD]\t*//g' | cut -f1 -d'/' | sort -u)
echo -e "\x1B[01;32mFound $WHATPUSHED cookbook(s) pushed recently \x1B[0m"
for EACH_CHANGE in $WHATPUSHED;do
    FOODCRITIC_ERRORS=$(foodcritic -f any $EACH_CHANGE -t ~FC048 -t ~FC012 -t ~FC023 -t ~FC043 -t ~FC015 -t ~FC002 -t ~FC019 -t ~FC003 -t ~FC004 -t ~FC045 -t ~FC041 -t ~FC025 -t ~FC017 -t ~FC001 -t ~FC034 -t ~FC009 -t ~FC043 -t ~FC014)
    if ! [ -z "${FOODCRITIC_ERRORS// }" ]; then
      echo -e "\x1B[01;31mFood critic errors found... \x1B[0m"
      echo -e "\x1B[01;31m$FOODCRITIC_ERRORS \x1B[0m"
      exit 1
    fi
    METADATA_CHANGED=$(git diff --format=%f HEAD^ HEAD $EACH_CHANGE/metadata.rb | grep -c '^+version')
    CHANGELOG_CHANGED=$(git diff --format=%f HEAD^ HEAD $EACH_CHANGE/CHANGELOG.md | grep -c '^+')
    if [ $METADATA_CHANGED -eq 0 ]; then
        echo -e "\x1B[01;31mNo changes found in $EACH_CHANGE/metadata.rb \x1B[0m"
        exit 1
    fi
    if [ $CHANGELOG_CHANGED -eq 0 ]; then
        echo -e "\x1B[01;31mNo changes found in $EACH_CHANGE/CHANGELOG.md \x1B[0m"
        exit 1
    fi
    NEW_VERSION_NUMBER=$(git diff --format=%f HEAD^ HEAD $EACH_CHANGE/metadata.rb | grep '^+version' | awk {'print $2'}| sed "s/'//g")
    CHANGELOG_WITH_NEW_VERSION=$(git diff --format=%f HEAD^ HEAD $EACH_CHANGE/CHANGELOG.md | grep -A2 '^+#' | grep -c $NEW_VERSION_NUMBER)
    if [ $CHANGELOG_WITH_NEW_VERSION -eq 0 ]; then
        echo -e "\x1B[01;31m$EACH_CHANGE/CHANGELOG.md is not properly documented \x1B[0m"
        exit 1
    fi  
done