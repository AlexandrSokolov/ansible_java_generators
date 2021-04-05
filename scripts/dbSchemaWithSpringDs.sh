#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

ARGUMENT_LIST=(
  "jpa-jndi-name"
)

if [[ $# -eq 0 ]]; then
    echo "Usage: " && \
    echo && \
    echo "`basename "$0"` --jpa-jndi-name java:/dbJndiName" && \
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
  --jpa-jndi-name)
    extra_vars="$extra_vars jpa_jndi_name=$2"
    shift 2
    ;;

  *)
    break
    ;;
  esac
done

ansible localhost -v \
  --module-name include_role \
  --args name=datasource_support \
  --extra-vars "${extra_vars} app_basedir=$app_basedir"