import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// 1. Impor nama class yang sudah benar
import 'package:rivu_v1/auth/login/view/viewlogin.dart';
import 'package:rivu_v1/auth/register/view/viewregister.dart'; // Nama class di sini adalah RegisterPage
import 'package:rivu_v1/auth/forgotpassword/view/viewforgotpassword.dart'; // Nama class di sini adalah ForgotPasswordPage

// 2. Enum bisa dipisah ke file sendiri (auth_view.dart)
// atau biarkan di sini
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
        // 3. Panggil nama class yang benar
        return RegisterPage(onGoToLogin: () => _navigateTo(AuthView.login));
      case AuthView.forgotPassword:
        // 3. Panggil nama class yang benar
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
          // ... (background Lottie tidak berubah)
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Lottie.asset(
                'assets/background/bg.json',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
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
