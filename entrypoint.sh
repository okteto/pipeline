#!/bin/sh
set -ex

name=$1
namespace=$2
repository=$GITHUB_REPOSITORY

if [ -z $GITHUB_REF ]; then
echo "fail to detect branch name"
exit 1
fi

branch=$(echo ${GITHUB_REF##*/})

if [ -z $name ]; then
name="${GITHUB_ACTION}-${GITHUB_RUN_NUMBER}"
fi

params=""
if [ ! -z $namespace ]; then
params="--namespace=$namespace"
fi



echo running: okteto pipeline on $(pwd)
okteto create pipeline --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait