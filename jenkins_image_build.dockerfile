# jenkins_image_build.dockerfile tag: 2.535-jdk17
# Ref: https://github.com/jenkinsci/docker/blob/master/README.md
FROM jenkins/jenkins:2.535-jdk17
WORKDIR /var/jenkins_home
# Prior to running docker build, run the ONE-TIME generate_self_signed_jks.sh manually to generate the selfsigned.jks
# Un-comment the next 3 lines to enable HTTPS, do not set httpPort to -1 just in case we also need HTTP
COPY selfsigned.jks /var/jenkins_home
ENV JENKINS_OPTS="--prefix=/jenkins --httpPort=8080 --httpsPort=8083 --httpsKeyStore=/var/jenkins_home/selfsigned.jks --httpsKeyStorePassword=secret"
EXPOSE 8083
# Define fisrt admin user/pass
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Xmx4g"
ENV JENKINS_FIRST_ADMIN_USER=admin
ENV JENKINS_FIRST_ADMIN_PASS=1amKohsuke!
ENV TZ=Asia/Singapore
# Docker build customization: for examples you may copy terraform (>1.0) and script for awscli v2 download/install, un-comment the COPY lines if needed
COPY terraform /usr/local/bin/terraform
COPY download_install_awscli_v2.sh /var/tmp/download_install_awscli_v2.sh
# Install the same list as the suggested plugsins during default interactive initial login screen
# Sorted by plugin description
RUN jenkins-plugin-cli --plugins build-timeout                   # Build Timeout
RUN jenkins-plugin-cli --plugins credentials-binding             # Credentials Binding
RUN jenkins-plugin-cli --plugins cloudbees-folder                # Folders Plugin
RUN jenkins-plugin-cli --plugins git                             # Git
RUN jenkins-plugin-cli --plugins github-branch-source            # Github Branch Source
RUN jenkins-plugin-cli --plugins gradle                          # Gradle
RUN jenkins-plugin-cli --plugins email-ext                       # Email Extension
RUN jenkins-plugin-cli --plugins ldap                            # LDAP Plugin
RUN jenkins-plugin-cli --plugins mailer                          # Mailer Plugin
RUN jenkins-plugin-cli --plugins matrix-auth                     # Matrix Authorization Strategy
RUN jenkins-plugin-cli --plugins antisamy-markup-formatter       # OWSASP Markup Formatter
RUN jenkins-plugin-cli --plugins pam-auth                        # PAM Authentication Plugin
RUN jenkins-plugin-cli --plugins workflow-aggregator             # Pipeline
RUN jenkins-plugin-cli --plugins workflow-cps                    # Pipeline: Groovy
RUN jenkins-plugin-cli --plugins pipeline-github-lib             # Pipeline: Github Groovy Libraries
RUN jenkins-plugin-cli --plugins workflow-durable-task-step      # Pipeline: Node and Processes
RUN jenkins-plugin-cli --plugins pipeline-stage-view             # Pipeline: Stage View Plugin
RUN jenkins-plugin-cli --plugins ssh-credentials                 # SSH Credentials Plugin
RUN jenkins-plugin-cli --plugins ssh-slaves                      # SSH Build Agents
RUN jenkins-plugin-cli --plugins timestamper                     # Timestamper
RUN jenkins-plugin-cli --plugins trilead-api                     # Trilead API Plugin
RUN jenkins-plugin-cli --plugins ws-cleanup                      # Workspace Cleanup
# SCM, Builds, Job DSL, Pipeline, Workflows, GITHub Integration
RUN jenkins-plugin-cli --plugins git-parameter
RUN jenkins-plugin-cli --plugins groovy
RUN jenkins-plugin-cli --plugins job-dsl
RUN jenkins-plugin-cli --plugins maven-plugin
RUN jenkins-plugin-cli --plugins parameterized-trigger
RUN jenkins-plugin-cli --plugins pipeline-utility-steps
RUN jenkins-plugin-cli --plugins pipeline-stage-tags-metadata
RUN jenkins-plugin-cli --plugins ssh-agent                       # SSH Agent Plugin: provides SSH credentials to builds
RUN jenkins-plugin-cli --plugins workflow-multibranch
RUN jenkins-plugin-cli --plugins workflow-scm-step               # Workflow SCM Step
RUN jenkins-plugin-cli --plugins workflow-support                # Pipeline Supporting APIs
RUN jenkins-plugin-cli --plugins command-launcher                # Command Agent Launcher
RUN jenkins-plugin-cli --plugins jaxb                            # JAXB packaging for more transparent Java 9+ compatibility 
RUN jenkins-plugin-cli --plugins jdk-tool                        # Oracle Java SE Development Kit Installer
# RUN jenkins-plugin-cli --plugins windows-slaves                  # WMI Windows Agent
RUN jenkins-plugin-cli --plugins github-pullrequest
# RUN jenkins-plugin-cli --plugins pipeline-aws                    # Pipeline AWS Steps
RUN jenkins-plugin-cli --plugins pipeline-maven                  # Pipeline Maven Integration
RUN jenkins-plugin-cli --plugins pipeline-npm                    # Pipeline NPM
RUN jenkins-plugin-cli --plugins pipeline-model-definition       # Pipeline Declarative
RUN jenkins-plugin-cli --plugins pipeline-model-extensions       # Pipeline Declaratve Extension Points API
RUN jenkins-plugin-cli --plugins pipeline-model-api              # Pipeline Model API
# Strict Crumb Issuer Plugin to help with Web Security (CSRF Cross Site Request Forging attacks and External Reverse Proxy)
RUN jenkins-plugin-cli --plugins strict-crumb-issuer
# Backup Jenkins Configuration
RUN jenkins-plugin-cli --plugins thinBackup
# Java Memory Monitoring (JavaMelody), Metrics, View-Job-Filters, Test-Results-Analyzer, Multi-Test-Results-Report, Performance
RUN jenkins-plugin-cli --plugins monitoring
RUN jenkins-plugin-cli --plugins metrics
RUN jenkins-plugin-cli --plugins view-job-filters
RUN jenkins-plugin-cli --plugins test-results-analyzer
# RUN jenkins-plugin-cli --plugins bootstraped-multi-test-results-report
# RUN jenkins-plugin-cli --plugins junit
# RUN jenkins-plugin-cli --plugins perfpublisher
# Project or RBAC Role Based Access Control Authorization Strategies
RUN jenkins-plugin-cli --plugins authorize-project
RUN jenkins-plugin-cli --plugins role-strategy                    # Role-based Authorization Strategy (RBAC) 
# Artifact, Packaging
# RUN jenkins-plugin-cli --plugins nexus-jenkins-plugin
RUN jenkins-plugin-cli --plugins atlassian-bitbucket-server-integration
RUN jenkins-plugin-cli --plugins jackson2-api
RUN jenkins-plugin-cli --plugins json-path-api
RUN jenkins-plugin-cli --plugins pipeline-maven-api
# Alerts, Notifications and Publishing
RUN jenkins-plugin-cli --plugins mailer
RUN jenkins-plugin-cli --plugins slack
RUN jenkins-plugin-cli --plugins htmlpublisher
# Credentials Binding: to use 'withCredntials, OAuth
RUN jenkins-plugin-cli --plugins oauth-credentials
# UI
RUN jenkins-plugin-cli --plugins simple-theme-plugin # Customize appearance with custom CSS and JavaScript, replace Favicon
# Webhook
RUN jenkins-plugin-cli --plugins generic-webhook-trigger
# Cloud: AWS, Elastic Container Services
# RUN jenkins-plugin-cli --plugins aws-credentials
# RUN jenkins-plugin-cli --plugins aws-bucket-credentials
# RUN jenkins-plugin-cli --plugins amazon-ecs
# Docker
RUN jenkins-plugin-cli --plugins docker-plugin
RUN jenkins-plugin-cli --plugins docker-build-publish
RUN jenkins-plugin-cli --plugins docker-compose-build-step
RUN jenkins-plugin-cli --plugins docker-workflow                 # Docker Pipeline 
# Kubernetes
# RUN jenkins-plugin-cli --plugins kubernetes
# RUN jenkins-plugin-cli --plugins kubernetes-cli
# Deployment
RUN jenkins-plugin-cli --plugins ansible
RUN jenkins-plugin-cli --plugins ansible-tower
# Infrastructure As Code
RUN jenkins-plugin-cli --plugins terraform
# Active Directory
RUN jenkins-plugin-cli --plugins active-directory
# Container/OWASP security scanning
# RUN jenkins-plugin-cli --plugins aqua-security-scanner
RUN jenkins-plugin-cli --plugins aqua-microscanner
RUN jenkins-plugin-cli --plugins dependency-check-jenkins-plugin
# JCasC Jenkins Configuration As Code 
RUN jenkins-plugin-cli --plugins configuration-as-code
RUN jenkins-plugin-cli --plugins configuration-as-code-groovy
# Pipeline As YAML
RUN jenkins-plugin-cli --plugins pipeline-as-yaml
# HashiCorp Vault Pipeline
RUN jenkins-plugin-cli --plugins hashicorp-vault-pipeline
# Git Server / Client
RUN jenkins-plugin-cli --plugins git-server
RUN jenkins-plugin-cli --plugins git-client
# Additional
RUN jenkins-plugin-cli --plugins pipeline-model-definition
RUN jenkins-plugin-cli --plugins docker-workflow
# SSH Server
# RUN jenkins-plugin-cli --plugins sshd
#
# Install various tools: python3, pip3, curl, git, jq, maven, tree, unzip, vim, wget, zip, ansible/jinja2/dnspython... 
# HTTPS SSL Ciphers suppoet: apt-transport-https ca-certificates gnupg2 software-properties-common 
# Pre-Create folder for periodicbackup plugin to backup ConfigOnly data, please 'enable' it in GUI
# Group all packages on same command line to reduce image size`
USER root
RUN set -x && \
  apt-get update && \
  apt-get install -y apt-transport-https ca-certificates python3 python3-pip python3-jinja2 python3-dnspython curl git gnupg2 jq maven tree software-properties-common unzip vim wget zip tzdata && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get upgrade && \
  mkdir -p /var/tmp/jenkins_config_backup && \
  chown 1000:1000 /var/tmp/jenkins_config_backup && \
  ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime && \
  bash /var/tmp/download_install_awscli_v2.sh || true
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
