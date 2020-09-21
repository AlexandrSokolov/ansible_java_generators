#### 1. Preperation

  To be able to generate code from any folder run once:
    `./scripts/extendPathWithScripsFolder.sh`

#### 2. Generate Maven Project

  Run: `javaGenMultiModuleWarProject.sh`
  
  In the output you'll find an actual information about expected parameters.
  Prepare the full command and run from within you ${projects} folder

  **Notes**:
  
  - Split names in `artifact-id` with `-` symbol, 
    it should look like: `my-smart-project`. 
    Based on this name some other names are generated, like:
    `my-smart-project-rest-api`
    `my-smart-project-config`
    
  - `artifact-id` is used as a maven project base dir, 
    so a new project will be generated in `${projects}/${artifact-id}` folder
    
####  