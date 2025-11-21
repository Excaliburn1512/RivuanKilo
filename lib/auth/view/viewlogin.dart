import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart'; 
import 'package:rivu_v1/widget/authtextfield.dart';
class LoginPage extends ConsumerStatefulWidget {
  final VoidCallback onGoToRegister;
  final VoidCallback onGoToForgotPassword;
  const LoginPage({
    super.key,
    required this.onGoToRegister,
    required this.onGoToForgotPassword,
  });
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _handleLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
      return;
    }
    ref
        .read(authControllerProvider.notifier)
        .login(_emailController.text, _passwordController.text);
  }
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    ref.listen(authControllerProvider, (_, state) {
      if (state is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Gagal: ${state.error.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const SizedBox(height: 24),
          const Text(
            "Selamat Datang Kembali",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Masuk untuk melanjutkan ke Rivu",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Authtextfield(
                  hintText: "Email",
                  icon: Icons.email_outlined,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                Authtextfield(
                  hintText: "Password",
                  icon: Icons.lock_outlined,
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: widget.onGoToForgotPassword,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    child: Text(
                      "Lupa Password?",
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: authState.isLoading ? null : _handleLogin,
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Belum punya akun? ",
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: widget.onGoToRegister,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: Text(
                  "Daftar di sini",
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
