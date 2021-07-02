#!/bin/sh
set -ex

name=$1
namespace=$2
timeout=$3
skip_if_exists=$4
variables=$5

if [ -z $GITHUB_REF ]; then
echo "fail to detect branch name"
exit 1
fi

if [[ ! -z "$CUSTOM_CERTIFICATE" ]]; then
  echo "Custom certificate is provided"
  echo "$CUSTOM_CERTIFICATE" > /usr/local/share/ca-certificates/custom_certificate_crt
  update-ca-certificates
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

if [ "$skip_if_exists" == "true" ]; then
params="${params} --skip-if-exists"
fi

variable_params=""
if [ ! -z "${variables}" ]; then
  for ARG in $(echo "${variables}" | tr ',' '\n'); do
    variable_params="${variable_params} --var ${ARG}"
  done

  params="${params} $variable_params"
fi

export OKTETO_DISABLE_SPINNER=1

echo running: okteto pipeline deploy --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait
okteto pipeline deploy --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait
