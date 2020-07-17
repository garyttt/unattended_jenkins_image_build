#!/bin/bash
# jenkins_image_build.sh

[ -z "$1" ] && echo "TAG is required" && exit 1

. ./functions
touch download_install_awscli_v2.sh
chmod 755 download_install_awscli_v2.sh
display_shell_function download_awscli_v2 >download_install_awscli_v2.sh
display_shell_function install_awscli_v2 >>download_install_awscli_v2.sh
echo "install_awscli_v2" >>download_install_awscli_v2.sh
sed -i 's/sudo //g' download_install_awscli_v2.sh
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
rm -f ./kops
rm -f ./terraform
