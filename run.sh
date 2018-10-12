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
echo "{\"@timestamp\": \"$(date)\", \"message\": \"${1}\"}"
}

function exec_log {
        OUTPUT=$(${1} 2>&1)
        EXIT=$?
        log "$EXIT" "$(echo $OUTPUT | tr '\n' '|')"
}

log "0" "Cloning git repo '${GIT_REPO}' to '${TMP_FOLDER}'"
exec_log "git clone --verbose --depth=1 ${GIT_REPO} ${TMP_FOLDER}"

if [ -n "${TARGET_NAMESPACE}" ]
then

    log "0" "Ensure namespace ${TARGET_NAMESPACE} execution context"
    KUBE_ATTRS="--namespace=${TARGET_NAMESPACE}"

fi

while true
do

    log "0" "Pulling git repo '${GIT_REPO}' to '${TMP_FOLDER}'"
    cd ${TMP_FOLDER} && exec_log "git pull --verbose --update-shallow"

    log "0" "Applying '${GIT_REPO}' repo against '${TARGET_NAMESPACE}' namespace"
    exec_log "kubectl apply ${KUBE_ATTRS} --filename=${TMP_FOLDER}"
    
    log "0" "Sleep for ${INTERVAL_SECONDS} seconds"
    sleep $INTERVAL_SECONDS

done
