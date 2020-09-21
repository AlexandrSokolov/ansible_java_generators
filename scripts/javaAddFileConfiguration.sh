#!/usr/bin/env bash

source `dirname "$0"`/commons.sh

ARGUMENT_LIST=(
  "config-folder-sys-variable"
  "config-file-name"
)

if [[ $# -eq 0 ]]; then
    echo "Usage: " && \
    echo && \
    echo "`basename "$0"` \\" && \
    echo "        --config-folder-sys-variable condig.dir \\" && \
    echo "        --config-file-name my.properties" && \
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
  --config-folder-sys-variable)
    extra_vars="$extra_vars config_folder_path=$2"
    shift 2
    ;;

  --config-file-name)
    extra_vars="$extra_vars config_file_name=$2"
    shift 2
    ;;

  *)
    break
    ;;
  esac
done

changePwd2AnsibleJava $artifact_id

#  --ask-become-pass \
#ANSIBLE_KEEP_REMOTE_FILES=1 ansible-playbook \
#   --extra-vars "some-variable=${someValue}" \
ansible-playbook \
  -v \
  -i inventories/local \
  --extra-vars "${extra_vars} mvn_project_basedir=$mvn_project_basedir" \
  playbooks/javaAddFileConfiguration.yml