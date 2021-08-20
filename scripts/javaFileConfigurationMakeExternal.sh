#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

ARGUMENT_LIST=(
  "config-folder-sys-variable"
)

if [[ $# -eq 0 ]]; then
    echo "Usage: " && \
    echo && \
    echo "`basename "$0"` --config-folder-sys-variable condig.dir.var" && \
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

  *)
    break
    ;;
  esac
done

ansible localhost -v \
  --module-name include_role \
  --args name=project_external_file_configuration \
  --extra-vars "${extra_vars} app_basedir=$app_basedir"