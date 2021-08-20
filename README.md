### This project generates Java code for different layers/functionality

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

- Maven Multimodule Project 
  [functionality/structure](docs/multi.module.maven/functionality.md)
  and [how to generate](docs/multi.module.maven/generation.md)
- [Testing](docs/testing/README.md)
- [Git Support](docs/git/README.md)
- [Project configuration](docs/configuration/file.based/README.md)
- [Jax Rs (Rest) Client Support](#add-jax-rs-rest-client-support)
- [Jax Ws (Soap) Client Support](#add-jax-ws-soap-client-support)
- [JEE Async support for long running jobs](#jee-async-support-for-long-running-jobs)
- [Cron Jee Support](#cron-jee-support)
- [Protect Web App with Auth](#add-authentication-support)
- [Add deployment support](#add-deployment-support)
- [Excel Support](#excel-module-support)
- [Jpa Datasource Support](#jpa-datasource)

TODO (priority not clear):

- [Add Cryptography support](#todo-add-cryptography-support)

###### 3 Get a config proxy:

3.1 In tests:
Add test dependency




3.2 From a file, located on the path, managed by a combination of
a system property/variable, that refers to the folder location and a file name:
```
Config config = Configs.fileConfig(SYSTEM_VARIABLE_NAME, PROP_FILE_NAME)
      .proxy(TestPropertiesConfig.class);
```



###### 5 Produce configuration in the managed (JEE) environment:

TODO

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
  - You generated structure with: `javaMvnMultiModuleProject.sh`
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

#### Add rest service to allow you to download the configuration property file

  Run: `javaAddFileConfigurationRest.sh`

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
  
  Run: `javaMvnDeploymentSupport.sh`
  In the output you'll find actual information about expected parameters.
  
#### Excel Module support  

  Run: `javaExcelSupport.sh`

#### Jpa Datasource 

  Run: `dbSchemaWithSpringDs.sh`
  In the output you'll find actual information about expected parameters.

## TODO (priority not clear):

#### TODO Add Cryptography support
  
  Run: `javaCryptographySupport.sh`