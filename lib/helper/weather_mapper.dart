import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';

// Fungsi penentu animasi (scene) berdasarkan kondisi string
WeatherScene getWeatherScene(String? condition) {
  final status = condition?.toLowerCase() ?? 'clear';
  if (status.contains('rain') || status.contains('drizzle')) {
    return WeatherScene.rainyOvercast;
  } else if (status.contains('thunder') || status.contains('storm')) {
    return WeatherScene.stormy;
  } else if (status.contains('snow')) {
    return WeatherScene.snowfall;
  } else if (status.contains('cloud')) {
    // Catatan: Di logic kamu 'cloud' return scorchingSun,
    // jika ingin awan mendung bisa ganti ke WeatherScene.weatherEvery atau lainnya.
    return WeatherScene.weatherEvery;
  } else if (status.contains('clear')) {
    return WeatherScene.scorchingSun;
  }
  return WeatherScene.scorchingSun;
}

// Fungsi BARU: Penentu warna berdasarkan scene (Sesuai request kamu)
List<Color> getWeatherColors(WeatherScene scene) {
  return switch (scene) {
    WeatherScene.scorchingSun => [
      const Color(0xffd50000),
      const Color(0xffffd54f),
    ],
    WeatherScene.sunset => [const Color(0xff283593), const Color(0xffff8a65)],
    WeatherScene.frosty => [
      const Color(0xff303f9f),
      const Color(0xff1e88e5),
      const Color(0xffbdbdbd),
    ],
    WeatherScene.snowfall => [
      const Color(0xff3949ab),
      const Color(0xff90caf9),
      const Color(0xffd6d6d6),
    ],
    WeatherScene.showerSleet => [
      const Color(0xff37474f),
      const Color(0xff546e7a),
      const Color(0xffbdbdbd),
      const Color(0xff90a4ae),
      const Color(0xff78909c),
    ],
    WeatherScene.stormy => [const Color(0xff263238), const Color(0xff78909c)],
    WeatherScene.rainyOvercast => [
      const Color(0xff424242),
      const Color(0xffcfd8dc),
    ],
    WeatherScene.weatherEvery => [
      const Color(0xff1976d2),
      const Color(0xffe1f5fe),
    ],
    // Default fallback jika scene tidak dikenali
    _ => [const Color(0xff1976d2), const Color(0xffe1f5fe)],
  };
}
