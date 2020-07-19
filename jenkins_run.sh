#!/bin/bash
# jenkins_run.sh

[ -z "$1" ] && echo "TAG is required" && exit 1
UIDNUMBER=`id -u`
[ $UIDNUMBER -ne 1000 ] && echo "Current user must be 1000 (jenkins) to avoid permission issue" && exit 1
./jenkins_stop.sh

REPO=garyttt8
IMAGE=jenkins
TAG=$1

docker run \
--name $IMAGE \
--detach \
--publish 8083:8083 \
--publish 50000:50000 \
--mount type=bind,src=$PWD/jenkins_home,dst=/var/jenkins_home \
--mount type=bind,src=$PWD/jenkins_config_backup,dst=/var/tmp/jenkins_config_backup \
--env JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Djava.util.logging.config.file=/var/jenkins_home/logging.properties" \
--env JENKINS_OPTS="--prefix=/ --httpPort=-1 --httpsPort=8083 --httpsKeyStore=/var/jenkins_home/selfsigned.jks --httpsKeyStorePassword=secret" \
--health-cmd "curl --insecure --head https://localhost:8083 && exit 0 || exit 1" \
--health-interval 5s \
--health-timeout 3s \
--health-retries 3 \
--health-start-period 2m \
$REPO/$IMAGE:$TAG 

docker logs -f $IMAGE

# HTTP or HTTPS please copy and paste as needed
# HTTP version
#--publish 8080:8080 \
#--health-cmd "curl --head http://localhost:8080 && exit 0 || exit 1" \
#--env JENKINS_OPTS="--prefix=/" \
# HTTPS version
#--env JENKINS_OPTS="--prefix=/ --httpPort=-1 --httpsPort=8083 --httpsKeyStore=/var/jenkins_home/selfsigned.jks --httpsKeyStorePassword=secret" \
#--publish 8083:8083 \
#--health-cmd "curl --insecure --head https://localhost:8083 && exit 0 || exit 1" \
