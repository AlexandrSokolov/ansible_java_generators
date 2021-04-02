#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

ansible localhost -v \
  --module-name include_role \
  --args name=project_file_configuration_rest \
  --extra-vars "${extra_vars} app_basedir=$app_basedir"