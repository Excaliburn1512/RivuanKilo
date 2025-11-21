import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:rivu_v1/helper/uuid_converter.dart';
part 'system_model.g.dart';
@JsonSerializable()
class SystemModel {
  @JsonKey(name: 'system_id')
  @UuidValueConverter() 
  final UuidValue systemId;
  @JsonKey(name: 'system_name')
  final String systemName;
  final String? description;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  SystemModel({
    required this.systemId,
    required this.systemName,
    this.description,
    required this.createdAt,
  });
  factory SystemModel.fromJson(Map<String, dynamic> json) =>
      _$SystemModelFromJson(json);
  Map<String, dynamic> toJson() => _$SystemModelToJson(this);
}
