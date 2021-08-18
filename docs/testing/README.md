

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