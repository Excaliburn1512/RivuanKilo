
import 'package:rivu_v1/auth/model/system_model.dart';
import 'package:rivu_v1/auth/model/user_model.dart';
class AuthState {
  final UserModel? user;
  final List<SystemModel>? systems;
  AuthState({this.user, this.systems});
  bool get isLoggedIn => user != null;
  factory AuthState.loggedOut() => AuthState(user: null, systems: null);
}
