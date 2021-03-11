#!/bin/bash

set -euo pipefail

image=${*:-paraviewclient/centos}

if [ -e /dev/nvidiactl ] ; then
	GPUARGS="--gpus all"
else
	GPUARGS=""
fi

HOME_MNT=${HOME_MNT:-$HOME}
DEFAULT_USER=${DEFAULT_USER:-$USER}
MAP_PASSGRP=${MAP_PASSGRP:-"-v /etc/passwd:/etc/passwd -v /etc/group:/etc/group"}

docker run --init -it --rm ${GPUARGS} -v /var/run/docker.sock:/var/run/docker.sock --tmpfs /buildtmp:exec -p 8888 -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent --security-opt seccomp=unconfined --cap-add=SYS_PTRACE -u $(id -u ${USER}):$(id -g ${USER}) -e USER=${DEFAULT_USER} -v ${HOME_MNT}:/home/${DEFAULT_USER} -w /home/${DEFAULT_USER}/ ${MAP_PASSGRP} -e HOME=/home/${DEFAULT_USER} --shm-size=1g $image /bin/bash
