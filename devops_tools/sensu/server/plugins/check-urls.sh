#!/bin/bash
curl -sI $1 | head -1 | grep -w '301\|200\|302'

if [ $? -eq 0 ]
then
  echo "The $1 is OK "
  exit 0
else
  echo "$1 is DOWN ; "
  exit 2
fi

