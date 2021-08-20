Push project into an existing Git repo:
  ```shell
  cd existing_folder
  git init
  git config user.name "Your Name"
  git config user.email "YouEmail@domain.com"
  git remote add origin git@full.path.git
  git add .
  git commit -m "Initial commit"
  git push -u origin master
  ```
The certain commands you can find on the github/gitlab.

Note: do not config `user.name` and `user.email` globally if you use more than a single git host.

**Run from within the project base folder**: `gitSupport.sh` 

In the output you'll find actual information about expected parameters.


