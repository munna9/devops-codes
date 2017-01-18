#!/usr/bin/env bash
WHATPUSHED=$(git whatchanged -1  --format=%f | grep '^:' | cut -f5 -d ' ' | sed 's/^[AMD]\t*//g' | cut -f1 -d'/' | sort -u)
echo -e "\x1B[01;32mFound $WHATPUSHED cookbook(s) pushed recently \x1B[0m"
for EACH_COOKBOOK in $WHATPUSHED; do
    if [ -f $EACH_COOKBOOK/.kitchen.yml ]; then
        echo -e "\x1B[01;32mKitchen CI configuration found \x1B[0m"
        echo -e "\x1B[01;32mPerforming kitchen tests on $EACH_COOKBOOK cookbook\x1B[0m"
        cd ${WORKSPACE}/$EACH_COOKBOOK
        KITCHEN_TEST_RESULTS=$(kitchen test --concurrency=4 --log-level=error)
        if ! [ -z "${KITCHEN_TEST_RESULTS// }" ]; then
      		echo -e "\x1B[01;31mKitchen test errors found.. \x1B[0m"
      		echo -e "\x1B[01;31m$KITCHEN_TEST_RESULTS"
      		exit 1
    	fi
        cd ${WORKSPACE}
    else
        echo -e "\x1B[01;31mSkipping Kitchen CI tests, as no configuration file(s) found \x1B[0m"
    fi
done
