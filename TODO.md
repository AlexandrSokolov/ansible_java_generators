- PAUSE

- fix changePwd2AnsibleJava $artifact_id it is not known

- fix <version>1.0.0</version>, store variables from the main task
   
- cron-job module with rest endpoint
- cron-job client generation
- add long-running classes 

- deployments functionality:
```
cat nexus_deploy.yml
---
nexus_release_repo_id: savdev-release-repository
nexus_release_repo_url: https://nexus.savdev.com/content/repositories/releases
nexus_snapshot_repo_id: savdev-snapshot-repository
nexus_snapshot_repo_url: https://nexus.savdev.com/content/repositories/snapshots

parent pom.xml
  <repositories>
    <repository>
      <id>{{ nexus_release_repo_id }}</id>
      <url>{{ nexus_release_repo_url }}</url>
    </repository>
    <repository>
      <id>{{ nexus_snapshot_repo_id }}</id>
      <url>{{ nexus_snapshot_repo_url }}</url>
    </repository>
  </repositories>

front_end_war/pom.xml

      <!-- overwrite a default configuration -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-deploy-plugin</artifactId>
        <executions>
          <execution>
            <id>deploy-single-war</id>
            <phase>deploy</phase>
            <goals>
              <goal>deploy-file</goal>
            </goals>
            <configuration>
              <file>target/${project.build.finalName}.${project.packaging}</file>
              <groupId>${project.groupId}</groupId>
              <artifactId>${project.artifactId}</artifactId>
              <version>${project.version}</version>
              <!-- repositoryId is configured on the Jenkins server, on which deployment is triggered-->
              <repositoryId>{{ nexus_release_repo_id }}</repositoryId>
              <!-- keep in mind that for release and snapshot versions different urls are used!!!-->
              <url>{{ nexus_release_repo_url }}</url>
            </configuration>
          </execution>
        </executions>
      </plugin>

```
- add dependency on bm nexus
- rest-api tests
- other tests
- dataaccess mudule
- add react support to the war module
- add different examples, script with --help options with different combinations
- add base-tests
- add SecurityDomainName with web.xml security constants

- todo add serializer, decerializers
- jax rs client, add more documentation