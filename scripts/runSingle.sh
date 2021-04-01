#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

ansible-playbook \
  -v \
  -i inventories/local \
  --extra-vars \
    "app_basedir=$app_basedir" \
  playbooks/runSingle.yaml