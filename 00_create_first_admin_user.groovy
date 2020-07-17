#!groovy
import jenkins.model.*
import hudson.security.*
import com.michelin.cio.hudson.plugins.rolestrategy.*

def adminUsername = System.getenv("JENKINS_FIRST_ADMIN_USER")
def adminPassword = System.getenv("JENKINS_FIRST_ADMIN_PASS")
println "--> creating first local admin user"

def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(adminUsername,adminPassword)
instance.setSecurityRealm(hudsonRealm)

//def strategy = new FullControlOnceLoggedInAuthorizationStrategy()	//not preferred
//def strategy = new GlobalMatrixAuthorizationStrategy()		//preferred, uncomment to use
def strategy = new RoleBasedAuthorizationStrategy()			//preferred, uncomment to use
strategy.add(Jenkins.ADMINISTER, adminUsername)
instance.setAuthorizationStrategy(strategy)

instance.save()

/*
Ref 1: https://stackoverflow.com/questions/41870688/automatically-setup-a-jenkins-2-32-1-server-with-a-script 
Ref 2: https://gist.github.com/fishi0x01/7c2d29afbaa0f16126eb4d4b35942f76
Matrix Authorization Strategy Plugin has full support for use in Configuration as Code and Job DSL.
Ref 3: https://plugins.jenkins.io/matrix-auth/
Project Based Matrix Authorization Strategy is an extension to the above, requires authorize-project plugin on top of matrix-auth
Ref 4: https://stackoverflow.com/questions/46497856/how-can-i-implement-project-based-matrix-security-in-jenkins-using-script
RBAC Role Based Access Control Authorization Strategy
Ref 5: https://plugins.jenkins.io/role-strategy/
*/

