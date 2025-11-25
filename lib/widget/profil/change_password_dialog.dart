import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/colors.dart';
class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});
  @override
  ConsumerState<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}
class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Ubah Kata Sandi"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _oldPassController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Kata Sandi Lama"),
          ),
          TextField(
            controller: _newPassController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Kata Sandi Baru"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Batal"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: _isLoading
              ? null
              : () async {
                  if (_newPassController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Password minimal 6 karakter")),
                    );
                    return;
                  }
                  setState(() => _isLoading = true);
                  try {
                    await ref
                        .read(authControllerProvider.notifier)
                        .changePassword(
                          _oldPassController.text,
                          _newPassController.text,
                        );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Password berhasil diubah")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
          child: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text("Simpan", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
