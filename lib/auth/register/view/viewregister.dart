import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/widget/authtextfield.dart'; 

class RegisterPage extends StatefulWidget {
  final VoidCallback onGoToLogin;

  const RegisterPage({super.key, required this.onGoToLogin});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Text(
            "Buat Akun Baru", 
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
            "Daftar untuk memulai kontrol aquaponik Anda", 
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
                  hintText: "Nama Lengkap",
                  icon: Icons.person_outline,
                  controller: _namaController,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                Authtextfield(
                  hintText: "Konfirmasi Password",
                  icon: Icons.lock_reset_rounded,
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
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
                    onPressed: () {
                      print("Registering...");
                      widget.onGoToLogin(); 
                    },
                    child: Text(
                      "Daftar",
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
                "Sudah punya akun? ",
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: widget.onGoToLogin,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                child: Text(
                  "Masuk di sini",
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
