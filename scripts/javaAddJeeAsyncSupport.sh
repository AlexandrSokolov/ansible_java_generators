#!/usr/bin/env bash

source `dirname "$0"`/commons.sh

changePwd2AnsibleJava $artifact_id

#  --ask-become-pass \
#ANSIBLE_KEEP_REMOTE_FILES=1 ansible-playbook \
#   --extra-vars "some-variable=${someValue}" \
ansible-playbook \
  -v \
  -i inventories/local \
  --extra-vars "mvn_project_basedir=$mvn_project_basedir" \
  playbooks/javaAddJeeAsyncSupport.yml