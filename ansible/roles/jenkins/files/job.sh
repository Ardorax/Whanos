#!/bin/bash

DOCKER_HUB_USERNAME=$(cat /var/lib/jenkins/dockerCredentials | grep "DOCKER_USERNAME" | cut -d'=' -f2)
DOCKER_PASSWORD=$(cat /var/lib/jenkins/dockerCredentials | grep "DOCKER_PASSWORD" | cut -d'=' -f2)
DOCKER_HUB_REPO_NAME=$(cat /var/lib/jenkins/dockerCredentials | grep "DOCKER_REGISTRY" | cut -d'=' -f2)

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

IMAGE_NAME=$DOCKER_HUB_USERNAME/$DOCKER_HUB_REPO_NAME:$1-$LANGUAGE

docker login -u $DOCKER_HUB_USERNAME --password $DOCKER_PASSWORD

if [ -f "Dockerfile" ]; then
    echo "Dockerfile found"
    docker build -t $IMAGE_NAME .
else
    docker build -t $IMAGE_NAME -f ${RIGHT_FOLDER}Dockerfile.standalone .
fi 


docker push $IMAGE_NAME
