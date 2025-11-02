import "package:flutter/material.dart";
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rivu_v1/colors.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const Navbar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            curve: Curves.easeInOut,
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: AppColors.primary,
            color: Colors.black,
            haptic: true,

            tabs: [
              GButton(icon: Icons.home, text: 'Beranda'),
              GButton(icon: Icons.camera_alt, text: 'Deteksi'),
              GButton(icon: Icons.settings_remote, text: 'Control'),
              GButton(icon: Icons.history, text: 'Riwayat'),
              GButton(icon: Icons.person, text: 'Profil'),
            ],

            selectedIndex: selectedIndex, 
            onTabChange: onTabChange, 
          ),
        ),
      ),
    );
  }
}
