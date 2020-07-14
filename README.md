# unattended_jenkins_image_build

Customized jenkins image build Dockerfile that lets you build a Jenkins docker image with (but not limited to) the following use cases:
. Disable Jenkins Install Setup Wizard, and install the suggested plugins as seen by the setup wizard
. Install a list of useful plugins, examples: periodicbackup, monitoring (JavaMelody), green-ball button,...
. Groovy init scripts to be placed in reference (/usr/share/jenkins/ref/init.groovy.d) folder and later be copied to $JENKINS_HOME/init.grooy.d to:
.. create first admin user account
.. set baseURL
.. enable agent to master access control
(in .groovy useful links are provided for further information)
. The build script makes use of bash shell functions to download awscli v2, kops and terraform binaries so as to be copied to jenkins docker image
. The jenkins docker image also include typical tools including curl, git, jq, maven, tree, wget, zip, python3, pip3, ansible 2.9.10, jinja2, dnspython

1. git clone https://github.com/garyttt/unattended_jenkins_image_build.git
2. cd unattended_jenkins_image_build
3. edit all .sh scripts, replace 'REPO=garyttt8' (my Docker Hub account) with your Docker Hub account 'REPO=yourdockerhubaccount'
4. ./jenkins_image_build.sh 1.0.0 (where 1.0.0 is the docker image tag so desired)
