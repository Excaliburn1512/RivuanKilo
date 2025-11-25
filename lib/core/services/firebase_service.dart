
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/models/device_data.dart'; 
final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  const databaseURL =
      "https://rivu-4cf24-default-rtdb.asia-southeast1.firebasedatabase.app/";
  return FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: databaseURL,
  );
});
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  final db = ref.watch(firebaseDatabaseProvider);
  return FirebaseService(db, ref);
});
final selectedSystemIdProvider = StateProvider<String?>((ref) => null);
final currentSystemIdProvider = Provider<String?>((ref) {
  final selectedId = ref.watch(selectedSystemIdProvider);
  if (selectedId != null) {
    return selectedId; 
  }
  final authState = ref.watch(authControllerProvider);
  return authState.value?.systems?.firstOrNull?.systemId.toString();
});
final deviceStreamProvider = StreamProvider.autoDispose<DeviceData>((ref) {
  final db = ref.watch(firebaseDatabaseProvider);
  final systemId = ref.watch(currentSystemIdProvider); 
  if (systemId == null) {
    print("deviceStreamProvider: systemId is null, returning empty stream.");
    return Stream.value(DeviceData.empty());
  }
  print("deviceStreamProvider: Listening to systemId: $systemId");
  final controller = StreamController<DeviceData>();
  final deviceRef = db.ref('devices').child(systemId);
  final subscription = deviceRef.onValue.listen(
    (DatabaseEvent event) {
      if (event.snapshot.value != null) {
        try {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          final deviceData = DeviceData.fromJson(data);
          controller.add(deviceData);
        } catch (e) {
          print("deviceStreamProvider Error: Gagal parsing data: $e");
          controller.addError(Exception("Gagal parsing data: $e"));
        }
      } else {
        print("deviceStreamProvider: Snapshot is null, returning empty data.");
        controller.add(DeviceData.empty());
      }
    },
    onError: (error) {
      print("deviceStreamProvider Error: $error");
      controller.addError(error);
    },
  );
  ref.onDispose(() {
    print("deviceStreamProvider: Disposing systemId: $systemId");
    subscription.cancel();
    controller.close();
  });
  return controller.stream;
});
class FirebaseService {
  final FirebaseDatabase _db;
  final Ref _ref;
  FirebaseService(this._db, this._ref);
  Future<void> updateAktuator(String aktuatorKey, String value) async {
    final systemId = _ref.read(currentSystemIdProvider);
    if (systemId == null) {
      throw Exception("Tidak ada system ID yang dipilih");
    }
    try {
      final ref = _db.ref('devices/$systemId/aktuator_status/$aktuatorKey');
      await ref.set(value);
    } catch (e) {
      throw Exception("Gagal update aktuator: $e");
    }
  }
}
