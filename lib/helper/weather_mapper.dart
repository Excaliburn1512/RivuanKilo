import 'package:weather_animation/weather_animation.dart';
WeatherScene getWeatherScene(String? condition) {
  final status = condition?.toLowerCase() ?? 'clear';
  if (status.contains('rain') || status.contains('drizzle')) {
    return WeatherScene.rainyOvercast;
  } else if (status.contains('thunder') || status.contains('storm')) {
    return WeatherScene.stormy;
  } else if (status.contains('snow')) {
    return WeatherScene.snowfall;
  } else if (status.contains('cloud')) {
    return WeatherScene.scorchingSun; 
  } else if (status.contains('clear')) {
    return WeatherScene.scorchingSun;
  }
  return WeatherScene.scorchingSun;
}
