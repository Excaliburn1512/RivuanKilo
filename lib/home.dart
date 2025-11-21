
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/pages/controlsensor/view/controlview.dart';
import 'package:rivu_v1/pages/dashboard/view/dashboardview.dart';
import 'package:rivu_v1/pages/detect/view/detectview.dart';
import 'package:rivu_v1/pages/history/view/historyview.dart';
import 'package:rivu_v1/pages/profile/view/profileview.dart';
import 'package:rivu_v1/widget/bottomnavbar.dart';
import 'package:rivu_v1/widget/profil/profile_about_dialog.dart';
import 'package:rivu_v1/widget/profil/profile_switch_dialog.dart';
import 'package:rivu_v1/widget/profil/profile_unlink_dialog.dart';
class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  ConsumerState<Home> createState() => _HomeState();
}
class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = const <Widget>[
    Dashboard(),
    DetectPage(),
    ControlSensor(),
    HistoryView(),
    ProfileView(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    if (authState is! AsyncData) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final bool showFab = (_selectedIndex == 4); 
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: showFab ? _buildProfileFab(context, ref) : null,
    );
  }
  Widget _buildProfileFab(BuildContext context, WidgetRef ref) {
    return ExpandableFab(
      key: const Key('profileFab'),
      distance: 90,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.settings),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      children: [
        FloatingActionButton.small(
          heroTag: 'gantiPerangkat',
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          child: const Icon(Icons.swap_horiz),
          onPressed: () => showGantiPerangkatDialog(context, ref),
        ),
        FloatingActionButton.small(
          heroTag: 'putuskanPerangkat',
          backgroundColor: Colors.white,
          foregroundColor: AppColors.errortext,
          child: const Icon(Icons.link_off),
          onPressed: () => showPutuskanPerangkatDialog(context, ref),
        ),
        FloatingActionButton.small(
          heroTag: 'tentangApp',
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          child: const Icon(Icons.info_outline),
          onPressed: () => showTentangAppDialog(context),
        ),
      ],
    );
  }
}
