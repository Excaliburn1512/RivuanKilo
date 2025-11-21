
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/core/services/firebase_service.dart'; 
import 'package:rivu_v1/models/device_data.dart'; 
import 'package:rivu_v1/widget/control/devicecontrolcard.dart';
class ControlSensor extends ConsumerWidget {
  const ControlSensor({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceDataAsync = ref.watch(deviceStreamProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            deviceDataAsync.when(
              data: (data) => _buildHeaderCard(data),
              loading: () => _buildHeaderCard(null), 
              error: (e, s) => _buildHeaderCard(null), 
            ),
            const SizedBox(height: 24),
            _buildStatusToggle(), 
            const SizedBox(height: 24),
            deviceDataAsync.when(
              data: (data) {
                void updateAktuator(String key, bool value) {
                  ref
                      .read(firebaseServiceProvider)
                      .updateAktuator(key, value ? "on" : "off")
                      .catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Gagal update: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                }
                final pompaKolam = data.aktuatorStatus.pompaKolam == "on";
                final pompaNutrisi = data.aktuatorStatus.pompaNutrisi == "on";
                final pompaFilter =
                    data.aktuatorStatus.pompaFilterKolam == "on";
                final kipas = data.aktuatorStatus.kipas == "on";
                return _buildDevicesGrid(
                  pompaKolam: pompaKolam,
                  pompaNutrisi: pompaNutrisi,
                  pompaFilter: pompaFilter,
                  kipas: kipas,
                  onUpdate: updateAktuator,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text("Error: $e")),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  Widget _buildHeaderCard(DeviceData? data) {
    int onCount = 0;
    if (data != null) {
      final status = data.aktuatorStatus;
      if (status.pompaKolam == "on") onCount++;
      if (status.pompaNutrisi == "on") onCount++;
      if (status.pompaFilterKolam == "on") onCount++;
      if (status.kipas == "on") onCount++;
    }
    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: const DecorationImage(
          image: AssetImage("assets/background/background.png"),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Kontrol Sistem",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data == null ? "Memuat..." : "$onCount/4 Menyala",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatusToggle() {
    return Consumer(
      builder: (context, ref, child) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool statusSistem = true; 
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Status Sistem",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Switch(
                    value: statusSistem,
                    onChanged: (value) {
                      setState(() {
                        statusSistem = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildDevicesGrid({
    required bool pompaKolam,
    required bool pompaNutrisi,
    required bool pompaFilter,
    required bool kipas,
    required Function(String, bool) onUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Devices",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DeviceControlCard(
              iconData: Icons.water_drop_outlined,
              title: "Pompa Kolam",
              subtitle: "1 Device",
              isActive: pompaKolam,
              onChanged: (value) => onUpdate('pompa_kolam', value),
            ),
            DeviceControlCard(
              iconData: Icons.local_drink_outlined,
              title: "Pompa Nutrisi",
              subtitle: "1 Device",
              isActive: pompaNutrisi,
              onChanged: (value) => onUpdate('pompa_nutrisi', value),
            ),
            DeviceControlCard(
              iconData: Icons.filter_alt_outlined,
              title: "Pompa Filter",
              subtitle: "1 Device",
              isActive: pompaFilter,
              onChanged: (value) => onUpdate('pompa_filter_kolam', value),
            ),
            DeviceControlCard(
              iconData: Icons.air_outlined,
              title: "Kipas",
              subtitle: "1 Device",
              isActive: kipas,
              onChanged: (value) => onUpdate('kipas', value),
            ),
          ],
        ),
      ],
    );
  }
}
