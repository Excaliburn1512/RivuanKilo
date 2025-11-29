import "package:flutter/material.dart";
import 'package:elegant_nav_bar/elegant_nav_bar.dart' hide AppColors;
import 'package:hugeicons/hugeicons.dart';
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
    return ElegantBottomNavigationBar(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      currentIndex: selectedIndex,
      onTap: onTabChange,
      indicatorColor: AppColors.primary,
      indicatorPosition: IndicatorPosition.bottom, 
      indicatorShape: IndicatorShape.bar, 
      indicatorHeight: 3.0, 
      indicatorWidth: 30.0, 
      indicatorDiameter: 6.0, 
      elevation: 8.0,
      height: 65.0,
      borderRadius: 15.0,
      isFloating: true,
      floatingMargin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      floatingBorderRadius: 24.0,
      iconSize: 22.0,
      selectedLabelStyle: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
      items: [
        NavigationItem(iconWidget: HugeIcon(icon: HugeIcons.strokeRoundedHome01), label: 'Beranda'),
        NavigationItem(iconWidget: HugeIcon(icon: HugeIcons.strokeRoundedCamera01), label: 'Deteksi'),
        NavigationItem(
          iconWidget: HugeIcon(icon: HugeIcons.strokeRoundedRemoteControl),
          label: 'Control',
        ),
        NavigationItem(iconWidget: HugeIcon(icon: HugeIcons.strokeRoundedTransactionHistory), label: 'Riwayat'),
        NavigationItem(iconWidget: HugeIcon(icon: HugeIcons.strokeRoundedProfile02), label: 'Profil'),
      ],
    );
  }
}
