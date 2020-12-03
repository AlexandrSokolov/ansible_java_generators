### This project allows generating Java code for different layers

### Requirements

  To be able to generate code from any folder run once:
    `./scripts/extendPathWithScripsFolder.sh`

### Features:

- [Generate Maven Multimodule Project](#generate-maven-project)
- [Project configuration](#add-file-configuration-support)
- [Jax Rs (Rest) Client Support](#add-jax-rs-rest-client-support)
- [Jax Ws (Soap) Client Support](#add-jax-ws-soap-client-support)
- [JEE Async support for long running jobs](#jee-async-support-for-long-running-jobs)
- [Cron Jee Support](#cron-jee-support)
- [Protect Web App with Auth](#add-authentication-support)
- [Add deployment support](#add-deployment-support)
- [Excel Support](#excel-module-support)

TODO (priority not clear):

- [Add Cryptography support](#99-todo-add-cryptography-support)

#### Generate Maven Project

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
    
#### Add file configuration support

  Run: `javaAddFileConfiguration.sh` 
  
  In the output you'll find an actual information about expected parameters.
  Prepare the full command and run from within you 
  `${projects}/${artifact-id}` folder
  
  **Notes:** 
  1. `config-folder-sys-variable` is a system variable that refers
     to the folder with a configuration file.
  2. The configuration of `testResources` is commented out in the parent `pom.xml`
     Open the project in IntelliJ IDEA first, 
     update Maven configuration, 
     and only then uncomment the configuration.
     
     See [Idea module generations with shared resource](https://youtrack.jetbrains.com/issue/IDEA-256774)
  
#### Add Jax RS (rest) client support  

  Run: `javaAddCommonsJaxRsClient.sh` 
  
#### Add Jax WS (soap) client support  

  Run: `javaAddCommonsJaxWsSoapClient.sh`   
  
#### JEE Async support for long running jobs

  Run: `javaAddJeeAsyncSupport.sh`
  
#### Cron Jee Support

  Run: `javaAddCronJobsSupport.sh`
  
#### Add authentication support

  Run: `javaAddWebAuthentication.sh`
  In the output you'll find an actual information about expected parameters.
  
#### Add deployment support
  
  Run: `javaMavenDeploymentSupport.sh`
  In the output you'll find an actual information about expected parameters.
  
#### Excel Module support  

  Run: `javaExcelSupport.sh`

## TODO (priority not clear):

#### TODO Add Cryptography support
  
  Run: `javaCryptographySupport.sh`