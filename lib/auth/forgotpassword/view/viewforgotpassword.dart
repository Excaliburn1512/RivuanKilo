import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/widget/authtextfield.dart';
import 'package:rivu_v1/widget/passwordindicator.dart';

class ForgotPasswordPage extends StatefulWidget {
  final VoidCallback onGoToLogin;

  const ForgotPasswordPage({super.key, required this.onGoToLogin});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _currentStep = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _password = "";

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildStepView() {
    switch (_currentStep) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildOtpStep();
      case 2:
        return _buildNewPasswordStep();
      default:
        return _buildEmailStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _buildStepView(),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: widget.onGoToLogin, 
            child: Text(
              "Kembali ke Login",
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildEmailStep() {
    return Column(
      key: ValueKey(0),
      children: [
        Text(
          "Lupa Password Anda?",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          "Masukkan email Anda untuk menerima kode OTP",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        _buildAuthContainer(
          child: Column(
            children: [
              Authtextfield(
                hintText: "Email",
                icon: Icons.email_outlined,
                controller: _emailController,
              ),
              SizedBox(height: 24),
              _buildAuthButton(
                text: "Kirim OTP",
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                  }); 
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      key: ValueKey(1),
      children: [
        Text("Verifikasi Email", style: _titleStyle()),
        SizedBox(height: 8),
        Text(
          "Masukkan kode 6 digit yang dikirim ke email Anda",
          style: _subtitleStyle(),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        _buildAuthContainer(
          child: Column(
            children: [
              Authtextfield(
                hintText: "Kode OTP",
                icon: Icons.password_outlined,
                controller: _otpController,
              ),
              SizedBox(height: 24),
              _buildAuthButton(
                text: "Verifikasi",
                onPressed: () {
                  setState(() {
                    _currentStep = 2;
                  }); 
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewPasswordStep() {
    return Column(
      key: ValueKey(2),
      children: [
        Text("Buat Password Baru", style: _titleStyle()),
        SizedBox(height: 8),
        Text(
          "Password baru Anda harus kuat dan aman",
          style: _subtitleStyle(),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        _buildAuthContainer(
          child: Column(
            children: [
              Authtextfield(
                hintText: "Password Baru",
                icon: Icons.lock_outlined,
                controller: _passwordController,
                isPassword: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              SizedBox(height: 16),
              PasswordStrengthIndicator(password: _password),
              SizedBox(height: 16),
              Authtextfield(
                hintText: "Konfirmasi Password Baru",
                icon: Icons.lock_reset,
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              SizedBox(height: 24),
              _buildAuthButton(
                text: "Simpan Password",
                onPressed: () {
                  widget.onGoToLogin();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle _titleStyle() => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  TextStyle _subtitleStyle() =>
      TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500);

  Widget _buildAuthContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildAuthButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
