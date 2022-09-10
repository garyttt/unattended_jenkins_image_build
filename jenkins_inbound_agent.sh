#!/bin/bash
# jenkins_inbound_agent.sh

# Pre-requisites: inbound agent (aka JNLP aka Jave WebStart agent)
# 1. Manage Jenkins / Configure Global Security / Agents, set 'TCP port for inbound agents' to Fixed:50000
# 2. checked 'Agent protocols' for 'InBound TCP Agent Protocol/4 (TLS encryption)'
# 3. click 'Apply'
# 4. Cretae the inbound (aka JNLP) agent in jenkins GUI and mote down the connection secret
# 5. Paste the secret as the 1st command argument here

usage() {
  echo "Usage: $0 <JENKINS_SECRET> <JENKINS_AGENT_NAME> [DOCKER_NETWORK]"
}

[ -z "$1" || -z "$2" ] && usage && exit 1
UIDNUMBER=`id -u`
[ $UIDNUMBER -ne 1000 ] && "Current user must be 1000 (jenkins) to avoid permission issue" && exit 1

. ~/.install/functions >/dev/null 2>&1
JENKINS_CONTAINER_NAME="jenkins"
JENKINS_MASTER_IP=`docker_ip ${JENKINS_CONTAINER_NAME} | awk '{print $2}'`
JENKINS_URL="http://${JENKINS_MASTER_IP}:8080"
JENKINS_SECRET="$1"
JENKINS_AGENT_NAME="$2"
JENKINS_AGENT_WORKDIR="/home/jenkins/agent"
# docker run must connect to network where jenkins master is running in, otherwise TCP connection will fail
[ -z "$NETWORK" ] && NETWORK=default || NETWORK="$3"


# --init true means the use of docker-init binary (tini launcher) as ENTRYPOINT
docker run --name ${JENKINS_AGENT_NAME} \
           --init --network ${NETWORK} jenkins/inbound-agent \
           -url ${JENKINS_URL} -workDir=${JENKINS_AGENT_WORKDIR} ${JENKINS_SECRET} ${JENKINS_AGENT_NAME}

#docker run --name jkagent01 --init --network $NETWORK jenkins/inbound-agent -url ${JENKINS_URL} -workDir "/home/jenkins/agent" f2543996aa65efb3ba539c2826abf9239e22f7da251b8c3fbd9cdd388fb953db jkagent01
