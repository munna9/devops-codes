#!/usr/bin/env bash
BASE_DIRECTORY=$1

if [ "$#" -ne 1 ]; then
  echo "Usage : $0 BASE_DIRECTORY" >&2
  exit 1
fi
VM_DIRECTORY="/tmp/vagrantvms/$BASE_DIRECTORY"
if ! [ -e $VM_DIRECTORY ]; then
    echo "$VM_DIRECTORY doesn't exists"
    exit 1
fi

cd $VM_DIRECTORY
VAGRANT_DESTROY=$(/opt/vagrant/bin/vagrant destroy -f)
if ! [ -z "${VAGRANT_DESTROY// }" ]; then
  echo "VM Provision errors found"
  exit 1
fi
cd -
rm -rf $VM_DIRECTORY
exit 0
