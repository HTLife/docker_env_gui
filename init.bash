#!/bin/bash

if [ -z $IMAGE_NAME ];
    then
        echo Please input default image / container name
        read IMAGE_NAME
        CONTAINER_NAME=$IMAGE_NAME
fi        

sed -i "s;IMAGE_NAME=.*$;IMAGE_NAME=$IMAGE_NAME;" setup.bash
sed -i "s;CONTAINER_NAME=.*$;CONTAINER_NAME=$CONTAINER_NAME;" setup.bash

echo "Variables in setup.bash is modified successfully."