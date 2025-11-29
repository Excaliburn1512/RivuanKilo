import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'package:rivu_v1/models/weather_model.dart';

final weatherFutureProvider = FutureProvider<WeatherModel>((ref) async {
  final dio = Dio();
  final apiKey = 'e40e189a58f9c03b8fa20b1081e1d24d';

  try {
    // 1. Dapatkan Lokasi Saat Ini Dinamis
    final position = await _determinePosition();

    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'lat': position.latitude, // Gunakan latitude dinamis
        'lon': position.longitude, // Gunakan longitude dinamis
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
    // Jika gagal ambil lokasi/api, lempar error agar UI bisa handle
    throw Exception('Gagal ambil cuaca: $e');
  }
});

/// Fungsi Helper untuk mendapatkan lokasi & cek izin
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Cek apakah layanan lokasi aktif
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Layanan lokasi tidak aktif.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Izin lokasi ditolak');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Izin lokasi ditolak permanen, kami tidak bisa request izin.',
    );
  }

  // Ambil posisi saat ini
  return await Geolocator.getCurrentPosition();
}
