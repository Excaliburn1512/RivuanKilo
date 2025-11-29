import 'package:json_annotation/json_annotation.dart';

part 'plant_image_model.g.dart';

@JsonSerializable()
class PlantImageModel {
  @JsonKey(name: 'image_id')
  final String imageId;

  @JsonKey(name: 'file_path')
  final String filePath;

  @JsonKey(name: 'diagnosis_result')
  final String? diagnosisResult;

  @JsonKey(name: 'diagnosis_confidence')
  final double? diagnosisConfidence;

  @JsonKey(name: 'captured_at')
  final String capturedAt;

  PlantImageModel({
    required this.imageId,
    required this.filePath,
    this.diagnosisResult,
    this.diagnosisConfidence,
    required this.capturedAt,
  });

  factory PlantImageModel.fromJson(Map<String, dynamic> json) =>
      _$PlantImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlantImageModelToJson(this);

  // Helper untuk mendapatkan URL lengkap gambar
  String get fullImageUrl => "https://rivu.web.id/$filePath";
}
