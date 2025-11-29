import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/auth/model/auth_response.dart';
import 'package:rivu_v1/core/api/auth_api_client.dart';
import 'package:rivu_v1/core/services/storage_service.dart';
import 'package:rivu_v1/auth/model/auth_request.dart';
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
  // Tambahkan fungsi baru ini di AuthRepository
  Future<AuthState> registerAndProvision({
    required String name,
    required String email,
    required String password,
    required String deviceIdentifier,
    required String deviceName,
  }) async {
    try {
      // 1. Register user
      await _authApiClient.register(
        UserCreateRequest(fullName: name, email: email, password: password),
      );

      // 2. Login untuk dapat token
      final loginRequest = {'username': email, 'password': password};
      final loginResponse = await _authApiClient.login(loginRequest);

      // 3. Simpan token PENTING!
      await _storageService.saveToken(loginResponse.token.accessToken);
      await _storageService.saveUser(loginResponse.user);

      // 4. Provision device (sekarang DENGAN token)
      final provisionRequest = DeviceProvisionRequest(
        deviceUniqueId: deviceIdentifier,
        systemName: deviceName,
      );
      await _authApiClient.provisionDevice(provisionRequest);

      // 5. Login LAGI untuk refresh data (mendapatkan list device baru)
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
      await _storageService.clearAll(); // Bersihkan jika gagal
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
  Future<void> requestOtp(String email) async {
    try {
      await _authApiClient.forgotPassword({'email': email});
    } catch (e) {
      throw Exception("Gagal mengirim OTP: $e");
    }
  }
  Future<void> verifyOtp(String email, String otp) async {
    try {
      await _authApiClient.verifyOtp({'email': email, 'otp': otp});
    } catch (e) {
      throw Exception("OTP Salah atau Kadaluarsa");
    }
  }
  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      await _authApiClient.resetPassword({
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      });
    } catch (e) {
      throw Exception("Gagal mereset password: $e");
    }
  }
  Future<UserModel> updateProfile(String fullName) async {
    try {
      final response = await _authApiClient.updateProfile({
        'full_name': fullName,
      });
      await _storageService.saveUser(response);
      return response;
    } catch (e) {
      throw Exception("Gagal update profil: $e");
    }
  }
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _authApiClient.changePassword({
        'old_password': oldPassword,
        'new_password': newPassword,
      });
    } catch (e) {
      throw Exception("Gagal ganti password: $e");
    }
  }
  Future<UserModel> uploadAvatar(File file) async {
    try {
      final response = await _authApiClient.uploadAvatar(file);
      await _storageService.saveUser(response);
      return response;
    } catch (e) {
      throw Exception("Gagal upload avatar: $e");
    }
  }
  Future<void> logout() async {
    await _storageService.clearAll();
    print("Logout berhasil, data lokal dibersihkan.");
  }
}
