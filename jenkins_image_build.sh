#!/bin/bash
# jenkins_image_build.sh

[ -z "$1" ] && exit 1

. ~/.install/functions
[ -d ./aws/ ] && rm -rf aws
download_awscli_v2
download_kops
download_terraform

REPO=garyttt8
IMAGE=jenkins
TAG=$1
OPTS="-f ${IMAGE}_image_build.dockerfile -t $REPO/$IMAGE:$TAG"
echo "Please be patience, it takes a while to initialize..."
START=`date`
docker build $OPTS . | tee docker_build.log
END=`date`
echo "Start: $START"
echo "End  : $END"

# Clean-up
[ -d ./aws/ ] && rm -rf aws
rm -f ./aws_*
rm -f ./kops
rm -f ./terraform
