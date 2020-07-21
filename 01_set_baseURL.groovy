#!groovy
import jenkins.model.JenkinsLocationConfiguration
import jenkins.model.Jenkins

JenkinsLocationConfiguration location = Jenkins.instance.getExtensionList('jenkins.model.JenkinsLocationConfiguration')[0]
// Assumption: 'jenkins' is the docker-compose service name for jenkins master and thus will resolve to its runtime IP
// HTTP
location.url = 'http://jenkins:8080/'
// HTTPS
// location.url = 'https://jenkins:8083/'
location.save()

/*
Ref 1: https://gist.github.com/fishi0x01/7c2d29afbaa0f16126eb4d4b35942f76
*/

