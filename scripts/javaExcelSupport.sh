#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

#running role directly without playbook
ansible localhost -v \
  --module-name include_role \
  --args name=commons_excel \
  --extra-vars "${extra_vars} app_basedir=$app_basedir"