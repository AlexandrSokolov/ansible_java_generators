#!/usr/bin/env bash

# works only when this script is invoked as: './scripts/extendPathWithScripsFolder.sh'
source ./scripts/commons.sh

changePwd2AnsibleJava

# /full/path/to/bm_app/scripts
script_path=$(pwd)/scripts

profile_file=~/.profile

if grep -q $script_path $profile_file
  then
    echo "Already added in the $script_path"
  else
    echo $'\n'PATH=\$PATH:"$script_path" >> $profile_file
fi

cd "$curr_pwd"
echo "The present working directory is returned to: `pwd`"

echo "Run manually to apply changes without restart: "
echo ". ~/.profile"