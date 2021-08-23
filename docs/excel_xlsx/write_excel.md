TODO, write values not as string, but according to cell format
add jax rs interface example
add jax rs service generation

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