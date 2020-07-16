#!/bin/bash
# jenkins_run.sh

[ -z "$1" ] && exit 1
./jenkins_stop.sh
REPO=garyttt8
IMAGE=jenkins
TAG=$1
# for content of FLAGS, do NOT use shorthands like -d, -p, -v, -e as it will throw unknown flags error, use full description
FLAGS=" 
--name $IMAGE
--detach
--publish 8080:8080
--mount type=bind,src=$PWD/jenkins_home,dst=/var/jenkins_home
--mount type=bind,src=$PWD/jenkins_config_backup,dst=/var/tmp/jenkins_config_backup
--env JAVA_OPTS=-Djenkins.install.runSetupWizard=false
--env JENKINS_OPTS=--prefix=/
"
docker run $FLAGS $REPO/$IMAGE:$TAG 
docker logs -f $IMAGE

