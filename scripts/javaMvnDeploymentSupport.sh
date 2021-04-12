#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

ARGUMENT_LIST=(
  "release-repository-id"
  "release-repository-url"
)

if [[ $# -eq 0 ]]; then
    echo "Usage: " && \
    echo && \
    echo "`basename "$0"` \\" && \
    echo "        --release-repository-id custom-release-repository \\" && \
    echo "        --release-repository-url \"https://nexus.some.system.com/content/repositories/releases\" \\" && \
    exit 1
fi

# read arguments
opts=$(
  getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set --$opts

extra_vars=""

while [[ $# -gt 0 ]]; do
  case "$1" in
  --release-repository-id)
    extra_vars="$extra_vars release_repository_id=$2"
    shift 2
    ;;

  --release-repository-url)
    extra_vars="$extra_vars release_repository_url=$2"
    shift 2
    ;;

  *)
    break
    ;;
  esac
done

ansible localhost -v \
  --module-name include_role \
  --args name=mvn_deployment \
  --extra-vars "${extra_vars} app_basedir=$app_basedir"