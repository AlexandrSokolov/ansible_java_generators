#!/usr/bin/env bash

source $(dirname "$0")/commons.sh

ARGUMENT_LIST=(
  "artifact-id"
  "group-id"
  "git-connection"
  "project-name"
  "project-url"
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
    echo "        --git-connection git@github.com:SomeUser/some-git-repo-url.git \\" && \
    echo "        --project-name \"My Project\" \\" && \
    echo "        --project-url /my/project/url \\" && \
    echo "        --project-desc-url www.company.com/project \\" && \
    echo "        --project-description \"Some Project Description\" \\" && \
    echo "        --organization-name \"You Company Name\" \\" && \
    echo "        --organization-url www.company.com \\" && \
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
  --artifact-id)
    artifact_id=$2
    extra_vars="$extra_vars artifact_id=$2"
    shift 2
    ;;

  --group-id)
    extra_vars="$extra_vars group_id=$2"
    shift 2
    ;;

  --project-url)
    extra_vars="$extra_vars project_url=$2"
    shift 2
    ;;

  --git-connection)
    extra_vars="$extra_vars git_connection=$2"
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

  --contact-email)
    extra_vars="$extra_vars contact_email=$2"
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
  playbooks/javaGenMultiModuleWarProject.yml
