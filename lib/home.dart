import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/core/api/auth_api_client.dart';
import 'package:rivu_v1/core/services/firebase_service.dart';
import 'package:rivu_v1/models/device_data.dart';
import 'package:rivu_v1/pages/controlsensor/view/controlview.dart';
import 'package:rivu_v1/pages/dashboard/view/dashboardview.dart';
import 'package:rivu_v1/pages/detect/view/detectview.dart';
import 'package:rivu_v1/pages/history/view/historyview.dart';
import 'package:rivu_v1/pages/profile/view/profileview.dart';
import 'package:rivu_v1/widget/bottomnavbar.dart';
import 'package:rivu_v1/widget/profil/profile_about_dialog.dart';
import 'package:rivu_v1/widget/profil/profile_switch_dialog.dart';
import 'package:rivu_v1/widget/profil/profile_unlink_dialog.dart';
import 'package:rivu_v1/core/services/notification_services.dart';
class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  ConsumerState<Home> createState() => _HomeState();
}
class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;
  static final Map<String, String> _lastProcessedStatus = {};
  static final Map<String, DateTime> _lastLogTime = {};
  final List<Widget> _widgetOptions = const <Widget>[
    Dashboard(),
    DetectPage(),
    ControlSensor(),
    HistoryView(),
    ProfileView(),
  ];
  @override
  void initState() {
    super.initState();
    print(
      "Home Widget Initialized",
    ); 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).init();
    });
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      ref.refresh(historyLogProvider);
    }
  }
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<DeviceData>>(deviceStreamProvider, (prev, next) {
      next.whenData((newData) {
        if (prev != null && prev.value != null) {
          final oldData = prev.value!;
          _checkAndUploadLog(oldData.aktuatorStatus, newData.aktuatorStatus);
        } else if (prev == null || prev.value == null) {
          _syncInitialState(newData.aktuatorStatus);
        }
      });
    });
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
  void _syncInitialState(AktuatorStatus status) {
    if (status.pompaKolam != null)
      _lastProcessedStatus['pompa_kolam'] = status.pompaKolam!;
    if (status.pompaNutrisi != null)
      _lastProcessedStatus['pompa_nutrisi'] = status.pompaNutrisi!;
    if (status.pompaFilterKolam != null)
      _lastProcessedStatus['pompa_filter'] = status.pompaFilterKolam!;
    if (status.kipas != null) _lastProcessedStatus['kipas'] = status.kipas!;
  }
  void _checkAndUploadLog(AktuatorStatus oldStatus, AktuatorStatus newStatus) {
    final systemId = ref.read(currentSystemIdProvider);
    if (systemId == null) return;
    void checkAndSend(String key, String name, String? oldVal, String? newVal) {
      if (newVal == null) return; 
      if (oldVal == newVal) return; 
      if (_lastProcessedStatus.containsKey(key) &&
          _lastProcessedStatus[key] == newVal) {
        return;
      }
      final now = DateTime.now();
      if (_lastLogTime.containsKey(key)) {
        final lastTime = _lastLogTime[key]!;
        final difference = now.difference(lastTime).inMilliseconds;
        if (difference < 2000) {
          print(
            "LOG BLOCKED (Time Debounce): Duplicate event detected for $name within ${difference}ms",
          );
          return;
        }
      }
      _lastProcessedStatus[key] = newVal;
      _lastLogTime[key] = now;
      final isActive = newVal == "on";
      final statusText = isActive ? "Aktif" : "Non Aktif";
      print("LOG SENDING: $name -> $statusText");
      try {
        ref.read(authApiClientProvider).postHistoryLog(systemId, {
          "device_name": name,
          "status": statusText,
          "is_active": isActive,
        });
      } catch (e) {
        print("LOG ERROR: Gagal upload history: $e");
      }
    }
    checkAndSend(
      "pompa_kolam",
      "Pompa Kolam",
      oldStatus.pompaKolam,
      newStatus.pompaKolam,
    );
    checkAndSend(
      "pompa_nutrisi",
      "Pompa Nutrisi",
      oldStatus.pompaNutrisi,
      newStatus.pompaNutrisi,
    );
    checkAndSend(
      "pompa_filter",
      "Pompa Filter",
      oldStatus.pompaFilterKolam,
      newStatus.pompaFilterKolam,
    );
    checkAndSend("kipas", "Kipas", oldStatus.kipas, newStatus.kipas);
  }
  Widget _buildProfileFab(BuildContext context, WidgetRef ref) {
    return ExpandableFab(
      key: const Key('profileFab'),
      distance: 90,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const HugeIcon(icon: HugeIcons.strokeRoundedSetting07),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
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
