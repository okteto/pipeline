#!/bin/sh
set -ex

name=$1
namespace=$2

if [ -z $GITHUB_REF ]; then
echo "fail to detect branch name"
exit 1
fi

repository=$GITHUB_REPOSITORY
echo ${GITHUB_REF}
b=$(git rev-parse --abbrev-ref HEAD)
echo $b

branch=$(echo ${GITHUB_REF##*/})

params=""
if [ ! -z $namespace ]; then
params="--namespace=$namespace"
fi

echo running: okteto create pipeline --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait
okteto create pipeline --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait
