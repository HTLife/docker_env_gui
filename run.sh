MOUNT_DOWNLOAD=/home/Downloads

docker run --gpus all -d \
        --name=ubuntu20_meshlab \
        --env="QT_X11_NO_MITSHM=1" \
        --env="DISPLAY" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --volume="$HOME/Downloads:$MOUNT_DOWNLOAD" \
        --volume="$HOME/.ssh:/root/.ssh" \
        tseanliu/docker_env_gui:ubuntu20_meshlab \
        /bin/sh -c "sed -i "s/CMD_PROMPT_PREFIX=.*$/CMD_PROMPT_PREFIX=$1/" /root/.bashrc && while true; do sleep 10; done"