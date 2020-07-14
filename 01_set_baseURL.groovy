#!groovy
import jenkins.model.JenkinsLocationConfiguration
import jenkins.model.Jenkins

JenkinsLocationConfiguration location = Jenkins.instance.getExtensionList('jenkins.model.JenkinsLocationConfiguration')[0]
location.url = 'http://localhost:8080/'
location.save()

/*
Ref 1: https://gist.github.com/fishi0x01/7c2d29afbaa0f16126eb4d4b35942f76
*/

