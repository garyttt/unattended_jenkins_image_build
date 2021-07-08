#!groovy
import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.Jenkins

def instance = Jenkins.instance
// the next line will set excludeClientIPFromCrumb to true by default
instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
instance.save()

/*
Ref 1: https://javadoc.jenkins-ci.org/hudson/security/csrf/DefaultCrumbIssuer.html

This script enable proxy compatibility, equivalent to:

Manage Jenkins, Configure Global Security
CSRF (Cross Script Site Forgery) Protection, Default Crumb Issuer, Enable proxy compatibility checked 

Rationale: Reverse proxy will work for issues related to CrumnIssuer
HTTP 403 No valid crumb was included in the request
*/
