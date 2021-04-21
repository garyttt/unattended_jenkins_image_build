# jenkins_image_build.dockerfile tag: 2.277.1-lts-jdk11
# Ref: https://github.com/jenkinsci/docker/blob/master/README.md
FROM jenkins/jenkins:2.277.3-lts-jdk11
WORKDIR /var/jenkins_home
# Prior to running docker build, run the ONE-TIME generate_self_signed_jks.sh manually to generate the selfsigned.jks
# Un-comment the next 3 lines to enable HTTPS, do not set httpPort to -1 just in case we also need HTTP
COPY selfsigned.jks /var/jenkins_home
ENV JENKINS_OPTS "--prefix=/jenkins --httpPort=8080 --httpsPort=8083 --httpsKeyStore=/var/jenkins_home/selfsigned.jks --httpsKeyStorePassword=secret"
EXPOSE 8083
# Define fisrt admin user/pass
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"
ENV JENKINS_FIRST_ADMIN_USER admin
ENV JENKINS_FIRST_ADMIN_PASS 1amKohsuke!
# Docker build script will download kops, terraform (>0.12) and create download/install scriot for awscli v2
COPY kops /usr/local/bin/kops
COPY terraform /usr/local/bin/terraform
COPY download_install_awscli_v2.sh /var/tmp/download_install_awscli_v2.sh
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
# SCM, Builds, Job DSL, Pipeline, Workflows, GITHub Integration
RUN /usr/local/bin/install-plugins.sh git-parameter
RUN /usr/local/bin/install-plugins.sh groovy
RUN /usr/local/bin/install-plugins.sh job-dsl
RUN /usr/local/bin/install-plugins.sh maven-plugin
RUN /usr/local/bin/install-plugins.sh parameterized-trigger
RUN /usr/local/bin/install-plugins.sh pipeline-utility-steps
RUN /usr/local/bin/install-plugins.sh ssh-agent                       # SSH Agent Plugin: provides SSH credentials to builds
RUN /usr/local/bin/install-plugins.sh workflow-multibranch
RUN /usr/local/bin/install-plugins.sh command-launcher                # Command Agent Launcher
RUN /usr/local/bin/install-plugins.sh external-monitor-job            # External Monitor Job Type
RUN /usr/local/bin/install-plugins.sh jaxb                            # JAXB packaging for more transparent Java 9+ compatibility 
RUN /usr/local/bin/install-plugins.sh jdk-tool                        # Oracle Java SE Development Kit Installer
RUN /usr/local/bin/install-plugins.sh windows-slaves                  # WMI Windows Agent
RUN /usr/local/bin/install-plugins.sh jenkins-multijob-plugin
RUN /usr/local/bin/install-plugins.sh github-pullrequest
RUN /usr/local/bin/install-plugins.sh pipeline-aws                    # Pipeline AWS Steps
RUN /usr/local/bin/install-plugins.sh pipeline-maven                  # Pipeline Maven
RUN /usr/local/bin/install-plugins.sh pipeline-npm                    # Pipeline NPM
# Strict Crumb Issuer Plugin to help with Web Security (CSRF Cross Site Request Forging attacks and External Reverse Proxy)
RUN /usr/local/bin/install-plugins.sh strict-crumb-issuer
# Backup Jenkins Configuration
RUN /usr/local/bin/install-plugins.sh periodicbackup
# Java Memory Monitoring (JavaMelody), Metrics, View-Job-Filters, Test-Results-Analyzer, Multi-Test-Results-Report, Performance
RUN /usr/local/bin/install-plugins.sh monitoring
RUN /usr/local/bin/install-plugins.sh metrics
RUN /usr/local/bin/install-plugins.sh view-job-filters
RUN /usr/local/bin/install-plugins.sh test-results-analyzer
RUN /usr/local/bin/install-plugins.sh bootstraped-multi-test-results-report
RUN /usr/local/bin/install-plugins.sh performance
RUN /usr/local/bin/install-plugins.sh junit
RUN /usr/local/bin/install-plugins.sh perfpublisher
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
# Cloud: AWS, Elastic Container Services
RUN /usr/local/bin/install-plugins.sh aws-credentials
RUN /usr/local/bin/install-plugins.sh aws-bucket-credentials
RUN /usr/local/bin/install-plugins.sh amazon-ecs
# Docker
RUN /usr/local/bin/install-plugins.sh docker-plugin
RUN /usr/local/bin/install-plugins.sh docker-build-publish
RUN /usr/local/bin/install-plugins.sh docker-compose-build-step
RUN /usr/local/bin/install-plugins.sh docker-workflow                 # Docker Pipeline 
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
# JCasC Jenkins Configuration As Code 
RUN /usr/local/bin/install-plugins.sh configuration-as-code
RUN /usr/local/bin/install-plugins.sh configuration-as-code-groovy
# Pipeline As YAML
RUN /usr/local/bin/install-plugins.sh pipeline-as-yaml
# HashiCorp Vault Pipeline
RUN /usr/local/bin/install-plugins.sh hashicorp-vault-pipeline
# Install various tools: python3, pip3, curl, git, jq, maven, tree, unzip, vim, wget, zip, ansible/jinja2/dnspythonn... 
# HTTPS SSL Ciphers suppoet: apt-transport-https ca-certificates gnupg2 software-properties-common 
# Pre-Create folder for periodicbackup plugin to backup ConfigOnly data, please 'enable' it in GUI
# Group all packages on same command line to reduce image size`
USER root
RUN set -x && \
  apt-get update && \
  apt-get install -y apt-transport-https ca-certificates python3 python3-pip curl git gnupg2 jq maven tree software-properties-common unzip vim wget zip && \
  rm -rf /var/lib/apt/lists/* && \
  pip3 install ansible==2.9.10 jinja2 dnspython && \
  apt-get upgrade && \
  mkdir -p /var/tmp/jenkins_config_backup && \
  chown 1000:1000 /var/tmp/jenkins_config_backup && \
  bash /var/tmp/download_install_awscli_v2.sh
USER jenkins
# Jenkins init.groovy.d scripts, if you make changes, please also copy the changes to $DOCKER_HOST:$PWD/jenkins_home/init.groovy.d/
# You may automate these groovy scripts using JCasC Jenkins Configuration As Code plugin - automate the automation server
# Ref 1: https://github.com/jenkinsci/jep/blob/master/jep/201/README.adoc
# Ref 2: https://github.com/jenkinsci/configuration-as-code-plugin
# Ref 3: https://docs.google.com/presentation/d/1VsvDuffinmxOjg0a7irhgJSRWpCzLg_Yskf7Fw7FpBg/edit?usp=sharing
COPY 00_create_first_admin_user.groovy            /usr/share/jenkins/ref/init.groovy.d/
COPY 01_set_baseURL.groovy                        /usr/share/jenkins/ref/init.groovy.d/
COPY 02_enable_agent2master_access_control.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY 03_set_NumExecutors.groovy                   /usr/share/jenkins/ref/init.groovy.d/
COPY 04_enable_proxy_compatibility.groovy         /usr/share/jenkins/ref/init.groovy.d/
# Health Check got to use --head (Show document info only), otherwise it may throw 'anonymous' access permission denied 
HEALTHCHECK --interval=5s --timeout=3s --retries=3 --start-period=2m CMD "curl --insecure --head http://localhost:8080 && exit 0 || exit 1"
