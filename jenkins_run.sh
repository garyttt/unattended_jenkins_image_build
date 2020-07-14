#!/bin/bash
# jenkins_run.sh

[ -x "$1" ] && exit 1
./jenkins_stop.sh
REPO=garyttt8
IMAGE=jenkins
TAG=$1
# for content of FLAGS, do NOT use shorthands like -d, -p, -v, -e as it will throw unknown flags error, use full description
FLAGS=" 
--name $IMAGE
--detach
--publish 8080:8080
--env JAVA_ARGS=-Xmx2048m
--env JAVA_OPTS=-Djenkins.install.runSetupWizard=false
--env JENKINS_OPTS=--prefix=/
"
docker run $FLAGS $REPO/$IMAGE:$TAG 
docker logs -f $IMAGE

