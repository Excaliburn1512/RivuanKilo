import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:rivu_v1/models/weather_model.dart';
final weatherFutureProvider = FutureProvider<WeatherModel>((ref) async {
  final dio = Dio();
  final lat = -7.6033; 
  final lon = 111.9014;
  final apiKey = 'e40e189a58f9c03b8fa20b1081e1d24d';
  try {
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': 'metric',
        'lang': 'id',
      },
    );
    return WeatherModel.fromJson(response.data);
  } catch (e) {
    print("WEATHER API ERROR: $e");
    if (e is DioException) {
      print("RESPONSE DATA: ${e.response?.data}");
    }
    throw Exception('Gagal ambil cuaca');
  }
});
