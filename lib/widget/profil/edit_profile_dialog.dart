import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/colors.dart';
class EditProfileDialog extends ConsumerStatefulWidget {
  final String currentName;
  const EditProfileDialog({super.key, required this.currentName});
  @override
  ConsumerState<EditProfileDialog> createState() => _EditProfileDialogState();
}
class _EditProfileDialogState extends ConsumerState<EditProfileDialog> {
  late TextEditingController _nameController;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Profil"),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: "Nama Lengkap"),
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
                  setState(() => _isLoading = true);
                  try {
                    await ref
                        .read(authControllerProvider.notifier)
                        .updateProfile(_nameController.text);
                    if (context.mounted) Navigator.pop(context);
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
