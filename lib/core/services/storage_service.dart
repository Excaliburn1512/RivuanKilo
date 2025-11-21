import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rivu_v1/auth/model/system_model.dart'; 
import 'package:rivu_v1/auth/model/user_model.dart'; 
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});
final storageServiceProvider = Provider<StorageService>((ref) {
  final prefsAsyncValue = ref.watch(sharedPreferencesProvider);
  return StorageService(prefsAsyncValue.value);
});
class StorageService {
  final SharedPreferences? _prefs; 
  StorageService(this._prefs);
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _systemsKey = 'systems_data'; 
  Future<void> saveToken(String token) async {
    await _prefs?.setString(_tokenKey, token);
  }
  String? getToken() {
    return _prefs?.getString(_tokenKey);
  }
  Future<void> saveUser(UserModel user) async {
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
  }
  UserModel? getUser() {
    final userJson = _prefs?.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }
  Future<void> saveSystems(List<SystemModel> systems) async {
    final List<String> systemsJson = systems
        .map((s) => jsonEncode(s.toJson()))
        .toList();
    await _prefs?.setStringList(_systemsKey, systemsJson);
  }
  List<SystemModel>? getSystems() {
    final systemsJson = _prefs?.getStringList(_systemsKey);
    if (systemsJson != null) {
      return systemsJson
          .map((s) => SystemModel.fromJson(jsonDecode(s)))
          .toList();
    }
    return null;
  }
  Future<void> clearAll() async {
    await _prefs?.remove(_tokenKey);
    await _prefs?.remove(_userKey);
    await _prefs?.remove(_systemsKey); 
  }
}
