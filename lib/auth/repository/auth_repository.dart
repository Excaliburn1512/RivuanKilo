import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/core/api/auth_api_client.dart';
import 'package:rivu_v1/core/services/storage_service.dart';
import 'package:rivu_v1/auth/model/auth_request.dart';
import 'package:rivu_v1/auth/model/auth_response.dart';
import 'package:rivu_v1/auth/model/auth_state.dart';
import 'package:rivu_v1/auth/model/user_model.dart';
import 'package:rivu_v1/auth/model/system_model.dart';
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final authApiClient = ref.watch(authApiClientProvider);
  return AuthRepository(authApiClient, storageService);
});
class AuthRepository {
  final AuthApiClient _authApiClient;
  final StorageService _storageService;
  AuthRepository(this._authApiClient, this._storageService);
  Future<AuthState> checkSession() async {
    final token = _storageService.getToken();
    final user = _storageService.getUser();
    final systems = _storageService.getSystems();
    if (token != null && user != null && systems != null) {
      return AuthState(user: user, systems: systems);
    }
    return AuthState.loggedOut();
  }
  Future<AuthState> login(String email, String password) async {
    try {
      final request = {
        'username': email, 
        'password': password,
      };
      final response = await _authApiClient.login(request);
      await _storageService.saveToken(response.token.accessToken);
      await _storageService.saveUser(response.user);
      await _storageService.saveSystems(response.systems);
      print("Login berhasil, user: ${response.user.email}");
      return AuthState(user: response.user, systems: response.systems);
    } catch (e) {
      print("Login Gagal: $e");
      rethrow;
    }
  }
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final request = UserCreateRequest(
        fullName: name,
        email: email,
        password: password,
      );
      await _authApiClient.register(request);
      print("Register user $email berhasil.");
    } catch (e) {
      print("Register Gagal: $e");
      rethrow;
    }
  }
  Future<List<SystemModel>> refreshSystems() async {
    try {
      final systems = await _authApiClient.getMySystems();
      await _storageService.saveSystems(systems);
      print("System list refreshed.");
      return systems;
    } catch (e) {
      print("Gagal refresh systems: $e");
      rethrow;
    }
  }
  Future<List<SystemModel>> provisionDevice({
    required String deviceIdentifier,
    required String deviceName,
  }) async {
    try {
      final request = DeviceProvisionRequest(
        deviceUniqueId: deviceIdentifier,
        systemName: deviceName,
      );
      final response = await _authApiClient.provisionDevice(request);
      print("Provisioning device ${response.systemId} berhasil.");
      return await refreshSystems(); 
    } catch (e) {
      print("Provisioning Gagal: $e");
      rethrow;
    }
  }
  Future<AuthState> registerAndProvision({
    required String name,
    required String email,
    required String password,
    required String deviceIdentifier,
    required String deviceName,
  }) async {
    try {
      await _authApiClient.register(
        UserCreateRequest(fullName: name, email: email, password: password),
      );
      final loginRequest = {'username': email, 'password': password};
      final loginResponse = await _authApiClient.login(loginRequest);
      await _storageService.saveToken(loginResponse.token.accessToken);
      await _storageService.saveUser(loginResponse.user);
      final provisionRequest = DeviceProvisionRequest(
        deviceUniqueId: deviceIdentifier,
        systemName: deviceName,
      );
      await _authApiClient.provisionDevice(provisionRequest);
      final finalLoginResponse = await _authApiClient.login(loginRequest);
      await _storageService.saveToken(finalLoginResponse.token.accessToken);
      await _storageService.saveUser(finalLoginResponse.user);
      await _storageService.saveSystems(finalLoginResponse.systems);
      print("Register, Login, dan Provision berhasil.");
      return AuthState(
        user: finalLoginResponse.user,
        systems: finalLoginResponse.systems,
      );
    } catch (e) {
      print("Gagal registerAndProvision: $e");
      await _storageService.clearAll(); 
      rethrow;
    }
  }
  Future<void> unlinkDevice(String systemId) async {
    try {
      await _authApiClient.unlinkDevice(systemId);
      final systems = _storageService.getSystems() ?? [];
      systems.removeWhere((s) => s.systemId.toString() == systemId);
      await _storageService.saveSystems(systems);
      print("Device $systemId unlinked successfully.");
    } catch (e) {
      print("Gagal unlink device: $e");
      rethrow;
    }
  }
  Future<void> logout() async {
    await _storageService.clearAll();
    print("Logout berhasil, data lokal dibersihkan.");
  }
}
