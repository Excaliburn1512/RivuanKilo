import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rivu_v1/auth/view/viewlogin.dart';
import 'package:rivu_v1/auth/view/viewregister.dart';
import 'package:rivu_v1/auth/view/viewforgotpassword.dart';
enum AuthView { login, register, forgotPassword }
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}
class _AuthPageState extends State<AuthPage> {
  AuthView _currentView = AuthView.login;
  void _navigateTo(AuthView view) {
    setState(() {
      _currentView = view;
    });
  }
  Widget _buildCurrentView() {
    switch (_currentView) {
      case AuthView.login:
        return LoginPage(
          onGoToRegister: () => _navigateTo(AuthView.register),
          onGoToForgotPassword: () => _navigateTo(AuthView.forgotPassword),
        );
      case AuthView.register:
        return RegisterPage(onGoToLogin: () => _navigateTo(AuthView.login));
      case AuthView.forgotPassword:
        return ForgotPasswordPage(
          onGoToLogin: () => _navigateTo(AuthView.login),
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child:RotatedBox(
                quarterTurns: 1, 
                child: Lottie.asset(
                  'assets/background/Animation.json',
                  fit: BoxFit.cover,
                ),
              ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: _buildCurrentView(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
