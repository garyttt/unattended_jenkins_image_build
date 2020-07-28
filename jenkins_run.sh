#!/bin/bash
# jenkins_run.sh

[ -z "$1" ] && echo "TAG is required" && exit 1
UIDNUMBER=`id -u`
[ $UIDNUMBER -ne 1000 ] && echo "Current user must be 1000 (jenkins) to avoid permission issue" && exit 1
cp -p [0-9][0-9]_*.groovy $PWD/jenkins_home/init.groovy.d >/dev/null 2>&1  # copy changes
./jenkins_stop.sh
./jenkins_config_logging.sh

REPO=garyttt8
IMAGE=jenkins
TAG=$1

docker run \
--name $IMAGE \
--detach \
--publish 8080:8080 \
--publish 50000:50000 \
--publish 8083:8083 \
--publish 50022:50022 \
--mount type=bind,src=$PWD/jenkins_home,dst=/var/jenkins_home \
--mount type=bind,src=$PWD/jenkins_config_backup,dst=/var/tmp/jenkins_config_backup \
--env JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Djava.util.logging.config.file=/var/jenkins_home/logging.properties" \
--env JENKINS_OPTS="--prefix=/jenkins --httpPort=-1 --httpsPort=8083 --httpsKeyStore=/var/jenkins_home/selfsigned.jks --httpsKeyStorePassword=secret" \
--env TZ=Asia/Singapore \
--health-cmd "curl --insecure --head http://localhost:8080 && exit 0 || exit 1" \
--health-interval 5s \
--health-timeout 3s \
--health-retries 3 \
--health-start-period 2m \
$REPO/$IMAGE:$TAG 

docker logs -f $IMAGE

# Revert back to http, copy the below to replace the above
#--env JENKINS_OPTS="--prefix=/jenkins --httpPort=8080 httpsPort=-1" \

# For sone reason httpsCertificate and httpsPrivateLey do not work
# Sp please replace
#--env JENKINS_OPTS="--prefix=/jenkins --httpPort=-1 --httpsPort=8083 --httpsCertificate=/var/jenkins_home/server.crt --httpsPrivateKey=/var/jenkins_home/server.key" \
# with
#--env JENKINS_OPTS="--prefix=/jenkins --httpPort=-1 --httpsPort=8083 --httpsKeyStore=/var/jenkins_home/selfsigned.jks --httpsKeyStorePassword=secret" \