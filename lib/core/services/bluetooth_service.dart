import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flutterBlueProvider = Provider<FlutterBlueClassic>((ref) {
  return FlutterBlueClassic();
});

final bluetoothServiceProvider = Provider<BluetoothService>((ref) {
  final flutterBlue = ref.watch(flutterBlueProvider);
  return BluetoothService(flutterBlue);
});

final bluetoothScanProvider = StreamProvider<BluetoothDevice>((ref) {
  final flutterBlue = ref.watch(flutterBlueProvider);
  return flutterBlue.scanResults;
});

class BluetoothService {
  final FlutterBlueClassic _flutterBlue;
  BluetoothService(this._flutterBlue);

  BluetoothConnection? _connection;
  StreamSubscription? _dataSubscription;

  Future<void> startScan() async {
    _flutterBlue.startScan();
  }

  Future<void> stopScan() async {
    _flutterBlue.stopScan();
  }

  // --- FUNGSI DARI LIB LAMA (Original) ---
  Future<String> connectToDevice(BluetoothDevice device) async {
    await stopScan();
    try {
      _connection = await _flutterBlue.connect(device.address);
      return device.address;
    } catch (e) {
      _connection = null;
      throw Exception("Gagal terhubung ke device: ${e.toString()}");
    }
  }

  // --- FUNGSI TAMBAHAN (Agar bisa Reconnect di ViewRegister) ---
  Future<void> connectByAddress(String address) async {
    if (_connection != null && _connection!.isConnected) {
      // Jika masih nyambung, cek apakah alamatnya sama?
      // Untuk aman, kita close dulu dan connect ulang agar fresh.
      await _connection?.close();
    }

    try {
      print("🔌 Mencoba menyambung ulang ke $address...");
      _connection = await _flutterBlue.connect(address);
      print("✅ Terhubung kembali!");
    } catch (e) {
      _connection = null;
      throw Exception("Gagal menyambung ulang: $e");
    }
  }

  Future<void> sendWifiCredentials({
    required String deviceName,
    required String ssid,
    required String password,
  }) async {
    if (_connection == null || !_connection!.isConnected) {
      throw Exception("Tidak ada device yang terhubung");
    }
    final completer = Completer<void>();
    await _dataSubscription?.cancel();
    _dataSubscription = _connection!.input?.listen((data) {
      String response = utf8.decode(data).trim();
      print("Data diterima: $response");
      if (response.toLowerCase().contains("ok")) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      } else if (response.toLowerCase().contains("error")) {
        if (!completer.isCompleted) {
          completer.completeError(
            Exception("Perangkat merespons error: $response"),
          );
        }
      }
    });
    _dataSubscription?.onDone(() {
      if (!completer.isCompleted) {
        completer.completeError(
          Exception("Koneksi terputus saat menunggu response"),
        );
      }
    });
    final payload = {
      'ssid': ssid,
      'password': password,
      'device_name': deviceName,
    };
    String jsonPayload = jsonEncode(payload);
    try {
      _connection!.writeString(jsonPayload);
      print("Berhasil mengirim data WiFi ke ESP32: $jsonPayload");
      await completer.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception("Timeout: Tidak ada response 'ok' dari perangkat");
        },
      );
    } catch (e) {
      await _dataSubscription?.cancel();
      _dataSubscription = null;
      rethrow;
    } finally {
      await _dataSubscription?.cancel();
      _dataSubscription = null;
    }
  }

  Future<void> disconnect() async {
    await _dataSubscription?.cancel();
    _dataSubscription = null;
    await _connection?.close();
    _connection = null;
  }
}
