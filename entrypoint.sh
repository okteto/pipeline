#!/bin/sh
set -e

name=$1
namespace=$2

if [ -z $GITHUB_REF ]; then
echo "fail to detect branch name"
exit 1
fi

repository=$GITHUB_REPOSITORY
branch=$(echo ${GITHUB_REF##*/})

params=""
if [ ! -z $namespace ]; then
params="--namespace=$namespace"
fi

echo running: okteto create pipeline --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait
okteto create pipeline --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait