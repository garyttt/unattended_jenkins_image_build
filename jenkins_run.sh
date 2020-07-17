#!/bin/bash
# jenkins_run.sh

[ -z "$1" ] && echo "TAG is required" && exit 1
./jenkins_stop.sh

REPO=garyttt8
IMAGE=jenkins
TAG=$1

docker run \
--name $IMAGE \
--detach \
--publish 8080:8080 \
--mount type=bind,src=$PWD/jenkins_home,dst=/var/jenkins_home \
--mount type=bind,src=$PWD/jenkins_config_backup,dst=/var/tmp/jenkins_config_backup \
--env JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
--env JENKINS_OPTS="--prefix=/" \
--health-cmd "curl --head http://localhost:8080 && exit 0 || exit 1" \
--health-interval 5s \
--health-timeout 3s \
--health-retries 3 \
--health-start-period 2m \
$REPO/$IMAGE:$TAG 

docker logs -f $IMAGE

