
part of 'system_model.dart';
SystemModel _$SystemModelFromJson(Map<String, dynamic> json) => SystemModel(
      systemId:
          const UuidValueConverter().fromJson(json['system_id'] as String),
      systemName: json['system_name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
Map<String, dynamic> _$SystemModelToJson(SystemModel instance) =>
    <String, dynamic>{
      'system_id': const UuidValueConverter().toJson(instance.systemId),
      'system_name': instance.systemName,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
    };
