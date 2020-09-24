#!/usr/bin/env bash

source $(dirname "$0")/commons.sh

ARGUMENT_LIST=(
  "security-domain"
  "security-role-name"
)

if [[ $# -eq 0 ]]; then
    echo "Usage: " && \
    echo && \
    echo "`basename "$0"` \\" && \
    echo "        --security-domain AppSecurityDomain \\" && \
    echo "        --security-role-name requiredRoleName \\" && \
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
  --security-domain)
    extra_vars="$extra_vars security_domain=$2"
    shift 2
    ;;

  --security-role-name)
    extra_vars="$extra_vars security_role_name=$2"
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
  playbooks/javaAddProjectAuth.yml
