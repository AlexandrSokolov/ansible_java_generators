function changePwd2AnsibleJava() {
  echo "The script you are running located in `dirname "$0"`"
  echo "The present working directory is `pwd`"

  artifact_id=$1
  mvn_project_basedir=$(pwd)/"${artifact_id}"

  # change the present working directory to the `bm_app` folder:
  cd "`dirname "$0"`"
  cd ..
  echo "The present working directory for running Ansible playbook has been switched to `pwd`"
}
