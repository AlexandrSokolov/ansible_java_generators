#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

#running role directly without playbook
ansible localhost -v \
  --module-name include_role \
  --args name=jax_rs_client \
  --extra-vars "app_basedir=$app_basedir"