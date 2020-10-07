#### 1. Preperation

  To be able to generate code from any folder run once:
    `./scripts/extendPathWithScripsFolder.sh`

#### 2. Generate Maven Project

  Run: `javaGenMultiModuleWarProject.sh`
  
  In the output you'll find an actual information about expected parameters.
  Prepare the full command and run from within you `${projects}` folder

  **Notes**:
  
  - Split names in `artifact-id` with `-` symbol, 
    it should look like: `my-smart-project`. 
    Based on this name some other names are generated, like:
    `my-smart-project-rest-api`
    `my-smart-project-config`
    
  - `artifact-id` is used as a maven project base dir, 
    so a new project will be generated in `${projects}/${artifact-id}` folder
    
#### 3 Add file configuration support

  Run: `javaAddFileConfiguration.sh` 
  
  In the output you'll find an actual information about expected parameters.
  Prepare the full command and run from within you 
  `${projects}/${artifact-id}` folder
  
  **Note:** `config-folder-sys-variable` is a system variable that refers
  to the folder with a configuration file.
  
#### 4 Add Jax RS (rest) client support  

  Run: `javaAddCommonsJaxRsClient.sh` 
  
#### 5 Add Jax WS (soap) client support  

  Run: `javaAddCommonsJaxWsSoapClient.sh`   
  
#### 6 JEE Async support for long running jobs

  Run: `javaAddJeeAsyncSupport.sh`
  
#### 7 Add authentication support

  Run: `javaAddWebAuthentication.sh`
  In the output you'll find an actual information about expected parameters.
  
#### 8 Add deployment support
  
  Run: `javaMavenDeploymentSupport.sh`
  In the output you'll find an actual information about expected parameters.