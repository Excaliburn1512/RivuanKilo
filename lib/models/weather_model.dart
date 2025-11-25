import 'package:json_annotation/json_annotation.dart';
part 'weather_model.g.dart';
@JsonSerializable()
class WeatherModel {
  final String name;
  final MainInfo main;
  final List<WeatherInfo> weather;
  WeatherModel({required this.name, required this.main, required this.weather});
  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);
}
@JsonSerializable()
class MainInfo {
  final double temp;
  MainInfo({required this.temp});
  factory MainInfo.fromJson(Map<String, dynamic> json) =>
      _$MainInfoFromJson(json);
}
@JsonSerializable()
class WeatherInfo {
  final String main; 
  final String description;
  final String icon;
  WeatherInfo({
    required this.main, 
    required this.description,
    required this.icon,
  });
  factory WeatherInfo.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoFromJson(json);
}
