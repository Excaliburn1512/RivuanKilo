
import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/auth/repository/auth_repository.dart';
import 'package:rivu_v1/auth/model/auth_state.dart';
import 'package:rivu_v1/core/services/firebase_service.dart'; 
final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  () {
    return AuthController();
  },
);
class AuthController extends AsyncNotifier<AuthState> {
  late AuthRepository _authRepository;
  @override
  FutureOr<AuthState> build() async {
    _authRepository = ref.watch(authRepositoryProvider);
    final authState = await _authRepository.checkSession();
    if (authState.isLoggedIn) {
      ref.read(selectedSystemIdProvider.notifier).state = authState
          .systems
          ?.firstOrNull
          ?.systemId
          .toString();
    }
    return authState;
  }
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final authState = await _authRepository.login(email, password);
      ref.read(selectedSystemIdProvider.notifier).state = authState
          .systems
          ?.firstOrNull
          ?.systemId
          .toString();
      state = AsyncValue.data(authState);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
  Future<void> updateProfile(String fullName) async {
    final currentUser = state.valueOrNull?.user;
    if (currentUser == null) return;
    state = const AsyncValue.loading();
    try {
      final updatedUser = await _authRepository.updateProfile(fullName);
      state = AsyncValue.data(
        AuthState(user: updatedUser, systems: state.valueOrNull?.systems),
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _authRepository.changePassword(oldPassword, newPassword);
  }
  Future<void> uploadAvatar(File imageFile) async {
    final currentUser = state.valueOrNull?.user;
    if (currentUser == null) return;
    try {
      final updatedUser = await _authRepository.uploadAvatar(imageFile);
      state = AsyncValue.data(
        AuthState(user: updatedUser, systems: state.valueOrNull?.systems),
      );
    } catch (e) {
      print("Upload avatar failed: $e");
      rethrow;
    }
  }
  Future<void> registerAndProvision({
    required String name,
    required String email,
    required String password,
    required String deviceIdentifier,
    required String deviceName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final authState = await _authRepository.registerAndProvision(
        name: name,
        email: email,
        password: password,
        deviceIdentifier: deviceIdentifier,
        deviceName: deviceName,
      );
      ref.read(selectedSystemIdProvider.notifier).state = authState
          .systems
          ?.firstOrNull
          ?.systemId
          .toString();
      state = AsyncValue.data(authState);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
  Future<void> provisionDevice({
    required String deviceIdentifier,
    required String deviceName,
  }) async {
    final oldState = state.valueOrNull;
    state = const AsyncValue.loading(); 
    try {
      final newSystems = await _authRepository.provisionDevice(
        deviceIdentifier: deviceIdentifier,
        deviceName: deviceName,
      );
      state = AsyncValue.data(
        AuthState(user: oldState?.user, systems: newSystems),
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s); 
      state = AsyncValue.data(oldState!); 
      rethrow; 
    }
  }
  Future<void> unlinkDevice(String systemId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return; 
    try {
      await _authRepository.unlinkDevice(systemId);
      final newSystems = currentState.systems
          ?.where((s) => s.systemId.toString() != systemId)
          .toList();
      state = AsyncValue.data(
        AuthState(user: currentState.user, systems: newSystems),
      );
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      state = AsyncValue.data(currentState);
      rethrow;
    }
  }
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.logout();
      ref.read(selectedSystemIdProvider.notifier).state = null;
      state = AsyncValue.data(AuthState.loggedOut());
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
