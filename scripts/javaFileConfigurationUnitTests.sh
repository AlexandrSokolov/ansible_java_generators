#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

ansible localhost -v \
  --module-name include_role \
  --args name=file_configuration_unit_tests \
  --extra-vars "${extra_vars} app_basedir=$app_basedir"