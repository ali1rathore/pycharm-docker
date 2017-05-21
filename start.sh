#!/bin/bash
set -e

IMAGE=pycharm
[[ ! -z "$NAME" ]] || NAME=pycharm
IP=$(ifconfig en0 inet | grep inet | awk '{print $2'})

SNAP_DEV=/Users/dev/sparklinedata

open -a XQuartz
xhost + $IP

docker run -it -d \
        --name ${NAME} \
	-v ${SNAP_DEV}:/home/developer/code \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=${IP}:0.0 \
	${IMAGE} \
        pycharm.sh

echo "Container $NAME of image $IMAGE started"
