import 'package:flutter/material.dart';
import 'package:rivu_v1/home.dart';
import 'package:rivu_v1/login/view/viewlogin.dart';
import 'package:rivu_v1/splash.dart';
import 'package:rivu_v1/usermodel.dart';

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
        // Ambil argumen yang dikirim dari LoginPage
        final user = settings.arguments as Usermodel?;

        if (user != null) {
          // Jika ada data user, kirim ke Home
          return MaterialPageRoute(builder: (_) => Home(user: user));
        }

        // Fallback jika rute /home dipanggil tanpa data
        return MaterialPageRoute(
          builder: (_) => _ErrorScreen(routeName: "Home (Data User Hilang)"),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
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
