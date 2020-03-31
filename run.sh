#!/bin/bash

. config

<< comment
docker run useful options: 
  --name
  --rm
  --detach 
  -h
  --network=host
  -v path:path
  --add-host name:ip
  --restart=always
  --entrypoint exec_cmd
  --publish port:port
  -it 
comment

<<comment
  -v /dev:/dev
  -v /dev/pts:/dev/pts
  -e "DISPLAY"
  -e "QT_X11_NO_MITSHM=1"
  -e "XAUTHORITY=/tmp/docker.xauth"
comment

rm -rf docker.xauth
touch docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f docker.xauth nmerge -
chown 1000:1000 docker.xauth

cmd="
docker run 
  --name $name
  ${rm:+--rm}
  -h ${name}
  --network=${network}
  -v /etc/resolv.conf:/etc/resolv.conf
  -v /advwork:/advwork
  -v $(pwd)/docker.xauth:/tmp/docker.xauth:rw
  -e "DISPLAY"
  -e "QT_X11_NO_MITSHM=1"
  -e "XAUTHORITY=/tmp/docker.xauth"
  ${detach:+--detach}
  ${privileged:+--privileged}
  --add-host ${name}:127.0.1.1
  -it $repo $runcmd
"

$cmd

