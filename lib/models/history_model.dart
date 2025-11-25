import 'package:json_annotation/json_annotation.dart';
part 'history_model.g.dart';
@JsonSerializable()
class HistoryModel {
  @JsonKey(name: 'device_name')
  final String deviceName;
  final String status;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final String createdAt;
  HistoryModel({
    required this.deviceName,
    required this.status,
    required this.isActive,
    required this.createdAt,
  });
  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);
}
