#### Generate Maven Project

**Notes**:

- `artifact-id` is also used as a project base directory name.
  So a new project will be generated in `${pwd}/${artifact-id}` folder, for instance `projects/${artifact-id}`

- Split names in `artifact-id` with `-` symbol,
  it should look like: `my-smart-project` for instance.

  Based on this `my-smart-project` some other Maven artifacts like:
  `my-smart-project-rest-api`
  `my-smart-project-config`
  are generated.

- You can rename the project root directory name. `${project_folder}` variable is used as a reference for this folder.
  It doesn't affect the logic and other scripts.


**To generate multi-module Maven project**, run: 

`javaMvnMultiModuleProject.sh`

In the output you'll find actual information about expected parameters.
Prepare the full command and run from within you `${projects}` folder.

**After the project generation**, run:

`cd ${project_folder}`.

All other Ansible scripts get executed from within `${project_folder}` folder.

**Build the generated project** with: 

`mvn clean install` 

to make sure it is built successfully.