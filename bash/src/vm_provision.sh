#!/usr/bin/env bash

BASE_DIRECTORY=$1

if [ "$#" -ne 1 ]; then
  echo "Usage : $0 BASE_DIRECTORY" >&2
  exit 1
fi
VM_DIRECTORY="/tmp/vargrantvms/$BASE_DIRECTORY"
mkdir -p $VM_DIRECTORY
echo -e "Created base directory at $VM_DIRECTORY"
wget -O $VM_DIRECTORY/Vagrantfile "https://drive.google.com/uc?export=download&id=0B1cm4yco8yz6WUtvMzE2UkNXd0E"
cd $VM_DIRECTORY
VAGRANT_PROVISION=$(/opt/vagrant/bin/vagrant up)
if ! [ -z "${VAGRANT_PROVISION// }" ]; then
  echo "VM Provision errors found"
  exit 1
fi
cd -
