#!groovy
import jenkins.model.JenkinsLocationConfiguration
import jenkins.model.Jenkins

JenkinsLocationConfiguration location = Jenkins.instance.getExtensionList('jenkins.model.JenkinsLocationConfiguration')[0]
// HTTP
// location.url = 'http://gigantor:8080/'
// HTTPS
location.url = 'https://gigantor:8083/'
location.save()

/*
Ref 1: https://gist.github.com/fishi0x01/7c2d29afbaa0f16126eb4d4b35942f76
*/

