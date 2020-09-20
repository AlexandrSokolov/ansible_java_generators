#!/usr/bin/env bash

source `dirname "$0"`/commons.sh

artifact_id=ans-test

changePwd2AnsibleJava $artifact_id

#  --ask-become-pass \
#ANSIBLE_KEEP_REMOTE_FILES=1 ansible-playbook \
#   --extra-vars "some-variable=${someValue}" \
ansible-playbook \
  -v \
  -i inventories/local \
  --extra-vars \
    "group_id=com.savdev.ans.test.project \
    artifact_id=${artifact_id} \
    project_name=\"Ansible Generated Test Project\" \
    project_url=/my/custom/url \
    mvn_project_basedir=$mvn_project_basedir \
    " \
  playbooks/javaAddFileConfiguration.yml