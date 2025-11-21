
part of 'user_model.dart';
UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: const UuidValueConverter().fromJson(json['user_id'] as String),
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
    );
Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'user_id': const UuidValueConverter().toJson(instance.userId),
      'email': instance.email,
      'full_name': instance.fullName,
    };
