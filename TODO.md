- DB module refactoring
  1. schema with spring with inserts and selects
  2. persistence.xml for existing schema with jdbc select only, note that it is for not a huge amount of records 
  3. like previous, but only spring 
   documentation per role with a link from main readme
   docs for the generated module
   copy projects from the old laptop to github
   IT tests
- update project readme with using of appbasetest, basetest, about testResources
- server side raw request logging, update readme, adding ability to log the last request response
- add unit tests for serialisation, deser-n with custom serialiers/deserialiers
- add unit to start server and check headers, response codes.
- rest_service, add real service that implements rest interface, 
  it must use JaxRsHandlerUtils.java
  add unit tests for it
- jax rs client, more example with authentication, README
- jax rs client more clear logging, README
- config usage for test purpose
- jax rs config for test purpose generation
- JaxRsHandlerUtils docs, examples and tests
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
- excel module add tests for writing and reading