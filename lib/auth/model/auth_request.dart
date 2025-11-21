import 'package:json_annotation/json_annotation.dart';
part 'auth_request.g.dart';
@JsonSerializable()
class UserCreateRequest {
  @JsonKey(name: 'full_name')
  final String fullName;
  final String email;
  final String password;
  UserCreateRequest({
    required this.fullName,
    required this.email,
    required this.password,
  });
  Map<String, dynamic> toJson() => _$UserCreateRequestToJson(this);
}
@JsonSerializable()
class DeviceProvisionRequest {
  @JsonKey(name: 'device_unique_id')
  final String deviceUniqueId; 
  @JsonKey(name: 'system_name')
  final String systemName;
  DeviceProvisionRequest({
    required this.deviceUniqueId,
    required this.systemName,
  });
  Map<String, dynamic> toJson() => _$DeviceProvisionRequestToJson(this);
}
