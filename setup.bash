#!/bin/bash
IMAGE_NAME=ubuntu18gui
CONTAINER_NAME=ubuntu18gui
xhost +


RED='\033[0;31m'
NC='\033[0m' # No Color

# Check argument
function checkArg()
{
    if [ -z $1 ]
    then
        printf "${RED}Please set container NAME${NC}\n"
        return 0
    else
        printf "Container name: $1\n" 
        CONTAINER_NAME=$1
        return 1
    fi
}

function addAutoComplete()
{
    list=$(docker ps --filter ancestor=art_env_gui --format "{{.Names}}")
    list=$(echo "$list" | tr '\n' ' ')
    complete -W "${list}" dlogin
    complete -W "${list}" drm
}

# Run docker on PC with Nvidia GPU
function drunnvidia()
{
    checkArg $1
    if [ "$?" -eq 1 ]; then
    ## Minimum setting
    docker run --runtime=nvidia -d \
        --name=${CONTAINER_NAME} \
        --env="QT_X11_NO_MITSHM=1" \
        --env="DISPLAY" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        ${IMAGE_NAME}:latest \
        /bin/sh -c "sed -i "s/CMD_PROMPT_PREFIX=.*$/CMD_PROMPT_PREFIX=$1/" /root/.bashrc && while true; do sleep 10; done"
    fi
    addAutoComplete
}

# Run docker on PC with Intel GPU
function drunintel
{
    checkArg $1
    if [ "$?" -eq 1 ]; then
        addAutoComplete
        docker run -d \
            --name=${CONTAINER_NAME} \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            ${IMAGE_NAME}:latest \
            /bin/sh -c "sed -i "s/CMD_PROMPT_PREFIX=.*$/CMD_PROMPT_PREFIX=$1/" /root/.bashrc && while true; do sleep 10; done"
    fi
    addAutoComplete
}

# Stop and remove container
function drm 
{
    checkArg $1
    if [ "$?" -eq 1 ]; then
        echo "Stopping $1"
        docker stop ${CONTAINER_NAME}
        echo "Removing $1"
        docker rm ${CONTAINER_NAME}
    else
        echo "Related container names:"
        docker ps --filter ancestor=${IMAGE_NAME}
    fi
    addAutoComplete
}

function drmall
{
    list=$(docker ps --filter ancestor=art_env_gui --format "{{.Names}}")
    list=$(echo "$list" | tr '\n' ' ')
    echo "Stoppint ${list}"
    docker stop ${list}
    echo "Removing ${list}"
    docker rm ${list}
}

function dbuild
{
    docker container prune
    docker image prune
    docker build -t ${IMAGE_NAME} .
}

function dlogin
{
    checkArg $1
    if [ "$?" -eq 1 ]; then
        docker exec -it ${CONTAINER_NAME} bash
    else
        echo "Related container names:"
        docker ps --filter ancestor=${IMAGE_NAME}
    fi
}

addAutoComplete