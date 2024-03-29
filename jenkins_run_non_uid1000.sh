#!/bin/bash
# jenkins_run.sh

[ -z "$1" ] && echo "TAG is required" && exit 1
UIDNUMBER=`id -u`
#[ $UIDNUMBER -ne 1000 ] && echo "Current user must be 1000 (jenkins) to avoid permission issue" && exit 1
[ -d $PWD/jenkins_home/init.groovy.d ] && cp -p [0-9][0-9]_*.groovy $PWD/jenkins_home/init.groovy.d >/dev/null 2>&1  # copy changes
[ ! -d $PWD/jenkins_home ] && mkdir -p $PWD/jenkins_home && chgrp docker $PWD/jenkins_home && chmod 775 $PWD/jenkins_home
[ ! -d $PWD/jenkins_config_backup ] && mkdir -p $PWD/jenkins_config_backup && chgrp docker $PWD/jenkins_config_backup && chmod 775 $PWD/jenkins_config_backup
./jenkins_stop.sh || true
./jenkins_config_logging.sh || true

REPO=garyttt8
IMAGE=jenkins
TAG=$1

docker run \
--user $UIDNUMBER \
--name $IMAGE \
--detach \
--publish 8080:8080 \
--publish 50000:50000 \
--mount type=bind,src=$PWD/jenkins_home,dst=/var/jenkins_home \
--mount type=bind,src=$PWD/jenkins_config_backup,dst=/var/tmp/jenkins_config_backup \
--env JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Djava.util.logging.config.file=/var/jenkins_home/logging.properties" \
--env JENKINS_OPTS="--prefix=/jenkins" \
--env TZ=Asia/Singapore \
--health-cmd "curl --insecure --head http://localhost:8080/jenkins && exit 0 || exit 1" \
--health-interval 5s \
--health-timeout 3s \
--health-retries 3 \
--health-start-period 2m \
$REPO/$IMAGE:$TAG 

[ $? -eq 0 ] && docker logs -f $IMAGE

# https
#--publish 8083:8083 \
#--env JENKINS_OPTS="--prefix=/jenkins --httpPort=-1 --httpsPort=8083 --httpsKeyStore=/var/jenkins_home/selfsigned.jks --httpsKeyStorePassword=secret" \
#--health-cmd "curl --insecure --head https://localhost:8083/jenkins && exit 0 || exit 1" \
