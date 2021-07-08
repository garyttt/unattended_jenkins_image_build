# unattended_jenkins_image_build

Customized jenkins image build Dockerfile that lets you build a Jenkins docker image with (but not limited to) the following use cases:
1. Disable Jenkins Install Setup Wizard, and install the suggested plugins as seen by the setup wizard
2. Install a list of useful plugins, examples: periodicbackup, monitoring (JavaMelody), green-ball button,...
3. Groovy init scripts to be placed in reference (/usr/share/jenkins/ref/init.groovy.d) folder and later be copied to $JENKINS_HOME/init.grooy.d to:
* 3.1 create first admin user account
* 3.2 set baseURL
* 3.3 enable agent to master access control
* 3.4 set number of executors
4. The build script makes use of bash shell functions to download/install awscli v2 (in container), download kops and terraform binaries so as to be copied to jenkins docker image
5. The jenkins docker image also includes typical tools including curl, git, jq, maven, tree, wget, zip, python3, pip3, ansible 2.9.10, jinja2, dnspython

# How to build the image
6. "git clone https://github.com/garyttt/unattended_jenkins_image_build.git jenkins" using an account with uidNumber=1000 (jenkins)
7. cd jenkins/
8. edit all .sh scripts, replace 'REPO=garyttt8' (my Docker Hub account) with your Docker Hub account 'REPO=yourdockerhubaccount'
9. edit 01_set_baseURL.groovy, replace hostname in 'location.url' with your actual docker hostname
10. ./jenkins_image_build.sh 1.0.X # where 1.0.X is the docker image tag you so desired
11. go for a 30-min or so coffee break, preferably you rebuild during non-peak/lunch hour
12. you may inspect the docker_build.log post build for errors, note that warnings could usaully be ignored

# How to run the image 
13. ./jenkins_run.sh 1.0.X   # it is actually restarting jenkins, i.e. it calls ./jenkins_stop.sh first
14. docker run log file will be fetched continuously, you may Ctrl-C to break it

# How to access Jenkins
15. http://hostname:8080 (HTTP) or https://hostname:8083 (HTTPS), replace hostname with actual docker hostname, please change admin password ASAP. If you have set 'ENV JENKINS_OPTS "--prefix=/jenkins"' in dockerfile, then the access url will be http://hostname:8080/jenkins (HTTP) or https://hostname:8083/jenkins (HTTPS)

# How to backup/restore config changes between image builds
16. refer to 'Jenkins_Period_Backup_Config_Example.pdf' to quickly configure it, do not forget to validate cron syntax and existence of backup folder
17. take a on-demand config backup whenever you have made changes and note down the timestamp (drop list of recent timestamps is shown when you click 'restore')
18. if you even re-build the image and need the previous config. perform a restore

# How to enable HTTPS
19. first run 'generate_self_signed_jks.sh', then un-comment the related lines in dockerfile, re-build the image, as well as copy/paste the right lines in jenkins_run.sh, re-run to test

# Automate the automation server
20. You may automate these groovy scripts using JCasC Jenkins Configuration As Code plugin
* Ref 1: https://github.com/jenkinsci/jep/blob/master/jep/201/README.adoc
* Ref 2: https://github.com/jenkinsci/configuration-as-code-plugin
* Ref 3: https://docs.google.com/presentation/d/1VsvDuffinmxOjg0a7irhgJSRWpCzLg_Yskf7Fw7FpBg/edit?usp=sharing
