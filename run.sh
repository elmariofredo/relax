#!/bin/sh

set -e
set -o
set -o pipefail

GIT_REPO=$1
TARGET_NAMESPACE=$2
TMP_FOLDER=/tmp-repo

echo Cloning git repo \"${GIT_REPO}\" to \"${TMP_FOLDER}\"

git clone --quiet --depth=1 ${GIT_REPO} ${TMP_FOLDER}

echo Applying \"${GIT_REPO}\" against \"${TARGET_NAMESPACE}\"

kubectl apply --namespace=${TARGET_NAMESPACE} --filename=${TMP_FOLDER}
