#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

ARGUMENT_LIST=(
  "git-connection"
)

if [[ $# -eq 0 ]]; then
    echo "Usage: " && \
    echo && \
    echo "`basename "$0"` --git-connection git@github.com:SomeUser/some-git-repo-url.git" && \
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
  --git-connection)
    extra_vars="$extra_vars git_connection=$2"
    shift 2
    ;;


  *)
    break
    ;;
  esac
done

ansible-playbook \
  -v \
  -i inventories/local \
  --extra-vars "${extra_vars} app_basedir=$app_basedir" \
  playbooks/gitSupport.yaml
