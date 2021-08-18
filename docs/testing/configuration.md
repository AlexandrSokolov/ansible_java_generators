### How to expose your own test class for reusing

1. Configure in the root `pom.xml` the `maven-jar-plugin` plugin as:
```xml
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-jar-plugin</artifactId>
          <version>${maven-jar-plugin.version}</version>
          <executions>
            <execution>
              <goals>
                <goal>test-jar</goal>
              </goals>
            </execution>
          </executions>
        </plugin>
```
2. In the module which contains the test classes for reusing, add in its `pom.xml`:
```xml
  <build>
      <plugins>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-jar-plugin</artifactId>
        </plugin>
      </plugins>
  </build>
```
3. In the module, which uses the test classes, add in its `pom.xml`
```xml
    <!-- TEST -->
    <dependency>
      <groupId>${project.groupId}</groupId>
      <artifactId>your-project-artifact-id-commons-test</artifactId>
      <version>${project.version}</version>
      <classifier>tests</classifier>
      <type>test-jar</type>
      <scope>test</scope>
    </dependency>
```
4. If you plan to use test classes from module A, 
  that uses test classes from module B, 
  then you must define test dependency for both A and B modules:
```xml
<dependencies>
  <dependency>
    <groupId>${project.groupId}</groupId>
    <artifactId>${artifact_id_used_for_generation}-config</artifactId>
    <version>${project.version}</version>
    <classifier>tests</classifier>
    <type>test-jar</type>
    <scope>test</scope>
  </dependency>
  <dependency>
    <groupId>${project.groupId}</groupId>
    <artifactId>${artifact_id_used_for_generation}-commons-test</artifactId>
    <version>${project.version}</version>
    <classifier>tests</classifier>
    <type>test-jar</type>
    <scope>test</scope>
  </dependency>
</dependencies>
```

Read [Guide to using attached tests](http://maven.apache.org/guides/mini/guide-attached-tests.html) for more details.