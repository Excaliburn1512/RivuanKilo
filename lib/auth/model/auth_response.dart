import 'package:json_annotation/json_annotation.dart';
import 'package:rivu_v1/auth/model/system_model.dart';
import 'package:rivu_v1/auth/model/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:rivu_v1/helper/uuid_converter.dart';
part 'auth_response.g.dart';
@JsonSerializable()
class LoginResponse {
  final Token token;
  final UserModel user;
  final List<SystemModel> systems;
  LoginResponse({
    required this.token,
    required this.user,
    required this.systems,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
@JsonSerializable()
class Token {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'token_type')
  final String tokenType;
  Token({required this.accessToken, required this.tokenType});
  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
@JsonSerializable()
class UserRegisterResponse {
  @JsonKey(name: 'user_id')
  @UuidValueConverter() 
  final UuidValue userId;
  final String email;
  @JsonKey(name: 'full_name')
  final String? fullName;
  UserRegisterResponse({
    required this.userId,
    required this.email,
    this.fullName,
  });
  factory UserRegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$UserRegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserRegisterResponseToJson(this);
}
@JsonSerializable()
class DeviceProvisionResponse {
  @JsonKey(name: 'system_id')
  @UuidValueConverter() 
  final UuidValue systemId;
  @JsonKey(name: 'device_api_key')
  final String deviceApiKey;
  DeviceProvisionResponse({required this.systemId, required this.deviceApiKey});
  factory DeviceProvisionResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceProvisionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceProvisionResponseToJson(this);
}
