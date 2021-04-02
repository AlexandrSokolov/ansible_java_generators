### This project allows generating Java code for different layers

  Note: to undo the code generation, run: 

  `git reset --hard && git clean -fd`

  Description:

  `git reset --hard` will undo both staged and unstaged changes.
      
  `git clean -fd` removes all untracked files and directories, '-f' is force, '-d' is remove directories.

### Requirements

  Make sure you installed common Ansible roles and scripts, see [Ansible Commons Roles README](https://github.com/AlexandrSokolov/ansible-commons-roles)

  To be able to generate code from any folder run once:
    `./scripts/extendPathWithScripsFolder.sh`

### Features:

- [Generate Maven Multimodule Project](#generate-maven-project)
- [Add Git Support](#git-support)
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

  Run: `javaGenMultiModuleMavenProject.sh`
  
  In the output you'll find actual information about expected parameters.
  Prepare the full command and run from within you `${projects}` folder.

  **Notes**:
  
  - Split names in `artifact-id` with `-` symbol, 
    it should look like: `my-smart-project`. 
    
    Based on this name some other names are generated, like:
    `my-smart-project-rest-api`
    `my-smart-project-config`
    
  - `artifact-id` is used as a project base directory. 
    So a new project will be generated in `${projects}/${artifact-id}` folder
    
  - All other Ansible scripts run from within the project base folder.

  After the project generation via Ansible, build it, make sure it is built successfully.
    
  The script generates `commons_test` module for sharing test resources. 
  To be able to extend the `BaseTest` class in your modules, add the following into the dependencies:
  ```xml
      <!-- TEST -->
      <dependency>
        <groupId>your.project.group.id</groupId>
        <artifactId>your-project-artifact-id-commons-test</artifactId>
        <version>${project.version}</version>
        <classifier>tests</classifier>
        <type>test-jar</type>
        <scope>test</scope>
      </dependency>
  ```
  To share your tests sources between the other modules add to the module with the test sources:
  ```xml
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-jar-plugin</artifactId>
    </plugin>
  ```
  Read [Guide to using attached tests](http://maven.apache.org/guides/mini/guide-attached-tests.html) for more details.

#### Git support

  Run from within the project base folder: `gitSupport.sh`

  In the output you'll find actual information about expected parameters.

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

#### Add file configuration support

Run: `javaAddFileConfiguration.sh`

In the output you'll find actual information about expected parameters.
Prepare the full command and run from within you
`${projects}/${artifact-id}` folder

Note: `config-folder-sys-variable` is a system variable that refers
to the folder that contains the configuration file.

After the code generation, remove the following folders if you do not need them:
- `app_config/src/test/{{ group_id_path }}/config/commons` 
- `app_config/src/test/resources/test.config.properties`
Note make sure that `AppBaseTest` still exists.

By default, a property file is stored in the resources of the jar file. See 5.2.1.
If you plan to use it externally, see 5.2.2.

Usage:

###### 1 Create a properties file:
```
test.key1=test.value1
test.key2=test.value2
test.key4=23
test.key.list=item1|item2|item3
test.key.list.custom=item1,item2,item3
test.key.map=key1->value1|key2->value2|key3->value3
test.key.custom.map=key1&value1|key2&value2


# constructs Map<String, List<String>>
test.key.map.of.lists=key1->\
    value1&value2&value3|\
  key2->\
    value2|key3->value4&value5

# constructs Map<String, Map<String, String>>
test.key.map.of.maps=key1->\
      subkey1>value1&\
      subkey2>value2|\
  key2->\
    subkey3>value2|\
  key3->\
    subkey4>value4&\
    subkey5>value5

# constructs Map<String, Map<String, List<String>>>
test.key.map.of.maps.of.lists=key1->\
      subkey1>\
        value1:value2:value3&\
      subkey2>\
        value2_1:value2_2|\
  key2->\
    subkey3>value2|\
  key3->\
    subkey4>\
        value4_1:value4_2&\
    subkey5>value5
```

###### 2 Define config interface
```
public interface Config {

  @PropertyKey("test.key1")
  String someProperty1();

  @PropertyKey("test.key2")
  Optional<String> someProperty2ViaOptional();

  @PropertyKey("test.key4"")
  int intProperty();

  @PropertyKey(value = "test.key4", optionalClass = Integer.class)
  Optional<Integer> intProperty2ViaOptional();

  @PropertyKey("test.key.list")
  List<String> listDefaultSeparator();

  @PropertyKey(value = "test.key.list.custom", itemsSeparator = ",")
  List<String> listCustomSeparator();

  @PropertyKey("test.key.map")
  Map<String, String> configMap();

  @PropertyKey(value = "test.key.custom.map", keyValueSeparator = "&")
  Map<String, String> customMap();


  @PropertyKey("test.key.map.of.lists")
  Map<String, List<String>> defaultMapOfLists();

  @PropertyKey("test.key.map.of.maps")
  Map<String, Map<String, String>> defaultMapOfMaps();

  @PropertyKey("test.key.map.of.maps.of.lists")
  Map<String, Map<String, List<String>>> defaultMapOfMapsOfLists();
}
```

###### 3 Get a config proxy:

3.1 In tests:
Add test dependency
```xml
    <!-- TEST -->
    <dependency>
      <groupId>{{ group_id }}</groupId>
      <artifactId>{{ artifact_id }}-config</artifactId>
      <version>${project.version}</version>
      <classifier>tests</classifier>
      <type>test-jar</type>
      <scope>test</scope>
    </dependency>
```
Extend your test class from `AppBaseTest`
```
public MyTest extends AppBaseTest {
  
  Configuration config = testConfig();
}
```

3.2 From a file, located on the path, managed by a combination of
a system property/variable, that refers to the folder location and a file name:
```
Config config = Configs.fileConfig(SYSTEM_VARIABLE_NAME, PROP_FILE_NAME)
      .proxy(TestPropertiesConfig.class);
```

###### 4 Use a config proxy:
```
// returns 'test.value1'
String value = config.someProperty1();
```

###### 5 Produce configuration in the managed (JEE) environment:

5.1. Define interface:

    ```
    public interface Configuration {

      String CONFIG_FOLDER_VARIABLE = "config.dir";
      String CONFIG_FILE = "$CONFIG_FILE";
      ...
    ```
5.2. Create a producer:

   The configuration file is named `your.config.properties` in the following examples.

   5.2.1    A `$CONFIG_FILE` property file is located in the resources of the jar file. 

   `$CONFIG_FILE` file is located in the `config` folder of the application:

      ```
      $ ls -1 config/
      your.config.properties
      pom.xml
      src
      ```

   Extend your `app_config/pom.xml` to include the property file into the resources:

      ```
        <build>
          <resources>
            <resource>
              <directory>src/main/resources</directory>
            </resource>
            <resource>
              <directory>${basedir}</directory>
              <includes>
                <include>{{ your.config.properties }}</include>
              </includes>
            </resource>
          </resources>
      ```

   Add a config producer:

      ```
      public class ConfigurationProducer {

        @Produces
        public Configuration produce(){
          return Configs.fileConfig(
             ConfigurationProducer.class.getResourceAsStream("/"+ CONFIG_FILE)))
            .proxy(Configuration.class);
        }
      }
      ```

   5.2.2    In case an external property file is used.

   In this example file is located under a folder, referred by `CONFIG_FOLDER_VARIABLE` system variable.

   ```
    public class ConfigurationProducer {

      @Produces
      public Configuration produce(){
        return Configs.fileConfig(CONFIG_FOLDER_VARIABLE, CONFIG_FILE)
          .proxy(Configuration.class);
      }
    }
   ```

   Remove the `<resources>` block from `app_config/pom.xml`. See 5.2.1.

5.3. Now you can inject it:
    ```
    @Inject
    Configuration config;
    ```

#### Add Jax RS (rest) client support

  Use it only if you use some external rest api, but do not provide your own rest api and rest services.
  
  If you plan to provide your own rest services, skip this file and generate rest services with rest api. 
  See the next section below.

  **Run:** `javaAddCommonsJaxRsClient.sh`

Now you can:
- for external REST API (provided by Jax Rs interfaces) write a `JaxRsProxyConfig` to be able to use it.

  Note:
  Prefer passwordless authentication, instead of the `JaxRsProxyConfigProducer` example, given below.
  You need to add this support additionally.
  See `javaBmAuth.sh` in `ansible-java-bm-generators` project.

  ```java
  public class JaxRsProxyConfigProducer {

    static final String SOME_REST_URL = "/rest/url";
    
    @Inject
    Configuration configuration;
    
    @Produces
    public JaxRsProxyConfig configurationRestApiConfig() {
      return JaxRsProxyConfig.builder()
        .withBasicAuth(configuration.login(), "some password")
        .withDomain(configuration.domain() + SOME_REST_URL)
        .withClazz4Logging(SomeRestService.class)
        .build();
    }
  ```
- provide the service, which consumes REST API with a helper method for tests:
  ```java
  public class RestServiceConsumer {

    public static RestServiceConsumer viaBasicAuthInstance(
      final Configuration config, final String password) { 
      RestServiceConsumer service = new RestServiceConsumer();
      JaxRsProxyConfig jaxRsProxyConfig = JaxRsProxyConfig.builder()
        .withBasicAuth(configuration.login(), "some password")
        .withDomain(configuration.domain() + SOME_REST_URL)
        .withClazz4Logging(RestServiceConsumer.class)
        .build();
      service.someDeps = SomeDeps.viaBasicAuthInstance(config, password);
      service.jaxRsProxyConfig = jaxRsProxyConfig; 
      applicationService.init(); // if needed
      return applicationService; 
    }
  
    @Inject
    JaxRsProxyConfig jaxRsProxyConfig;

    @Inject
    SomeDeps someDeps;
  ```
- for external REST API write an integration test:
  ```java
  public class RestServiceConsumerIT extends AppBaseTest {

    RestServiceConsumer restServiceConsumer = RestServiceConsumer
      .viaBasicAuthInstance(testConfig(), BASIC_AUTH_PASSWORD);
  ```
- for REST service you provide, but do not use in the application, write an integration test:
  ```java
  public class YourRestServiceIT extends AppBaseTest {
  
    Configuration config = testConfig();
  
    JaxRsProxyConfig proxyConfig = JaxRsProxyConfig.builder()
      .withDomain(config.domain())
      .withClazz4Logging(YourRestService.class)
      .withBasicAuth(
        config.login(),
        AppBaseTest.BASIC_AUTH_PASSWORD)
      .build();
  
    @Test
    public void testMethod() {
      String result = proxyConfig.proxy(MpPublicationConsumerRestApi.class)
        .restApiMethod();
    }
  }
  ```
- By default errors (any response code, which are not 2xx HTTP status code) are logged.
  To extract request and response as a String, you can:

  In case a REST interface returns DTO object:
  ```
  try {
    SomeDto someObject = jaxRsProxyConfig.proxy(SomeRestService.class)
    .get(someId);
  } catch (Exception e) {
    throw new IllegalStateException("Could not download file"
      + JaxRsExceptionsUtils.extractErrorFromResponse(e));
  }
  ```

  In case a REST interface returns `Response`, but not DTO object:
  ```
  Response response = jaxRsProxyConfig.proxy(DownloadRestService.class)
    .downloadById(someId);

  if (Response.Status.Family.SUCCESSFUL != response.getStatusInfo().getFamily() ) {
    throw new IllegalStateException("Could not download file"
      + JaxRsExceptionsUtils.extractErrorFromResponse(response));
  }
  ```

#### Generate REST API and REST Services

  Use it if you want to have REST API with REST Services, which implements API.

  **Requirements**:
  - You generated structure with: `javaGenMultiModuleMavenProject.sh`
  - You added git support with: `gitSupport.sh`
  
  **Generation:** Run from within the project base folder: `restSupport.sh`
  
  In the output you'll find actual information about expected parameters.

  The script triggers `jax_rs_client` Ansible role and installs `commons_jax_rs_client` Maven module.
  Then the script generates new `rest_api` and `rest_web` Maven modules.

  Features:
  - Generated Enunciate documentation available with the deployed application.
    You can use regular Java comments on the methods, to describe what it does for the documentation.
  - Swagger interface - GUI which available at runtime and allow you manually to test the REST services
  - Custom datetime serializer and deserializer, provided as examples. 
    See `LocalDateTimeSerializer`, `LocalDateTimeDeserializer` and `MoneySerializer` for `BigDecimal` 
  - Customisation of Jackson ObjectMapper via `JacksonProvider`
  - Ability to set successful response status (if only single successful status is expected) 
    via Enunciate annotation:
  ```java
      import com.webcohesion.enunciate.metadata.rs.ResponseCode;
      import com.webcohesion.enunciate.metadata.rs.StatusCodes;
      
      import javax.ws.rs.POST;
      import javax.ws.rs.Path;

      @Path(MockRestApi.SERVICE_REST_URL)
      public interface MockRestApi {

        @POST
        @StatusCodes({@ResponseCode(code = 201, condition = "Successfully created")})
        void post(String inputData);
      }
  ```
  `HttpSuccessfulStatusHandler` is a handler for this logic.
  - Validation and error handling utils, see `JaxRsHandlerUtils` and `WebApplicationExceptionMapper`.
  - Server side logging (TODO)
  - Features available for `jax_rs_client`.
   
  Steps to implement your own REST service:
  - write a REST interface in `rest_api` module (REST API).
  - define if needed custom http response status.
  - write DTO REST objects
  - write custom serializers/deserializers, register them in `JacksonProvider` in `rest_api` module.
  - write unit tests to serialize/deserialize DTO into/from the json text. Extend `BaseTest` from `commons_test`
  - write an implementation of the REST service in the `rest_web` module
  - write unit test to check web layer (response statuses, http headers), without business logic
  - write integrations test to check the functionality against the real systems.
  - control dependencies for `WildFly` via `jboss-deployment-structure.xml`
  
  Note, rest services (`MockRestService`), 
  jackson provider (`JacksonProvider`),
  and other custom providers (`HttpSuccessfulStatusHandler`)
  are registered explicitly via `JAXRSConfiguration`:

  ```java
  ...
  import javax.ws.rs.ApplicationPath;
  import javax.ws.rs.core.Application;
  
  @ApplicationPath(JAXRSConfiguration.APPLICATION_PATH)
  public class JAXRSConfiguration extends Application {
  
    //see src/main/webapp/WEB-INF/jboss-web.xml
    public static final String CONTEXT_ROOT = "/some/custom/url";
    public static final String APPLICATION_PATH = "/rest";
  
    @Override
    public Set<Class<?>> getClasses() {
      return Sets.newHashSet(
        MockRestService.class,
        JacksonProvider.class,
        HttpSuccessfulStatusHandler.class,
        WebApplicationExceptionMapper.class
      );
    }
  }
  ```

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