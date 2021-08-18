### Features:

- Multi-Module Maven project structure:

  All dependencies are stored in the `deps/pom.xml`

  The dependency from `deps` is used in the parent `pom.xml`

  If you want to add Bill of Materials (BOM) POMs, add them not into the parent `pom.xml`,
  but into the `deps/pom.xml`

- `README.md` in the root folder is generated. 

  It contains frequently used maven commands. And some code examples.

- Code quality support

  The generated project contains `findbug` and `pmd` maven plugins for code quality checks.

  Code quality check takes time. To skip it, build the project with: `mvn clean package`
  Running `mvn clean install` triggers code quality checks

- A base class `BaseTest` for testing is provided. [How to reuse `BaseTest`](../testing/README.md)
  
- The publishing of maven artifacts is disabled with `maven-deploy-plugin` by default. 
  To force a certain artifact to be published, 
  overwrite the configuration of the plugin, defined in the parent `pom.xml` as:

```xml
  <build>
    <plugins>
      <!-- `deps` doesn't depend on parent, so `maven-deploy-plugin` must be configured explicitly -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-deploy-plugin</artifactId>
        <version>${maven-deploy-plugin.version}</version>
        <configuration>
          <skip>true</skip>
        </configuration>
      </plugin>
    </plugins>
  </build>
```
