import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/auth/view/pairing_dialog.dart';
import 'package:rivu_v1/auth/view/wifi_dialog.dart';
import 'package:rivu_v1/core/services/bluetooth_service.dart'; // Import ini penting
import 'package:rivu_v1/widget/authtextfield.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final VoidCallback onGoToLogin;
  const RegisterPage({super.key, required this.onGoToLogin});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
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
// Ganti _handleRegister Anda dengan ini
  Future<void> _handleRegister() async {
    // ... (validasi field)
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError("Konfirmasi password tidak cocok");
      return;
    }

    // 1. Tampilkan PairingDialog
    final deviceIdentifier = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PairingDialog(),
    );
    if (deviceIdentifier == null || deviceIdentifier.isEmpty)
      return; // User batal

    // 2. Tampilkan WifiDialog
    final deviceName = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WifiDialog(),
    );
    if (deviceName == null || deviceName.isEmpty) return; // User batal

    // 3. Panggil SATU FUNGSI untuk melakukan semuanya
    try {
      await ref
          .read(authControllerProvider.notifier)
          .registerAndProvision(
            name: _namaController.text,
            email: _emailController.text,
            password: _passwordController.text,
            deviceIdentifier: deviceIdentifier,
            deviceName: deviceName,
          );
      // Jika berhasil, AuthGate akan otomatis memindahkan user
    } catch (e) {
      // AuthController sudah di set ke AsyncError,
      // snackbar akan muncul otomatis dari listener
      _showError("Proses registrasi gagal: $e");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (UI Build tetap sama seperti kode Anda sebelumnya)
    final authState = ref.watch(authControllerProvider);

    // Listener untuk error global dari controller (opsional, karena sudah di-handle di try-catch)
    ref.listen(authControllerProvider, (_, state) {
      if (state is AsyncError) {
        // _showError(state.error.toString()); // Bisa dikomentari jika double alert
      }
    });

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
          // ... (Sisa widget UI input field sama persis dengan kode Anda)
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
                    onPressed: authState.isLoading ? null : _handleRegister,
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            "Lanjut",
                            style: TextStyle(
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
                child: const Text(
                  "Masuk di sini",
                  style: TextStyle(
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
