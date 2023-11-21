#!/bin/bash

test -f .git/index

if [ $? -eq 0 ]
then
    git status | grep "file" > /dev/null
    if [ $? -eq 0 ]
    then
        echo "true"
        exit 1
    else
        echo "false"
        exit 0
    fi
else
    echo "No git repository found"
    exit 84
fi