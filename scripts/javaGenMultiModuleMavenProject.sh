#!/usr/bin/env bash

source ansible.commons.sh

ARGUMENT_LIST=(
  "artifact-id"
  "group-id"
  "project-name"
  "contact-email"
  "project-desc-url"
  "project-description"
  "organization-name"
  "organization-url"
)

if [[ $# -eq 0 ]]; then
    echo "Usage: " && \
    echo && \
    echo "`basename "$0"` \\" && \
    echo "        --group-id com.company.your.great.project \\" && \
    echo "        --artifact-id my-great-project \\" && \
    echo "        --project-name \"My Project\" \\" && \
    echo "        --project-desc-url www.company.com/project \\" && \
    echo "        --project-description \"Some Project Description\" \\" && \
    echo "        --organization-name \"You Company Name\" \\" && \
    echo "        --organization-url www.company.com \\" && \
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
  --artifact-id)
    artifact_id=$2
    extra_vars="$extra_vars artifact_id=$2"
    shift 2
    ;;

  --group-id)
    extra_vars="$extra_vars group_id=$2"
    shift 2
    ;;

  --project-name)
    extra_vars="$extra_vars project_name=\"$2\""
    shift 2
    ;;

  --project-desc-url)
    extra_vars="$extra_vars project_desc_url=$2"
    shift 2
    ;;

  --project-description)
    extra_vars="$extra_vars project_description=\"$2\""
    shift 2
    ;;

  --organization-name)
    extra_vars="$extra_vars organization_name=\"$2\""
    shift 2
    ;;

  --organization-url)
    extra_vars="$extra_vars organization_url=$2"
    shift 2
    ;;

  *)
    break
    ;;
  esac
done

changePwd2AnsibleScriptsFolder $artifact_id

#  --ask-become-pass \
#ANSIBLE_KEEP_REMOTE_FILES=1 ansible-playbook \
#   --extra-vars "some-variable=${someValue}" \
ansible-playbook \
  -v \
  -i inventories/local \
  --extra-vars "${extra_vars} app_basedir=$app_basedir" \
  playbooks/runSingle.yml
