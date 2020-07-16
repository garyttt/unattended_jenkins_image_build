#!/bin/bash
# jenkins_stop.sh

echo y | docker system prune
CNM=jenkins
CID=`docker ps -a | grep $CNM | awk '{print $1":"$NF}' | cut -d':' -f1`
if [ -n "$CID" ]; then
  docker stop $CID || true
  docker rm $CID  || true
else
  echo "Container $CNM is not running" 
fi
