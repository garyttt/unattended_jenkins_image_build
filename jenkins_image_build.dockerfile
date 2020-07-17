# jenkins_image_build.dockerfile v1.0.0
FROM jenkins/jenkins:2.235.2-lts-jdk11
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"
ENV JENKINS_OPTS --prefix=/
# Define fisrt admin user/pass
ENV JENKINS_FIRST_ADMIN_USER admin
ENV JENKINS_FIRST_ADMIN_PASS 1amKohsuke!
# Docker build script will download kops, terraform (>0.12)and create download/install scriot for awscli v2
COPY kops /usr/local/bin/kops
COPY terraform /usr/local/bin/terraform
COPY download_install_awscli_v2.sh /usr/local/bin/download_install_awscli_v2.sh
# Pre-Create folder for periodicbackup plugin to backup ConfigOnly data
RUN mkdir -p /var/tmp/jenkins_config_backup
# Jenkins init.groovy.d scripts
RUN rm -f /usr/share/jenkins/ref/init.groovy.d/*.groovy
COPY 00_create_first_admin_user.groovy            /usr/share/jenkins/ref/init.groovy.d/
COPY 01_set_baseURL.groovy                        /usr/share/jenkins/ref/init.groovy.d/
COPY 02_enable_agent2master_access_control.groovy /usr/share/jenkins/ref/init.groovy.d/
# Install the same list as the suggested plugsins during default interactive initial login screen
# Sorted by plugin description
RUN /usr/local/bin/install-plugins.sh ant                             # Ant
RUN /usr/local/bin/install-plugins.sh build-timeout                   # Build Tumeout
RUN /usr/local/bin/install-plugins.sh credentials-binding             # Credentials Binding
RUN /usr/local/bin/install-plugins.sh cloudbees-folder                # Folders Plugin
RUN /usr/local/bin/install-plugins.sh git                             # Git
RUN /usr/local/bin/install-plugins.sh github-branch-source            # Github Branch Source
RUN /usr/local/bin/install-plugins.sh gradle                          # Gradle
RUN /usr/local/bin/install-plugins.sh email-ext                       # Email Extension
RUN /usr/local/bin/install-plugins.sh cloudbees-folder                # Folders Plugin
RUN /usr/local/bin/install-plugins.sh ldap                            # LDAP Plugin
RUN /usr/local/bin/install-plugins.sh mailer                          # Mailer Plugin
RUN /usr/local/bin/install-plugins.sh matrix-auth                     # Matrix Authorization Strategy
RUN /usr/local/bin/install-plugins.sh antisamy-markup-formatter       # OWSASP Markup Formatter
RUN /usr/local/bin/install-plugins.sh pam-auth                        # PAM Authentication Plugin
RUN /usr/local/bin/install-plugins.sh workflow-aggregator             # Pipeline
RUN /usr/local/bin/install-plugins.sh pipeline-github-lib             # Pipeline: Github Groovy Libraries
RUN /usr/local/bin/install-plugins.sh workflow-durable-task-step      # Pipeline: Node and Processes
RUN /usr/local/bin/install-plugins.sh pipeline-stage-view             # Pipeline: Stage View Plugin
RUN /usr/local/bin/install-plugins.sh ssh-credentials                 # SSH Credentials Plugin
RUN /usr/local/bin/install-plugins.sh ssh-slaves                      # SSH Build Agents
RUN /usr/local/bin/install-plugins.sh timestamper                     # Timestamper
RUN /usr/local/bin/install-plugins.sh trilead-api                     # Trilead API Plugin
RUN /usr/local/bin/install-plugins.sh ws-cleanup                      # Workspace Cleanup
# SCM, Builds, Job DSL, Pipeline, Workflows
RUN /usr/local/bin/install-plugins.sh git-parameter
RUN /usr/local/bin/install-plugins.sh groovy
RUN /usr/local/bin/install-plugins.sh job-dsl
RUN /usr/local/bin/install-plugins.sh maven-plugin
RUN /usr/local/bin/install-plugins.sh parameterized-trigger
RUN /usr/local/bin/install-plugins.sh pipeline-utility-steps
RUN /usr/local/bin/install-plugins.sh ssh-agent	# SSH Agent Plugin: provides SSH credentials to builds
RUN /usr/local/bin/install-plugins.sh workflow-multibranch
# Backup Jenkins Configuration
RUN /usr/local/bin/install-plugins.sh periodicbackup
# Java Memory Monitoring (JavaMelody)
RUN /usr/local/bin/install-plugins.sh monitoring
# Project or RBAC Role Based Access Control Authorization Strategies
RUN /usr/local/bin/install-plugins.sh authorize-project
RUN /usr/local/bin/install-plugins.sh role-strategy
# Artifact, Packaging
RUN /usr/local/bin/install-plugins.sh nexus-jenkins-plugin
# Alerts, Notifications and Publishing
RUN /usr/local/bin/install-plugins.sh mailer
RUN /usr/local/bin/install-plugins.sh slack
RUN /usr/local/bin/install-plugins.sh htmlpublisher
# Credentials Binding: to use 'withCredntials, OAuth
RUN /usr/local/bin/install-plugins.sh oauth-credentials
# UI
RUN /usr/local/bin/install-plugins.sh greenballs # Changes Hudson to use green balls instead of blue for successful builds
RUN /usr/local/bin/install-plugins.sh simple-theme-plugin # Customize appearance with custom CSS and JavaScript, replace Favicon
# Cloud: AWS
RUN /usr/local/bin/install-plugins.sh aws-credentials
RUN /usr/local/bin/install-plugins.sh aws-bucket-credentials
# Docker
RUN /usr/local/bin/install-plugins.sh docker-plugin
RUN /usr/local/bin/install-plugins.sh docker-build-publish
RUN /usr/local/bin/install-plugins.sh docker-compose-build-step
# Kubernetes
RUN /usr/local/bin/install-plugins.sh kubernetes
RUN /usr/local/bin/install-plugins.sh kubernetes-cli
# Deployment
RUN /usr/local/bin/install-plugins.sh ansible
RUN /usr/local/bin/install-plugins.sh ansible-tower
# Infrastructure As Code
RUN /usr/local/bin/install-plugins.sh terraform
# Active Directory
RUN /usr/local/bin/install-plugins.sh active-directory
# Container/OWASP security scanning
RUN /usr/local/bin/install-plugins.sh aqua-security-scanner
RUN /usr/local/bin/install-plugins.sh aqua-microscanner
RUN /usr/local/bin/install-plugins.sh dependency-check-jenkins-plugin
# Install various tools: python3, pip3, curl, git, jq, maven, tree, unzip, wget, zip, ansible/jinja2/dnspythonn... 
# Group all packages on same command line to reduce image size
USER root
RUN apt-get update && \
  apt-get install -y python3 python3-pip curl git jq maven tree unzip wget zip && \
  pip3 install ansible==2.9.10 jinja2 dnspython && \
  /usr/local/bin/download_install_awscli_v2.sh
USER jenkins
# Set the $HOME of jenkins user
WORKDIR /var/jenkins_home
# Health Check got to use --head (Show document info only), otherwise it may throw 'anonymousi' access permission denied 
HEALTHCHECK --interval=5s --timeout=3s --retries=3 --start-period=2m CMD "curl --head http://localhost:8080 && exit 0 || exit 1"
