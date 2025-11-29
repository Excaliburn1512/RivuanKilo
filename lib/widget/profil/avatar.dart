import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/colors.dart';
class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull?.user;
    final String? avatarUrl = user?.profilePicture;
    final String fullUrl = avatarUrl != null
        ? "https://rivu.web.id/$avatarUrl?v=${DateTime.now().millisecondsSinceEpoch}"
        : "";
    return Stack(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
              ? NetworkImage(fullUrl)
              : null,
          child: (avatarUrl == null || avatarUrl.isEmpty)
              ? Icon(Icons.person, size: 60, color: Colors.grey.shade600)
              : null,
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: InkWell(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                try {
                  await ref
                      .read(authControllerProvider.notifier)
                      .uploadAvatar(File(image.path));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Foto profil diperbarui")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Gagal upload: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.edit_outlined, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
