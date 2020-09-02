#!/bin/sh
set -ex

name=$1
namespace=$2
repository=$3
branch=$4

params=""

if [ ! -z $namespace ]; then
params="--namespac=$namespace"
fi

echo running: okteto pipeline on $(pwd)
okteto create pipeline --branch=${branch} --repository=https://github.com/${repository} ${params} --wait