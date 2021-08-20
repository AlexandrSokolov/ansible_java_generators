In the project the configuration file is located in the `${project_folder}/config` folder.

In the running environment this file could be located differently. 

The following issues are described:
- [internally in web/jar modules as part of their resources](#1-config-file-as-part-of-resources-of-the-warjar)
- [externally in the folder, controlled by system property](#2-external-config-located-in-the-folder-controlled-by-system-property)
- [Configuration it tests](#3-using-config-in-test)
- [Overwriting methods of configuration in tests](#4-overwrite-certain-methods-of-configuration)
- [Configuration files for different environments](#5-different-configuration-files-could-be-used-for-different-environments-test-prod-local)

### 1 Config file as part of resources of the war/jar

Suppose it is named `my.properties`

1.1 The file during building process becomes a part of the resources of this war/jar file via:
```xml
    <resources>
      <resource>
        <directory>src/main/resources</directory>
      </resource>
      <resource>
        <directory>${basedir}/../config</directory>
        <includes>
          <include>my.properties</include>
        </includes>
      </resource>
    </resources>
```
1.2 In the managed environment you could produce it as:
```java
import some.project.config.commons.Configs;
import javax.enterprise.inject.Produces;
import static some.project.config.Configuration.CONFIG_FILE;

public class ConfigurationProducer {

  @Produces
  public Configuration produce(){
    return Configs.fileConfig(
       ConfigurationProducer.class.getResourceAsStream("/"+ CONFIG_FILE))
      .proxy(Configuration.class);
  }
}
```

### 2. External config located in the folder, controlled by system property

Run: `javaFileConfigurationMakeExternal.sh`

The location of folder is controlled by `Configuration.CONFIG_FOLDER_VARIABLE`

**Note: it is a system variable, that points to folder, but not a folder itself!!!**

In the managed environment you could produce it as:
```java
import some.project.config.commons.Configs;
import javax.enterprise.inject.Produces;
import static some.project.config.Configuration.CONFIG_FILE;
import static some.project.config.Configuration.CONFIG_FOLDER_VARIABLE;

public class ConfigurationProducer {

  //From external location
  @Produces
  public Configuration produce(){
    return Configs.fileConfig(CONFIG_FOLDER_VARIABLE, CONFIG_FILE)
      .proxy(Configuration.class);
  }
}
```

To avoid misunderstanding you could delete manually:
```xml
    <resources>
      <resource>
        <directory>src/main/resources</directory>
      </resource>
      <resource>
        <directory>${basedir}/../config</directory>
        <includes>
          <include>my.properties</include>
        </includes>
      </resource>
    </resources>
```

### 3 Using config in test

The file during building process becomes a part of the test resources via:

```xml
    <testResources>
      <testResource>
        <directory>${project.basedir}/src/test/resources</directory>
      </testResource>
      <testResource>
        <directory>${project.basedir}/../config</directory>
        <includes>
          <include>my.properties</include>
        </includes>
      </testResource>
    </testResources>
```
`my.properties` is a name of config file.

In tests, you could access configuration as: 
```java
  public Configuration testConfig() {
    return Configs
      .fileConfig(testInputStream(Configuration.CONFIG_FILE))
      .proxy(Configuration.class);
  }
```

To simplify usage of Configuration it tests, `AppBaseTest` was added.

Add in the `pom.xml` of the module, that have tests with accessing to `Configuration`:

```xml
  <dependencies>
    <!-- TEST -->
    <dependency>
      <groupId>{{ group_id }}</groupId>
      <artifactId>{{ artifact_id }}-config</artifactId>
      <version>${project.version}</version>
      <classifier>tests</classifier>
      <type>test-jar</type>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>{{ group_id }}</groupId>
      <artifactId>{{ artifact_id }}-commons-test</artifactId>
      <version>${project.version}</version>
      <classifier>tests</classifier>
      <type>test-jar</type>
      <scope>test</scope>
    </dependency>
  </dependencies>
```
Extend your test class from `AppBaseTest`
```
public MyTest extends AppBaseTest {
  
  Configuration config = testConfig();
}
```

Note: you need a test dependency on both `{{ artifact_id }}-config` and `{{ artifact_id }}-commons-test`.

Otherwise in your test, that looks like:
```java
import AppBaseTest;

public class ApplicationServiceIT extends AppBaseTest {
}
```
you'll get an error about the base class of `AppBaseTest`:
```text
[ERROR] .../ApplicationServiceIT.java:[6,8] cannot access ...BaseTest
[ERROR]   class file for ....BaseTest not found
```

### 4. Overwrite certain methods of configuration

You might decide to overwrite certain methods of configuration and at the same time to use real methods of the config.
The standard way with `spy` not working. You need to use Mockito `mock-maker-inline` extension:

4.1 Make sure you use mockito version at least: `3.11.2` or higher:
```xml
<properties>
  <mockito.version>3.11.2</mockito.version>
</properties>

<dependency>
  <groupId>org.mockito</groupId>
  <artifactId>mockito-core</artifactId>
  <version>${mockito.version}</version>
  <scope>test</scope>
</dependency>
```

4.2 Create `/your_module/src/test/resources/mockito-extensions/org.mockito.plugins.MockMaker` file it test resources
with the following content: `mock-maker-inline`

4.3 In test you overwrite method:
```java
import org.mockito.AdditionalAnswers;
import org.mockito.Mockito;

import static org.mockito.Mockito.when;

public class ApplicationServiceIT extends AppBaseTest {

  ApplicationService applicationService = new ApplicationService();
  Configuration config = testConfig();
  Configuration mockConfig = Mockito.mock(Configuration.class, AdditionalAnswers.delegatesTo(config));

  @BeforeEach
  public void init() {
    when(mockConfig.methodYouWant2Overwrite()).thenReturn("some value");
    applicationService.configuration = mockConfig;
  }
}
```

See [Mock Final Classes and Methods with Mockito](https://www.baeldung.com/mockito-final)

### 5. Different configuration files could be used for different environments: test, prod, local

You might put the different files with the same names in different locations:
- `${project_folder}/config/local/my.properties`
- `${project_folder}/config/test/my.properties`
- `${project_folder}/config/prod/my.properties`

In case a file is part of resources and a part of the war/jar file, adopt the directory path
from: `<directory>${basedir}/../config</directory>` to:
```xml
    <resources>
      <resource>
        <directory>src/main/resources</directory>
      </resource>
      <resource>
        <directory>${basedir}/../config/local</directory>
        <includes>
          <include>my.properties</include>
        </includes>
      </resource>
    </resources>
```

If file is used externally, you manually deploy it, 
its location is controlled by system variable, 
you have no `resource` for this purpose (it makes no sense),
you have nothing to do.

For tests, for both options to store the config inside the package, or externally, you have to change `testResources`:
```xml
    <testResources>
      <testResource>
        <directory>${project.basedir}/src/test/resources</directory>
      </testResource>
      <testResource>
        <directory>${project.basedir}/../config/local</directory>
        <includes>
          <include>my.properties</include>
        </includes>
      </testResource>
    </testResources>
```