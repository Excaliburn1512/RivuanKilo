
part of 'auth_request.dart';
UserCreateRequest _$UserCreateRequestFromJson(Map<String, dynamic> json) =>
    UserCreateRequest(
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
Map<String, dynamic> _$UserCreateRequestToJson(UserCreateRequest instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'email': instance.email,
      'password': instance.password,
    };
DeviceProvisionRequest _$DeviceProvisionRequestFromJson(
        Map<String, dynamic> json) =>
    DeviceProvisionRequest(
      deviceUniqueId: json['device_unique_id'] as String,
      systemName: json['system_name'] as String,
    );
Map<String, dynamic> _$DeviceProvisionRequestToJson(
        DeviceProvisionRequest instance) =>
    <String, dynamic>{
      'device_unique_id': instance.deviceUniqueId,
      'system_name': instance.systemName,
    };
