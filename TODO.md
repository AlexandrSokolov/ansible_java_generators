- jax rs client, more example with authentication, README
- jax rs client more clear logging, README
- avoid using ansible file with variables, try to read them from pom.xml
- ability to run with a changed version
- config usage for test purpose
- jax rs config for test purpose generation

- fix changePwd2AnsibleJava $artifact_id it is not known
- fix issue, when project folder name is renamed and 
    does equal to `artifact_id`
    
- fix <version>1.0.0</version>, store variables from the main task
   
- JaxRsHandlerUtils docs, examples and tests
- add dependency on bm nexus
- rest-api tests
- other tests
- dataaccess mudule
```
#[[
#### Requirements: 
]]#
- datasource configuration with `${jndiDatasourceName}` jndi name
```
- add react support to the war module
```
To skip React code build, run: `mvn clean package -P skip-react-build`
**To skip React code build it is required at least once build it with one of the previous commands**
`mvn clean package -P skip-react-build -DskipTests=true`

...
#### Dev issues: 

##### React application development:

The app must be built at least once with `mvn clean package`. 
The `front_end_war/react` folder will be created.
Then you can build and start react application:
\`\`\`
$ cd front_end_war/react
$ npm start
\`\`\`

For React developer, json server is configured to run on `http://localhost:3500`, see `react/web_server`

```


- add different examples, script with --help options with different combinations
- add base-tests
- add SecurityDomainName with web.xml security constants
- cron job exprression, add support of `?` with logging how it is changed
- cron job expression validation on startup
- todo add serializer, decerializers
- jax rs client, add more documentation
