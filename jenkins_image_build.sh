#!/bin/bash
# jenkins_image_build.sh

[ -z "$1" ] && echo "TAG is required" && exit 1

START=`date`
. ./functions

# download_install_awscli_v2.sh script will be copied to /usr/local/bin of container and runas root in container
touch download_install_awscli_v2.sh
chmod 750 download_install_awscli_v2.sh
display_shell_function download_awscli_v2 >download_install_awscli_v2.sh
display_shell_function install_awscli_v2 >>download_install_awscli_v2.sh
echo "install_awscli_v2" >>download_install_awscli_v2.sh
sed -i 's/sudo //g' download_install_awscli_v2.sh    # container does not have sudo installed
echo "rm -rf ./aws" >>download_install_awscli_v2.sh  # clean-up 100M+ of ./aws v2 source files
download_kops
download_terraform

REPO=garyttt8
IMAGE=jenkins
TAG=$1
OPTS="-f ${IMAGE}_image_build.dockerfile -t $REPO/$IMAGE:$TAG"
echo "Please be patience, it takes a while to initialize..."
docker build $OPTS . | tee docker_build.log
END=`date`
echo "Start: $START"
echo "End  : $END"

# Clean-up
rm -f ./kops
rm -f ./terraform
