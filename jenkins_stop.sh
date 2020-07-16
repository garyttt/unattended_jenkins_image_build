#!/bin/bash
# jenkins_stop.sh

echo y | docker system prune
echo 'auto reply y to docker system prune'
CNM=jenkins
CID=`docker ps -a | grep $CNM | awk '{print $1":"$NF}' | cut -d':' -f1`
if [ -n "$CID" ]; then
  echo "Stopping and removing container $CNM"
  docker stop $CID || true
  docker rm $CID  || true
else
  echo "No container $CNM is found running" 
fi
