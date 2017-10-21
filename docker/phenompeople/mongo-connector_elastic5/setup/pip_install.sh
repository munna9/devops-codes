#!/usr/bin/env bash
set -e
SOURCE_DIR="$SETUP_DIRECTORY/sources"

func_create_directory() {
    if [ ! -e $1 ]; then
        echo "Creating Directory : $1"
        mkdir -p $1
    fi
}

download_and_extract(){
    SRC_LOCATION=$1
    func_create_directory $SOURCE_DIR
    SOURCE_BINARY=$(basename $SRC_LOCATION)
    echo "Downloading $SRC_LOCATION"
    wget -q -O $SOURCE_DIR/$SOURCE_BINARY $SRC_LOCATION
    tar -xzf $SOURCE_DIR/$SOURCE_BINARY -C $SETUP_DIRECTORY

}

