#!/bin/bash
# jenkins_image_build.sh

[ -z "$1" ] && exit 1

. ./functions
[ ! -d aws/ ] && download_awscli_v2
# Install locally
./aws/install --bin-dir ./aws-bin --install-dir ./aws-cli --update
cp -p ./aws-cli/v2/2.*/bin/aws           ./aws_bin
cp -p ./aws-cli/v2/2.*/bin/aws_completer ./aws_completer
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
[ -d aws/ ] && rm -rf aws
[ -d aws-bin/ ] && rm -rf aws-bin
[ -d aws-cli/ ] && rm -rf aws-cli
rm -f ./aws_*
rm -f ./kops
rm -f ./terraform
