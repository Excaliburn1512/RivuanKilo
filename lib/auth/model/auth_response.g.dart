// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: Token.fromJson(json['token'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      systems: (json['systems'] as List<dynamic>)
          .map((e) => SystemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
      'systems': instance.systems,
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
    };

UserRegisterResponse _$UserRegisterResponseFromJson(
        Map<String, dynamic> json) =>
    UserRegisterResponse(
      userId: const UuidValueConverter().fromJson(json['user_id'] as String),
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
    );

Map<String, dynamic> _$UserRegisterResponseToJson(
        UserRegisterResponse instance) =>
    <String, dynamic>{
      'user_id': const UuidValueConverter().toJson(instance.userId),
      'email': instance.email,
      'full_name': instance.fullName,
    };

DeviceProvisionResponse _$DeviceProvisionResponseFromJson(
        Map<String, dynamic> json) =>
    DeviceProvisionResponse(
      systemId:
          const UuidValueConverter().fromJson(json['system_id'] as String),
      deviceApiKey: json['device_api_key'] as String,
    );

Map<String, dynamic> _$DeviceProvisionResponseToJson(
        DeviceProvisionResponse instance) =>
    <String, dynamic>{
      'system_id': const UuidValueConverter().toJson(instance.systemId),
      'device_api_key': instance.deviceApiKey,
    };
