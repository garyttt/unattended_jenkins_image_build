#!/bin/bash

# Assumsing file system bind mount of mapping host level $PWD/jenkins_home to container level /var/jenkins_home
# Java logging pre-defined levels in descending order of severity are: SERVERE, WARNING, INFO, CONFIG, FINE, FINER, FINEST
# default is INFO level

if [ -d $PWD/jenkins_home ]; then
cat > $PWD/jenkins_home/logging.properties <<EOF
handlers=java.util.logging.ConsoleHandler
jenkins.level=INFO
java.util.logging.ConsoleHandler.level=INFO
EOF
fi
