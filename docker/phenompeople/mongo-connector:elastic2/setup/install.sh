#!/usr/bin/env bash
set -e

PYTHON_SRC_URI=https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
ELASTIC_DOC_URI=https://github.com/mongodb-labs/elastic2-doc-manager/archive/$ELASTIC_DOC_VERSION.tar.gz
MONGO_CONNECTIOR_URI=https://github.com/mongodb-labs/mongo-connector/archive/$MONGO_CONNECTOR_VERSION.tar.gz

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
  echo "Extracting $SOURCE_DIR/$SOURCE_BINARY"
  tar -xzf $SOURCE_DIR/$SOURCE_BINARY -C $SETUP_DIRECTORY
}

compile_from_source(){
    echo "Compiling $1 from $SETUP_DIRECTORY/$1"
    cd $SETUP_DIRECTORY/$1
    ./configure > /tmp/install.log 2>&1
    make > /tmp/install.log 2>&1
    make install > /tmp/install.log 2>&1
    cd $SETUP_DIRECTORY
}

download_and_extract $PYTHON_SRC_URI

compile_from_source Python-$PYTHON_VERSION

wget -q -O /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py'
python3 /tmp/get-pip.py "pip==$PYTHON_PIP_VERSION"
rm -rf tmp/get-pip.py /tmp/install.log

##download_and_extract $MONGO_CONNECTIOR_URI
#cd $SETUP_DIRECTORY
#pip install mongo-connector-${MONGO_CONNECTOR_VERSION}[elastic2]
#download_and_extract $ELASTIC_DOC_URI
#cd $SETUP_DIRECTORY
pip install elastic2-doc-manager[elastic2]
