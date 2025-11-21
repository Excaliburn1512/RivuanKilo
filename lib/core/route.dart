import 'package:flutter/material.dart';
import 'package:rivu_v1/auth/baseauth.dart';
import 'package:rivu_v1/auth/view/auth_gate.dart'; 
import 'package:rivu_v1/home.dart';
import 'package:rivu_v1/pages/notification/view/notificationview.dart';
import 'package:rivu_v1/splash.dart';
class AppRoutes {
  static const String authGate = '/'; 
  static const String auth = '/auth';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String detect = '/detect';
  static const String notification = '/notifications';
  static const String history = '/history';
  static const String splash = '/splash';
  static const String initial = authGate; 
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash: 
        return MaterialPageRoute(builder: (_) => const Splash());
      case authGate:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationView());
      default:
        return MaterialPageRoute(
          builder: (_) => _ErrorScreen(routeName: settings.name),
        );
    }
  }
}
class _ErrorScreen extends StatelessWidget {
  final String? routeName;
  const _ErrorScreen({Key? key, this.routeName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text(
          'Rute tidak ditemukan: ${routeName ?? 'Unknown'}\n'
          'Silakan implementasikan rute ini di AppRoutes.onGenerateRoute',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
