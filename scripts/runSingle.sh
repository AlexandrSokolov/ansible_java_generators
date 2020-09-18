#!/usr/bin/env bash

source `dirname "$0"`/commons.sh

changePwd2AnsibleJava

#  --ask-become-pass \
#ANSIBLE_KEEP_REMOTE_FILES=1 ansible-playbook \
#   --extra-vars "some_variable=${someValue}" \
ansible-playbook \
  -v \
  -i inventories/local \
  playbooks/runSingle.yml