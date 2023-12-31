#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 84
fi

declare -A ext_map
declare -A found_map

ext_map["c"]="Makefile"
ext_map["java"]="pom.xml"
ext_map["python"]="requirements.txt"
ext_map["javascript"]="package.json"
ext_map["befunge"]="app/main.bf"

for ext in "${!ext_map[@]}"
do
    if test -f $1/${ext_map[$ext]} || test -f $1/app/${ext_map[$ext]}; then
        found_map[$ext]=${ext_map[$ext]}
        echo "${ext_map[$ext]}"
    fi
done

if [ ${#found_map[@]} -eq 0 ];
then
    echo "No template found"
    exit 0
fi

exit ${#found_map[@]}
