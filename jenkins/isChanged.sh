#!/bin/bash

test -f .git/index

if [ $? -eq 0 ]
then
    git status | grep "files" > /dev/null
    if [ $? -eq 0 ]
    then
        echo "true"
    else
        echo "false"
    fi
else
    echo "No changes"
fi