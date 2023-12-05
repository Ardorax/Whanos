#!/bin/sh

DOCKER_PASSWORD=""
REGISTRY_URL="izimio/whanos:"

FOUND_TEMPLATES_PATH="/var/lib/jenkins/foundTemplate.sh"

PROJECT_PATH="/var/lib/jenkins/workspace/Projects/$1"

DOCKER_IMAGES_FOLDER="/var/lib/jenkins/images"

C_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/c/"
JAVA_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/java/"
NODE_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/javascript/" 
PYTHON_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/python/"
BEFUNGE_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/befunge/"

FOUND_TEMPLATES=$($FOUND_TEMPLATES_PATH $PROJECT_PATH)


# if the return is 0, then stop the script
if [ $? -eq 0 ]; then
    echo "No template found"
    exit 0
fi

RIGHT_FOLDER=""

if [ $FOUND_TEMPLATES = "Makefile" ]; then
    RIGHT_FOLDER=$C_IMAGES_FOLDER
fi
if [ $FOUND_TEMPLATES = "pom.xml" ]; then
    RIGHT_FOLDER=$JAVA_IMAGES_FOLDER
fi
if [ $FOUND_TEMPLATES = "package.json" ]; then
    RIGHT_FOLDER=$NODE_IMAGES_FOLDER
fi
if [ $FOUND_TEMPLATES = "requirements.txt" ]; then
    RIGHT_FOLDER=$PYTHON_IMAGES_FOLDER
fi
if [ $FOUND_TEMPLATES = "app/main.bf" ]; then
    RIGHT_FOLDER=$BEFUNGE_IMAGES_FOLDER
fi
## else
if [ -z $RIGHT_FOLDER ]; then
    echo "Too many templates found"
    exit 0
fi

echo "RIGHT_FOLDER: $RIGHT_FOLDER"
BUILD_CMD="docker build -t whanos-something -f ${RIGHT_FOLDER}Dockerfile.standalone ."

if [ -f "Dockerfile" ]; then
    echo "Dockerfile found"
    $BUILD_CMD = "docker build -t whanos-something - < ${RIGHT_FOLDER}Dockerfile.base"
fi
docker login -u izimio --password $DOCKER_PASSWORD

$($BUILD_CMD)

docker tag whanos-something "${REGISTRY_URL}$1"
docker push "{$REGISTRY_URL}$1"