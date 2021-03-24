#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

ARGUMENT_LIST=(
  "project-url"
  "contact-email"
)

if [[ $# -eq 0 ]]; then
    echo "Usage: " && \
    echo && \
    echo "`basename "$0"`\\" && \
    echo "        --project-url /some/custom/url" && \
    echo "        --contact-email a@test.com" && \
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
  --project-url)
    extra_vars="$extra_vars project_url=$2"
    shift 2
    ;;

  --contact-email)
    extra_vars="$extra_vars contact_email=$2"
    shift 2
    ;;

  *)
    break
    ;;
  esac
done

#running role directly without playbook
ansible localhost -v \
  --module-name include_role \
  --args name=rest_service_support \
  --extra-vars "${extra_vars} app_basedir=$app_basedir"
