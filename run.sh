#!/bin/bash

#
# Example usage
# ./run.sh git@git.example.com:deploy/namespaces/service_a.git service_a
#

GIT_REPO=$1
TARGET_NAMESPACE=$2
GIT_BRANCH=${3-master}
GIT_FOLDER=${4}

TMP_FOLDER=/tmp-repo
KUBE_ATTRS=""
INTERVAL_SECONDS=180

function log {
echo "{\"@timestamp\": \"$(date)\", \"exit_code\": \"${1}\", \"message\": \"${2}\", \"cmd\": \"${3}\"}"
}

function exec_log {
        OUTPUT=$(${1} 2>&1)
        EXIT=$?
        log "$EXIT" "$(echo $OUTPUT | tr '\n' '|')" "${1}"
}

if [ -n "${TARGET_NAMESPACE}" ]
then

    log "0" "Ensure namespace ${TARGET_NAMESPACE} execution context"
    KUBE_ATTRS="--namespace=${TARGET_NAMESPACE}"

fi

while true
do

    if [ ! -d "$TMP_FOLDER" ]
    then

        log "0" "Cloning git repo '${GIT_REPO}' to '${TMP_FOLDER}'"
        exec_log "git clone --verbose  --single-branch --branch ${GIT_BRANCH} ${GIT_REPO} ${TMP_FOLDER}"

    fi

    if [ ! -z "$(ls -A ${TMP_FOLDER})" ]
    then
        log "0" "Pulling git repo '${GIT_REPO}' to '${TMP_FOLDER}'"
        cd ${TMP_FOLDER} && exec_log "git pull --verbose --update-shallow"

    fi

    FILES_COUNT=$(find  ${TMP_FOLDER}/${GIT_FOLDER} |egrep  -c ".yaml|.yml|.json")
    if [[ ${FILES_COUNT} -ne 0 ]]
    then

        log "0" "Applying '${GIT_REPO}' repo against '${TARGET_NAMESPACE}' namespace"
        exec_log "kubectl apply ${KUBE_ATTRS} -R --filename=${TMP_FOLDER}/${GIT_FOLDER}"

    fi

    log "0" "Sleep for ${INTERVAL_SECONDS} seconds"
    sleep $INTERVAL_SECONDS

done
