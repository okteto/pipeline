#!/bin/sh
set -ex

name=$1
namespace=$2
timeout=$3
skip_if_exists=$4
variables=$5
filename=$6

if [ -z $name ]; then
  echo "name parameter is mandatory"
  exit 1
fi

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert.crt
   update-ca-certificates
fi

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

if [ ! -z "$filename" ]; then
  params="${params} -f "${filename}""
fi

export OKTETO_DISABLE_SPINNER=1

log_level=$7
if [ ! -z "$log_level" ]; then
  if [ "$log_level" = "debug" ] || [ "$log_level" = "info" ] || [ "$log_level" = "warn" ] || [ "$log_level" = "error" ] ; then
    log_level="--log-level ${log_level}"
  else
    echo "log-level supported: debug, info, warn, error"
    exit 1
  fi
fi

# https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging
# https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
if [ "${RUNNER_DEBUG}" = "1" ]; then
  log_level="--log-level debug"
fi

output="okteto pipeline deploy $log_level --name "${name}" --branch="${branch}" --repository="${GITHUB_SERVER_URL}/${repository}" ${params} --wait"
echo running: $output
eval $output
