### This project allows generating Java code for different layers

  Note: to undo the code generation, run: 

  `git reset --hard && git clean -fd`

  Description:

  `git reset --hard` will undo both staged and unstaged changes.
      
  `git clean -fd` removes all untracked files and directories, '-f' is force, '-d' is remove directories.

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
- [Jpa Datasource Support](#jpa-datasource)

TODO (priority not clear):

- [Add Cryptography support](#99-todo-add-cryptography-support)

#### Generate Maven Project

  Run: `javaGenMultiModuleWarProject.sh`
  
  In the output you'll find actual information about expected parameters.
  Prepare the full command and run from within you `${projects}` folder

  **Notes**:
  
  - Split names in `artifact-id` with `-` symbol, 
    it should look like: `my-smart-project`. 
    Based on this name some other names are generated, like:
    `my-smart-project-rest-api`
    `my-smart-project-config`
    
  - `artifact-id` is used as a maven project base dir, 
    so a new project will be generated in `${projects}/${artifact-id}` folder
    
  After the project generation:
  - build the project, make sure it is built successfully
  - push project into an existing Git repo:
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
    The certain command you can find on the github/gitlab.
    
    Note: do not config `user.name` and `user.email` globally if you use more than a single git host.
  - write unit test via extending BaseTest
    
#### Add file configuration support

  Run: `javaAddFileConfiguration.sh` 
  
  In the output you'll find actual information about expected parameters.
  Prepare the full command and run from within you 
  `${projects}/${artifact-id}` folder

  Read `commons_config/README.md` and `test_app/README.md` for the description.

  You can also remove if you do not need:
  - `commons_config/README.md`
  - `commons_config/test`
  - `test_app/src/test/resources/test.{{ config_file_name }}` 
    if you do not use the same configuration for tests and prod environments
  - `commons_config/README.md`
  
  **Notes:** 
  1. `config-folder-sys-variable` is a system variable that refers
     to the folder with a configuration file.
  2. There is an issue in IntelliJ IDEA with `testResources`.
      
     It might be, that the `config` module is read incorrectly. 
     In the `.idea/misc.xml` file appears the line: `<file type="web" url="file://$PROJECT_DIR$/config" />`,
     which must not be there. The correct `component` section in `.idea/misc.xml` must look like:
     ```xml
      <?xml version="1.0" encoding="UTF-8"?>
      <project version="4">
        <component name="FrameworkDetectionExcludesConfiguration">
          <file type="web" url="file://$PROJECT_DIR$/front_end_war" />
          <file type="web" url="file://$PROJECT_DIR$/test_app/src/test/resources" />
        </component>
        ...
      </project>
     ```
     
     See [Idea module generations with shared resource](https://youtrack.jetbrains.com/issue/IDEA-256774)
  
#### Add Jax RS (rest) client support  

  Run: `javaAddCommonsJaxRsClient.sh` 
  
#### Add Jax WS (soap) client support  

  Run: `javaAddCommonsJaxWsSoapClient.sh`   
  
#### JEE Async support for long running jobs

  Run: `javaAddJeeAsyncSupport.sh`
  
#### Cron Jee Support

  Run: `javaAddCronJobsSupport.sh`

  Note: make you task interruptible, if you want to run it via cron. 
  Add async support for this.
  
#### Add authentication support

  Run: `javaAddWebAuthentication.sh`
  In the output you'll find actual information about expected parameters.

  **Note**: keep in mind, it is a good practice to protect rest services as well. 
  To do it correctly, both annotations must be applied to the service:
  ```
  import javax.annotation.security.RolesAllowed;
  import javax.ejb.Stateless;
  ..
  @Stateless //required to trigger @RolesAllowed
  @RolesAllowed(RestApp.ROLE)
  ```
  
#### Add deployment support
  
  Run: `javaMavenDeploymentSupport.sh`
  In the output you'll find actual information about expected parameters.
  
#### Excel Module support  

  Run: `javaExcelSupport.sh`

#### Jpa Datasource 

  Run: `javaAddJpaDatasource.sh`
  In the output you'll find actual information about expected parameters.

## TODO (priority not clear):

#### TODO Add Cryptography support
  
  Run: `javaCryptographySupport.sh`