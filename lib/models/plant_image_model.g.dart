// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantImageModel _$PlantImageModelFromJson(Map<String, dynamic> json) =>
    PlantImageModel(
      imageId: json['image_id'] as String,
      filePath: json['file_path'] as String,
      diagnosisResult: json['diagnosis_result'] as String?,
      diagnosisConfidence: (json['diagnosis_confidence'] as num?)?.toDouble(),
      capturedAt: json['captured_at'] as String,
    );

Map<String, dynamic> _$PlantImageModelToJson(PlantImageModel instance) =>
    <String, dynamic>{
      'image_id': instance.imageId,
      'file_path': instance.filePath,
      'diagnosis_result': instance.diagnosisResult,
      'diagnosis_confidence': instance.diagnosisConfidence,
      'captured_at': instance.capturedAt,
    };
