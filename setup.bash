#!/bin/bash
xhost +

RED='\033[0;31m'
NC='\033[0m' # No Color

function addAutoComplete()
{
    list=$(docker ps --filter ancestor=art_env_gui --format "{{.Names}}")
    list=$(echo "$list" | tr '\n' ' ')
    complete -W "${list}" dlogin
    complete -W "${list}" drm
}

_getSupportImages()
{
    COMPREPLY=(".")
    COMPREPLY+=("tseanliu/docker_env_gui:ubuntu18")
    COMPREPLY+=("tseanliu/docker_env_gui:ubuntu18_melodic")
    COMPREPLY+=("tseanliu/docker_env_gui:ubuntu20_noetic")
}
complete -F _getSupportImages drunintel

# Run docker on PC with Nvidia GPU
function drunnvidia()
{
    if [ "$?" -eq 2 ]; then
    docker run --gpus all -d \
        --name="$2" \
        --env="QT_X11_NO_MITSHM=1" \
        --env="DISPLAY" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --volume="$HOME/.ssh:/root/.ssh" \
        --volume="$HOME/Downloads:/home/Downloads" \
        "$1" \
        /bin/sh -c "sed -i "s/CMD_PROMPT_PREFIX=.*$/CMD_PROMPT_PREFIX=$2/" /root/.bashrc && while true; do sleep 10; done"
    fi
}

# Run docker on PC with Intel GPU
function drunintel
{
    if [ "$#" -eq 2 ]; then
        docker run -d \
            --name="$2" \
            -e DISPLAY=$DISPLAY \
            --volume="/tmp/.X11-unix:/tmp/.X11-unix" \
            --volume="$HOME/.ssh:/root/.ssh" \
            --volume="$HOME/Downloads:/home/Downloads" \
            "$1" \
            /bin/sh -c "sed -i "s/CMD_PROMPT_PREFIX=.*$/CMD_PROMPT_PREFIX=$2/" /root/.bashrc && while true; do sleep 10; done"
    else
        echo "Syntax: drunintel image_name container_name"
    fi
}

# Stop and remove container
function drm 
{
    if [ "$?" -eq 1 ]; then
        echo "Stopping $1"
        docker stop $1
        echo "Removing $1"
        docker rm $1
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

function prune
{
    docker container prune
    docker image prune
}

function dbuild
{
    if [ "$#" -eq 2 ]; then
        prune
        docker build --build-arg your_name=$USER -f $1 -t $2 .
    else
        echo "Syntax: dbuild Dockerfile tagname"
    fi
}

function dexec
{
    if [ "$#" -eq 1 ]; then
        docker exec -it $1 bash
    else
        echo "Related container names:"
        docker ps --filter ancestor=${IMAGE_NAME}
    fi
}

addAutoComplete
