#!/bin/sh
set -ex

name=$1
namespace=$2
timeout=$3

if [ -z $GITHUB_REF ]; then
echo "fail to detect branch name"
exit 1
fi

repository=$GITHUB_REPOSITORY

if [ "${GITHUB_EVENT_NAME}" = "pull_request" ]; then
  branch=${GITHUB_HEAD_REF}
else
  branch=$(echo ${GITHUB_REF#refs/heads/})
fi

params=""
if [ ! -z $namespace ]; then
params="--namespace=$namespace"
fi

if [ ! -z $timeout ]; then
params="${params} --timeout=$timeout"
fi

export OKTETO_DISABLE_SPINNER=1

echo running: okteto pipeline deploy --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait
okteto pipeline deploy --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait
