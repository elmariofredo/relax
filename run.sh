#!/bin/sh

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
        OUTPUT=$(sh -c "${1}" 2>&1)
        EXIT=$?
        log "$EXIT" "$(echo $OUTPUT | tr '\n' '|'| sed 's/"/\\"/g')" "${1}"
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
        log "0" "Fetch and reset git repo '${GIT_REPO}' to '${TMP_FOLDER}'"
        cd ${TMP_FOLDER} && exec_log "git fetch --verbose"
        cd ${TMP_FOLDER} && exec_log "git reset --hard origin/${GIT_BRANCH}"

    else

        log "0" "No tmp folder found ${TMP_FOLDER}"

    fi


    FILES_COUNT=$(find  ${TMP_FOLDER}/${GIT_FOLDER} |egrep  -c ".yaml|.yml|.json")
    if [[ ${FILES_COUNT} -ne 0 ]]
    then

	log "0" "Applying '${GIT_REPO}' repo against '${TARGET_NAMESPACE}' namespace (directory ${TMP_FOLDER}/${GIT_FOLDER})"
        exec_log "unset HTTP_PROXY; unset HTTPS_PROXY; unset http_proxy; unset https_proxy; kubectl apply ${KUBE_ATTRS} -R --filename=${TMP_FOLDER}/${GIT_FOLDER}"

    else

	log "0" "No manifest files found in directory ${TMP_FOLDER}/${GIT_FOLDER}"

    fi

    log "0" "Sleep for ${INTERVAL_SECONDS} seconds"
    sleep $INTERVAL_SECONDS

done
