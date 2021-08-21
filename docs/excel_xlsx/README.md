Run: `javaExcelSupport.sh`

Read from excel:
```
ExcelReaderService service ...

List<ExcelLine> lines = excelReaderService.readExcel(
  configuration.sheetName(),
  inputStream,
  this::handleRow);

//handle row if "C" column is not empty or contains "."
//  and skip all lines which belongs to header
private boolean handleRow(ExcelLine line){
return line.getExcelLineNumber() >= configuration.headerLineNumber() + 1
  && !StringUtils.isEmpty(line.getExcelColName2Value().get("C"))
  && !".".equals(line.getExcelColName2Value().get("C"));
}
```

Writing into Excel template:
```
  public static final String TEMPLATE = "template.xlsx";

  @Inject
  ExcelWriterService excelWriterService;

    List<Map<String, String>> rows = Lists.newArrayList(
      ImmutableMap.of(
        "A", "value1",
        "B", "111"),
      ImmutableMap.of(
        "A", "value2",
        "B", "222"));

    excelWriterService.writeExcelTemplate(
      getClass().getClassLoader().getResourceAsStream(TEMPLATE),
      configuration.sheetName(),
      configuration.headerLineNumber() + 1,
      rows,
      outputStream);
```

Use in Jax Rs:
```
  @Inject
  ExcelWriterService excelWriterService;

  @GET
  @Produces(MediaType.APPLICATION_OCTET_STREAM)
  public Response exportExcel() {
    List<Map<String, String>> rows = Lists.newArrayList(
      ImmutableMap.of(
        "A", "value1",
        "B", "111"),
      ImmutableMap.of(
        "A", "value2",
        "B", "222"));
    
    return Response
      .ok((StreamingOutput) /*OutputStream*/ output -> {
          exportExcelService.writeExcel(
            "some name",
            5,
            rows,
            outputStream);
          output.flush();
      })
      .header(
        HttpHeaders.CONTENT_DISPOSITION,
        String.format("attachment; filename=\"%s\"", "test.xlsx"))
      .build();
  }
```