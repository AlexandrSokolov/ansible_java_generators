**`Configuration` interface usage:**

###### 1 Create a properties file:
```
test.key1=test.value1
test.key2=test.value2
test.key4=23
test.key.list=item1|item2|item3
test.key.list.custom=item1,item2,item3
test.key.map=key1->value1|key2->value2|key3->value3
test.key.custom.map=key1&value1|key2&value2


# constructs Map<String, List<String>>
test.key.map.of.lists=key1->\
    value1&value2&value3|\
  key2->\
    value2|key3->value4&value5

# constructs Map<String, Map<String, String>>
test.key.map.of.maps=key1->\
      subkey1>value1&\
      subkey2>value2|\
  key2->\
    subkey3>value2|\
  key3->\
    subkey4>value4&\
    subkey5>value5

# constructs Map<String, Map<String, List<String>>>
test.key.map.of.maps.of.lists=key1->\
      subkey1>\
        value1:value2:value3&\
      subkey2>\
        value2_1:value2_2|\
  key2->\
    subkey3>value2|\
  key3->\
    subkey4>\
        value4_1:value4_2&\
    subkey5>value5
```

###### 2 Define config interface
```
public interface Config {

  @PropertyKey("test.key1")
  String someProperty1();

  @PropertyKey("test.key2")
  Optional<String> someProperty2ViaOptional();

  @PropertyKey("test.key4"")
  int intProperty();

  @PropertyKey(value = "test.key4", optionalClass = Integer.class)
  Optional<Integer> intProperty2ViaOptional();

  @PropertyKey("test.key.list")
  List<String> listDefaultSeparator();

  @PropertyKey(value = "test.key.list.custom", itemsSeparator = ",")
  List<String> listCustomSeparator();

  @PropertyKey("test.key.map")
  Map<String, String> configMap();

  @PropertyKey(value = "test.key.custom.map", keyValueSeparator = "&")
  Map<String, String> customMap();

  @PropertyKey("test.key.map.of.lists")
  Map<String, List<String>> defaultMapOfLists();

  @PropertyKey("test.key.map.of.maps")
  Map<String, Map<String, String>> defaultMapOfMaps();

  @PropertyKey("test.key.map.of.maps.of.lists")
  Map<String, Map<String, List<String>>> defaultMapOfMapsOfLists();
}
```

###### 3 Use a config proxy:
```
@Inject 
Configuration config;

String value = config.someProperty1(); // returns 'test.value1'
```