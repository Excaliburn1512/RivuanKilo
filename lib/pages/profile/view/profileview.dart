import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/widget/profil/avatar.dart';
import 'package:rivu_v1/widget/profil/buttonprofile.dart';
import 'package:rivu_v1/widget/profil/change_password_dialog.dart';
import 'package:rivu_v1/widget/profil/edit_profile_dialog.dart';
import 'package:rivu_v1/widget/profil/profilinfo.dart';
class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});
  void _handleLogout(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: authState.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e")),
        data: (state) {
          if (!state.isLoggedIn || state.user == null) {
            return Center(child: Text("User tidak login."));
          }
          final user = state.user!;
          const double headerHeight = 230.0;
          const double avatarRadius = 50.0;
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: headerHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background/background.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: headerHeight - (avatarRadius * 1.5)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.only(
                        top: avatarRadius + 16,
                        bottom: 24,
                        left: 24,
                        right: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ProfileInfoField(
                            label: "Nama",
                            value: user.displayName,
                          ),
                          SizedBox(height: 16),
                          ProfileInfoField(label: "Email", value: user.email),
                          SizedBox(height: 16),
                          ProfileInfoField(
                            label: "Kata Sandi",
                            value: "**********",
                            isObscure: true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ChangePasswordDialog(),
                                );
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
                          ),
                          SizedBox(height: 24),
                          ProfileActionButton(
                            text: "Edit Profil",
                            isFilled: true,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditProfileDialog(
                                  currentName: user.displayName,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 12),
                          ProfileActionButton(
                            text: "Keluar",
                            isFilled: false,
                            onPressed: () => _handleLogout(context, ref),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
              Positioned(
                top: headerHeight - (avatarRadius * 3),
                child: ProfileAvatar(),
              ),
            ],
          );
        },
      ),
    );
  }
}
