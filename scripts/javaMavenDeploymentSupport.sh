#!/usr/bin/env bash

source $(dirname "$0")/commons.sh

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

changePwd2AnsibleJava $artifact_id

#  --ask-become-pass \
#ANSIBLE_KEEP_REMOTE_FILES=1 ansible-playbook \
#   --extra-vars "some-variable=${someValue}" \
ansible-playbook \
  -v \
  -i inventories/local \
  --extra-vars "${extra_vars} mvn_project_basedir=$mvn_project_basedir" \
  playbooks/javaMavenDeploymentSupport.yml
