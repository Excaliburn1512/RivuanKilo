import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:rivu_v1/helper/uuid_converter.dart';
part 'user_model.g.dart';
@JsonSerializable()
class UserModel {
  @JsonKey(name: 'user_id')
  @UuidValueConverter() 
  final UuidValue userId;
  final String email;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'profile_picture') 
  final String? profilePicture;
  UserModel({required this.userId, required this.email, this.fullName,this.profilePicture});
  String get displayName => fullName ?? 'User';
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
