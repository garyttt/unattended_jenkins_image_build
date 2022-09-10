#!groovy
import jenkins.security.s2m.AdminWhitelistRule
import jenkins.model.Jenkins

Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class)
.setMasterKillSwitch(false)

/*
Ref 1: https://wiki.jenkins.io/display/JENKINS/Slave+To+Master+Access+Control

This is to set a 'false' content to $JENKINS_HOME/secrets/slave-to-master-security-kill-switch
false means enabled
*/

