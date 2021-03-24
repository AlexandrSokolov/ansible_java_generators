function changePwd2AnsibleJava() {
  local ansible_scripts_location=`dirname "$0"`
  echo "The script you are running located in '${ansible_scripts_location}'"
  local pwd_path=$(pwd)
  echo "The present working directory is '${pwd_path}'"

  local artifact_id=$1
  if [[ "${pwd_path}" == *${artifact_id} ]]; then
    mvn_project_basedir=${pwd_path}
    echo "The present working directory ends with '${artifact_id}' artifact id,"
    echo "    -> it is considered as an existing maven project base dir:"
  else
    mvn_project_basedir=${pwd_path}/${artifact_id}
    echo "The present working directory does not end with '${artifact_id}' artifact id,"
    echo "    -> a new maven project base dir will be created:"
  fi
  echo
  echo "\${mvn_project_basedir}=${mvn_project_basedir}"

  # change the present working directory to the `bm_app` folder:
  cd "`dirname "$0"`"
  cd ..
  echo "The present working directory for running Ansible playbook has been switched to `pwd`"
}
