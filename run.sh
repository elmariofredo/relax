#!/bin/sh

#
# Example usage
# ./run.sh git@git.example.com:deploy/namespaces/service_a.git service_a
#

set -eo pipefail

GIT_REPO=$1
TARGET_NAMESPACE=$2

TMP_FOLDER=/tmp-repo
KUBE_ATTRS=""
INTERVAL_SECONDS=180

git clone --verbose --depth=1 ${GIT_REPO} ${TMP_FOLDER}

if [ -n "${TARGET_NAMESPACE}" ]
then

    echo Ensure namespace ${TARGET_NAMESPACE} execution context

    KUBE_ATTRS="--namespace=${TARGET_NAMESPACE}"

fi

while true
do

    echo Pulling git repo \"${GIT_REPO}\" to \"${TMP_FOLDER}\"

    cd ${TMP_FOLDER} && git pull --verbose --update-shallow

    echo Applying \"${GIT_REPO}\" against \"${TARGET_NAMESPACE}\"

    kubectl apply ${KUBE_ATTRS} --filename=${TMP_FOLDER}

    sleep $INTERVAL_SECONDS

done

sleep $INTERVAL_SECONDS

