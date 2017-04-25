#!/bin/bash

# Edit these constants
APP_NAME="app"

NUM_OF_APP_CONTAINERS=2
DEPLOYMENT_TIME=10
DIR=${PWD##*/}
C_DIR="${DIR//-}"

# End of edit

docker-compose pull $APP_NAME # Use (docker-compose build $APP_NAME if you use a custom image)
docker-compose scale $APP_NAME=$(($NUM_OF_APP_CONTAINERS*2))

sleep $DEPLOYMENT_TIME

FIRST_APP_CONTAINER_NUM=`docker inspect --format='{{.Name}}' $(docker ps -q) | grep $APP_NAME | awk -F  "_" '{print $NF}' | sort | head -1`

T_NUM=$(($FIRST_APP_CONTAINER_NUM+$NUM_OF_APP_CONTAINERS))

while [ $FIRST_APP_CONTAINER_NUM -lt $T_NUM ]
do
   docker stop "$C_DIR"_"$APP_NAME"_"$FIRST_APP_CONTAINER_NUM"
   docker rm "$C_DIR"_"$APP_NAME"_"$FIRST_APP_CONTAINER_NUM"
   FIRST_APP_CONTAINER_NUM=$(( $FIRST_APP_CONTAINER_NUM + 1 ))
done
