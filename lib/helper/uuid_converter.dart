import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
class UuidValueConverter implements JsonConverter<UuidValue, String> {
  const UuidValueConverter();
  @override
  UuidValue fromJson(String json) {
    return UuidValue.fromString(json);
  }
  @override
  String toJson(UuidValue object) {
    return object.toString();
  }
}
