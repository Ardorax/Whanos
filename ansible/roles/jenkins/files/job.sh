#!/bin/bash

DOCKER_HUB_USERNAME=$(cat /var/lib/jenkins/registryInfo | grep "DOCKER_USERNAME" | cut -d'=' -f2)
DOCKER_HUB_REPO_NAME=$(cat /var/lib/jenkins/registryInfo | grep "DOCKER_REGISTRY" | cut -d'=' -f2)

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
    exit 1 # Return 1 to stop the script with error
fi

LANGUAGE=""
RIGHT_FOLDER=""

if [ "$FOUND_TEMPLATES" = "Makefile" ]; then
    RIGHT_FOLDER="$C_IMAGES_FOLDER"
    LANGUAGE="c"
fi
if [ "$FOUND_TEMPLATES" = "pom.xml" ]; then
    RIGHT_FOLDER="$JAVA_IMAGES_FOLDER"
    LANGUAGE="java"
fi
if [ "$FOUND_TEMPLATES" = "package.json" ]; then
    RIGHT_FOLDER="$NODE_IMAGES_FOLDER"
    LANGUAGE="javascript"
fi
if [ "$FOUND_TEMPLATES" = "requirements.txt" ]; then
    RIGHT_FOLDER="$PYTHON_IMAGES_FOLDER"
    LANGUAGE="python"
fi
if [ "$FOUND_TEMPLATES" = "app/main.bf" ]; then
    RIGHT_FOLDER="$BEFUNGE_IMAGES_FOLDER"
    LANGUAGE="befunge"
fi
## else
if [ -z "$RIGHT_FOLDER" ]; then
    echo "Too many templates found $RIGHT_FOLDER"
    echo "Too many templates found($FOUND_TEMPLATES)"
    exit 1 # Return 1 to stop the script with error
fi

IMAGE_NAME=$DOCKER_HUB_USERNAME/$DOCKER_HUB_REPO_NAME:$1-$LANGUAGE

if [ -f "Dockerfile" ]; then
    echo "Dockerfile found"
    docker build -t $IMAGE_NAME .
else
    docker build -t $IMAGE_NAME -f ${RIGHT_FOLDER}Dockerfile.standalone .
fi


docker push $IMAGE_NAME

# If whanos.yml is present
if [ -f "whanos.yml" ]; then
    echo "whanos.yml found"
    cp /var/lib/jenkins/app.deployment.yaml .
    cp /var/lib/jenkins/app.service.yaml .
    python3 /var/lib/jenkins/replaceVar.py whanos.yml "$1-$LANGUAGE" "$IMAGE_NAME"
    cat app.deployment.yaml
    cat app.service.yaml
    kubectl apply -f app.deployment.yaml -f app.service.yaml
fi