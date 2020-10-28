### This project allows generating Java code for different layers

### Requirements

  To be able to generate code from any folder run once:
    `./scripts/extendPathWithScripsFolder.sh`

### Features:

1. [Generate Maven Multimodule Project](#1-generate-maven-project)
2. [Project configuration](#2-add-file-configuration-support)
3. [Jax Rs (Rest) Client Support](#3-add-jax-rs-rest-client-support)
4. [Jax Ws (Soap) Client Support](#4-add-jax-ws-soap-client-support)
5. [JEE Async support for long running jobs](#5-jee-async-support-for-long-running-jobs)
6. [Cron Jee Support](#6-cron-jee-support)
7. [Protect Web App with Auth](#7-add-authentication-support)
8. [Add deployment support](#8-add-deployment-support)

TODO (priority not clear):

- [Add Cryptography support](#99-todo-add-cryptography-support)

#### 1. Generate Maven Project

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
    
#### 2. Add file configuration support

  Run: `javaAddFileConfiguration.sh` 
  
  In the output you'll find an actual information about expected parameters.
  Prepare the full command and run from within you 
  `${projects}/${artifact-id}` folder
  
  **Note:** `config-folder-sys-variable` is a system variable that refers
  to the folder with a configuration file.
  
#### 3. Add Jax RS (rest) client support  

  Run: `javaAddCommonsJaxRsClient.sh` 
  
#### 4. Add Jax WS (soap) client support  

  Run: `javaAddCommonsJaxWsSoapClient.sh`   
  
#### 5. JEE Async support for long running jobs

  Run: `javaAddJeeAsyncSupport.sh`
  
#### 6. Cron Jee Support

  Run: `javaAddCronJobsSupport.sh`
  
#### 7. Add authentication support

  Run: `javaAddWebAuthentication.sh`
  In the output you'll find an actual information about expected parameters.
  
#### 8. Add deployment support
  
  Run: `javaMavenDeploymentSupport.sh`
  In the output you'll find an actual information about expected parameters.
  
  

## TODO (priority not clear):

#### 99. TODO Add Cryptography support
  
  Run: `javaCryptographySupport.sh`