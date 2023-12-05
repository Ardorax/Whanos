#!/bin/sh

DOCKER_PASSWORD=""
DOCKER_HUB_USERNAME=""
DOCKER_HUB_REPO_NAME=""

FOUND_TEMPLATES_PATH="/var/lib/jenkins/foundTemplate.sh"

PROJECT_PATH="/var/lib/jenkins/workspace/Projects/$1"

DOCKER_IMAGES_FOLDER="/var/lib/jenkins/images"

C_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/c/"
JAVA_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/java/"
NODE_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/javascript/" 
PYTHON_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/python/"
BEFUNGE_IMAGES_FOLDER="${DOCKER_IMAGES_FOLDER}/befunge/"

FOUND_TEMPLATES=$($FOUND_TEMPLATES_PATH $PROJECT_PATH)

echo $dd1

# if the return is 0, then stop the script
if [ $? -eq 0 ]; then
    echo "No template found"
    exit 0
fi

LANGUAGE=""
RIGHT_FOLDER=""

if [ $FOUND_TEMPLATES = "Makefile" ]; then
    RIGHT_FOLDER=$C_IMAGES_FOLDER
    LANGUAGE="c"
fi
if [ $FOUND_TEMPLATES = "pom.xml" ]; then
    RIGHT_FOLDER=$JAVA_IMAGES_FOLDER
    LANGUAGE="java"
fi
if [ $FOUND_TEMPLATES = "package.json" ]; then
    RIGHT_FOLDER=$NODE_IMAGES_FOLDER
    LANGUAGE="javascript"
fi
if [ $FOUND_TEMPLATES = "requirements.txt" ]; then
    RIGHT_FOLDER=$PYTHON_IMAGES_FOLDER
    LANGUAGE="python"
fi
if [ $FOUND_TEMPLATES = "app/main.bf" ]; then
    RIGHT_FOLDER=$BEFUNGE_IMAGES_FOLDER
    LANGUAGE="befunge"
fi
## else
if [ -z $RIGHT_FOLDER ]; then
    echo "Too many templates found"
    exit 0
fi

IMAGE_NAME=$DOCKER_HUB_USERNAME/$DOCKER_HUB_REPO_NAME:$2-$3-$LANGUAGE

echo "RIGHT_FOLDER: $RIGHT_FOLDER"
BUILD_CMD="docker build -t $IMAGE_NAME -f ${RIGHT_FOLDER}Dockerfile.standalone ."

if [ -f "Dockerfile" ]; then
    echo "Dockerfile found"
    $BUILD_CMD = "docker build -t $IMAGE_NAME - < ${RIGHT_FOLDER}Dockerfile.base"
fi
docker login -u izimio --password $DOCKER_PASSWORD

$($BUILD_CMD)

docker push $IMAGE_NAME