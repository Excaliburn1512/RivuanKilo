

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/usermodel.dart'; 
import 'package:rivu_v1/core/route.dart'; 
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/widget/profil/avatar.dart';
import 'package:rivu_v1/widget/profil/buttonprofile.dart';
import 'package:rivu_v1/widget/profil/profilinfo.dart'; 


class ProfileView extends StatefulWidget {
  final Usermodel user;
  const ProfileView({super.key, required this.user});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _handleLogout() {
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushReplacementNamed(
      AppRoutes.login, //
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            ProfileAvatar(),
            SizedBox(height: 32),

            ProfileInfoField(label: "Nama", value: widget.user.name),
            SizedBox(height: 16),
            ProfileInfoField(label: "Email", value: widget.user.email),
            SizedBox(height: 16),
            ProfileInfoField(
              label: "Kata Sandi",
              value: "**********", 
              isObscure: true,
            ),

            _buildChangePasswordButton(),
            SizedBox(height: 24),

            ProfileActionButton(
              text: "Edit Profil",
              isFilled: true,
              onPressed: () {
                print("Navigasi ke Edit Profil...");
              },
            ),
            SizedBox(height: 12),
            ProfileActionButton(
              text: "Keluar",
              isFilled: false,
              onPressed: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
        },
        child: Text(
          "Ubah Kata Sandi?",
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
