import 'package:flutter/material.dart';
import 'package:rivu_v1/dashboard/view/dashboard.dart';
import 'package:rivu_v1/splash.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String initial = splash;
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => Splash());
      case home:
        return MaterialPageRoute(builder: (_) => Dashboard());

      case login:
        return MaterialPageRoute(
          builder: (_) => _ErrorScreen(routeName: settings.name),
        );

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
