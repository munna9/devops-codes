#!/usr/bin/env bash
##while true; do
#    LIST_OF_DIRECTORIES=$(ls -d /opt/deployment/mongoconnector/*/)
#    for EACH_DIR in $LIST_OF_DIRECTORIES; do
#    done
#done
#while true; do
if [ -e $MONGO_DIR/oplog.timestamp ]; then
    rm -rf $MONGO_DIR/oplog.timestamp
fi
#MONGO_DIR=${MONGO_DIR::-1}
eval ";exit $?"
#done
