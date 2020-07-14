# unattended_jenkins_image_build

Customized jenkins image build Dockerfile that lets you build a Jenkins docker image with (but not limited to) the following use cases:
1. Disable Jenkins Install Setup Wizard, and install the suggested plugins as seen by the setup wizard
2. Install a list of useful plugins, examples: periodicbackup, monitoring (JavaMelody), green-ball button,...
3. Groovy init scripts to be placed in reference (/usr/share/jenkins/ref/init.groovy.d) folder and later be copied to $JENKINS_HOME/init.grooy.d to:
3.1 create first admin user account
3.2 set baseURL
3.3 enable agent to master access control
4. The build script makes use of bash shell functions to download awscli v2, kops and terraform binaries so as to be copied to jenkins docker image
5. The jenkins docker image also includes typical tools including curl, git, jq, maven, tree, wget, zip, python3, pip3, ansible 2.9.10, jinja2, dnspython

# How to run
6. git clone https://github.com/garyttt/unattended_jenkins_image_build.git
7. cd unattended_jenkins_image_build
8. edit all .sh scripts, replace 'REPO=garyttt8' (my Docker Hub account) with your Docker Hub account 'REPO=yourdockerhubaccount'
9. ./jenkins_image_build.sh 1.0.0  # where 1.0.0 is the docker image tag you so desired
10. Go for a 15-min coffee break
