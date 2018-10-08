#!/bin/sh

#
# Example usage
# ./run.sh git@git.example.com:deploy/namespaces/service_a.git service_a
#

GIT_REPO=$1
TARGET_NAMESPACE=$2

TMP_FOLDER=/tmp-repo
KUBE_ATTRS=""
INTERVAL_SECONDS=180

function log {
echo "{\"@timestamp\": \"$(date)\", \"message\": \"${1}\"
}

log "Cloning git repo '${GIT_REPO}' to '${TMP_FOLDER}'"
git clone --verbose --depth=1 ${GIT_REPO} ${TMP_FOLDER}

if [ -n "${TARGET_NAMESPACE}" ]
then

    log "Ensure namespace ${TARGET_NAMESPACE} execution context"
    KUBE_ATTRS="--namespace=${TARGET_NAMESPACE}"

fi

while true
do

    log "Pulling git repo '${GIT_REPO}' to '${TMP_FOLDER}'"
    cd ${TMP_FOLDER} && git pull --verbose --update-shallow

    log "Applying '${GIT_REPO}' repo against '${TARGET_NAMESPACE}' namespace"
    kubectl apply ${KUBE_ATTRS} --filename=${TMP_FOLDER}

    log "Sleep for ${INTERVAL_SECONDS} seconds"
    sleep $INTERVAL_SECONDS

done
