
part of 'weather_model.dart';
WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
      name: json['name'] as String,
      main: MainInfo.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => WeatherInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'main': instance.main,
      'weather': instance.weather,
    };
MainInfo _$MainInfoFromJson(Map<String, dynamic> json) => MainInfo(
      temp: (json['temp'] as num).toDouble(),
    );
Map<String, dynamic> _$MainInfoToJson(MainInfo instance) => <String, dynamic>{
      'temp': instance.temp,
    };
WeatherInfo _$WeatherInfoFromJson(Map<String, dynamic> json) => WeatherInfo(
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );
Map<String, dynamic> _$WeatherInfoToJson(WeatherInfo instance) =>
    <String, dynamic>{
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };
