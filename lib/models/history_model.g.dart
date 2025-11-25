
part of 'history_model.dart';
HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) => HistoryModel(
      deviceName: json['device_name'] as String,
      status: json['status'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
    );
Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      'device_name': instance.deviceName,
      'status': instance.status,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
    };
