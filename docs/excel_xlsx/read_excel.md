
You can use `ExcelReaderService` to read from excel. 

To create it you need to decide, if you need to convert excel column values into a set of named attributes.
In this case you can easily get:
1. attribute name to value map or 
2. dto object, with setters/getters. It simplifies rest services development a lot.

**Here is a full list of functionality:**

- [create configuration of `ExcelReaderService` and the service itself](#create-configuration-of-excelreaderservice-and-the-service-itself)
- [create unconfigurable `ExcelReaderService`](#create-unconfigurable-excelreaderservice)
- [`ExcelLine` class/abstraction](#excelline-classabstraction)
- [Handling excel lines via a stream](#handling-excel-lines-via-a-stream)
- [Filtering and validation](#filtering-and-validation)
- [Converting stream of `ExcelLine` into attribute -> value map](#converting-stream-of-excelline-into-attribute---value-map)
- [Converting stream of `ExcelLine` into stream of DTO objects](#converting-stream-of-excelline-into-stream-of-dto-objects)


#### Create configuration of `ExcelReaderService` and the service itself

The configuration it is just a mapping between column name in Excel (letters `A`, `B`, etc.)
and attribute name, which has some business meaning, for instance attribute in a REST DTO object.

```java
public class ExcelReaderServiceTest {
  ExcelReaderService configuredService;

  @BeforeEach
  public void init() {
    Map<String, String> configuration = Maps.newLinkedHashMap();
    //attribute names for C and D are not set
    configuration.putAll(ImmutableMap.of(
      "A", "colA",
      "B", "colB"));
    configuration.putAll(ImmutableMap.of(
      "E", "money",
      "F", "persentage",
      "G", "someDate",
      "H", "time",
      "I", "number"));
    configuredService = ExcelReaderService.instance(configuration);
  }
}
```



#### Create unconfigurable `ExcelReaderService`

```java
public class ExcelReaderServiceTest {
  
  ExcelReaderService nonConfiguredService = ExcelReaderService.instance();
```

#### `ExcelLine` class/abstraction

All information about excel line is stored in `ExcelLine` class/abstraction`.
It contains:
1. line number according to its position in the Excel file.
2. An Excel column name -> attribute name -> value mapping.

The value could be any of the following Java Data Type:
- `BigDecimal`
- `String`
- `LocalDateTime` (also dates are defined as `LocalDateTime`)
- `LocalTime`
- `Boolean`

#### Handling excel lines via a stream

If all data is on the 1st tab, you might use unnamed version of the method,
Or use a name of an Excel sheet to extract data from it:

```java
public class ExcelReaderServiceTest {
  
  ExcelReaderService service = ...

  @Test
  public void testReadExcelWithSheetName() throws IOException {
    try (InputStream stream = testInputStream(EXCEL_FILE)) {
      Stream<ExcelLine> excelStream = service.linesStream(stream);
      Stream<ExcelLine> excelStreamWithNamedSheet = service.linesStream(EXCEL_SHEET_NAME, stream);
      Assertions.assertNotNull(excelStream);
      Assertions.assertEquals(4, excelStream.count());
  }

```

#### Filtering and validation

In the following example, we skip handling header (the first 3 lines),
Then we split lines into valid and invalid, to handle them differently.

Invalid lines are those, which have empty value in `D` column:

```java
  @Test
  public void testFilteringAndValidation() throws IOException {
    try (InputStream stream = testInputStream(EXCEL_FILE)) {

      Map<Boolean, List<ExcelLine>> validAndInvalid = configuredService.linesStream(stream)
        .filter(excelLine -> excelLine.getExcelLineNumber() > 3)
        .collect(Collectors.partitioningBy(excelLine -> excelLine.valueByColumn("D")
          .map(value -> (String) value)
          .map(StringUtils::isNoneEmpty)
          .isPresent()));
      Assertions.assertEquals(2, validAndInvalid.size());
      Assertions.assertEquals(1, validAndInvalid.get(true).size());
      Assertions.assertEquals(1, validAndInvalid.get(false).size());
    }
  }
```

#### Converting stream of `ExcelLine` into attribute -> value map

```java
  @Test
  public void testTransformer() throws IOException {
    try (InputStream stream = testInputStream(EXCEL_FILE)) {
      List<Map<String, Object>> result = configuredService.linesStream(stream)
        .filter(excelLine -> excelLine.getExcelLineNumber() > 3)
        .map(configuredService::transformer)
        .collect(Collectors.toList());
      Assertions.assertEquals(2, result.size());
    }
  }
```

#### Converting stream of `ExcelLine` into stream of DTO objects

In the following example we:
1. skip the header (the first 3 lines)
2. transform `ExcelLine` into map
3. transform map into `TestDto`

```java
  @Test
  public void testTransformer2Dto() throws IOException {
    try (InputStream stream = testInputStream(EXCEL_FILE)) {
      List<TestDto> result = configuredService.linesStream(EXCEL_SHEET_NAME, stream)
        .filter(excelLine -> excelLine.getExcelLineNumber() > 3)
        .map(configuredService::transformer)
        .map(attribute2Value -> configuredService.transformer(
            TestDto::new,
            attribute2Value))
        .collect(Collectors.toList());
      Assertions.assertEquals(2, result.size());
    }
  }
```

`TestDto` example:
```java
public class TestDto {
  String colA;
  BigDecimal money;
  LocalDateTime someDate;
  LocalTime time;
  BigDecimal number;
  // getters and setters
}
```