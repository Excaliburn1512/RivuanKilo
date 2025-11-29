import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/core/api/auth_api_client.dart';
import 'package:rivu_v1/core/services/firebase_service.dart';
import 'package:rivu_v1/models/device_data.dart';
import 'package:rivu_v1/models/plant_image_model.dart';
import 'package:rivu_v1/widget/togglebar.dart';
import 'package:rivu_v1/widget/detect/weekdayselector.dart';
import 'package:rivu_v1/widget/infocard.dart';
import 'package:rivu_v1/widget/systemstatusbanner.dart';
import 'package:rivu_v1/widget/detect/livecameraview.dart';
import 'package:rivu_v1/widget/detect/plantgriditem.dart';
final plantImagesProvider = FutureProvider.autoDispose<List<PlantImageModel>>((
  ref,
) async {
  final systemId = ref.watch(currentSystemIdProvider);
  if (systemId == null) return [];

  // Ambil semua gambar dari API (Backend sudah mengurutkan dari yang terbaru)
  final allImages = await ref
      .watch(authApiClientProvider)
      .getPlantImages(systemId);

  // AMBIL BATCH: Kita hanya ambil 4 foto terbaru (index 0 sampai 3)
  // Jika jumlah foto kurang dari 4, ambil semuanya.
  if (allImages.length > 4) {
    return allImages.sublist(0, 4);
  } else {
    return allImages;
  }
});
class DetectPage extends ConsumerStatefulWidget {
  const DetectPage({super.key});
  @override
  ConsumerState<DetectPage> createState() => _DetectPageState();
}
class _DetectPageState extends ConsumerState<DetectPage> {
  bool _isTanamanView = true;
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final deviceDataAsync = ref.watch(deviceStreamProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          ToggleBar(
            title: "Detect",
            isTanamanView: _isTanamanView,
            onTanamanPressed: () {
              setState(() {
                _isTanamanView = true;
              });
            },
            onKolamPressed: () {
              setState(() {
                _isTanamanView = false;
              });
            },
          ),
          SizedBox(height: 10),
          WeekDaySelector(),
          deviceDataAsync.when(
            data: (data) => AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _isTanamanView
                  ? _buildTanamanView(data)
                  : _buildKolamView(data),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, s) => Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(child: Text("Gagal memuat data: $e")),
            ),
          ),
        ],
      ),
    );
  }
 Widget _buildTanamanView(DeviceData data) {
    final sensor = data.sensorValue;
    final aktuator = data.aktuatorStatus;
    // ... (variabel sensor sama seperti sebelumnya)
    final suhuUdara = (sensor.suhuUdara ?? "").isEmpty
        ? "N/A"
        : sensor.suhuUdara!;
    final intensitas = (sensor.intensitasCahaya ?? "").isEmpty
        ? "N/A"
        : sensor.intensitasCahaya!;
    final permukaan_nutrisi = (sensor.permukaanNutrisi ?? "").isEmpty
        ? "N/A"
        : sensor.permukaanNutrisi!;
    final tdsNutrisi = (sensor.tdsNutrisi ?? "").isEmpty
        ? "N/A"
        : sensor.tdsNutrisi!;
    final pompaNutrisiStatus = aktuator.pompaNutrisi == "on";

    // PANGGIL PROVIDER GAMBAR DI SINI
    final imagesAsync = ref.watch(plantImagesProvider);

    return Column(
      key: ValueKey('tanaman'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BAGIAN GRID FOTO ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle("Batch Terbaru"),
            // Tombol Refresh untuk cek rombongan foto baru
            IconButton(
              icon: Icon(Icons.refresh, color: AppColors.primary),
              onPressed: () => ref.refresh(plantImagesProvider),
            ),
          ],
        ),

        imagesAsync.when(
          data: (images) {
            // Kita paksakan Grid selalu 4 slot agar rapi
            // Slot yang tidak ada fotonya akan menampilkan placeholder kosong
            return GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    2, // Ubah jadi 2 kolom biar foto lebih jelas (opsional, bisa 4)
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: 4, // Selalu render 4 kotak
              itemBuilder: (context, index) {
                // Cek apakah data tersedia untuk index ini
                final itemData = index < images.length ? images[index] : null;
                return PlantGridItem(data: itemData);
              },
            );
          },
          loading: () => Container(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => Container(
            height: 100,
            color: Colors.red.shade50,
            child: Center(child: Text("Gagal memuat foto: $err")),
          ),
        ),

        // --- END GRID FOTO ---
        _buildSectionTitle("Informasi sensor"),
        // ... (Sisa kode UI sensor tetap sama)
        Row(
          children: [
            Expanded(
              child: InfoCard(
                icon: Icons.thermostat,
                iconColor: Colors.red.shade400,
                title: "Suhu Udara",
                value: suhuUdara,
                unit: suhuUdara == "N/A" ? "" : "°C",
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: InfoCard(
                icon: Icons.water_drop_outlined,
                iconColor: Colors.blue.shade400,
                title: "TDS Nutrisi",
                value: tdsNutrisi,
                unit: tdsNutrisi == "N/A" ? "" : "ppm",
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InfoCard(
                icon: Icons.height,
                iconColor: Colors.green.shade600,
                title: "Permukaan Nutrisi",
                value: permukaan_nutrisi,
                unit: "cm",
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: InfoCard(
                icon: Icons.water_drop_outlined,
                iconColor: Colors.blue.shade400,
                title: "Kelembapan",
                value:
                    tdsNutrisi, // Note: Variabel kelembapan belum ada di model DeviceData anda
                unit: tdsNutrisi == "N/A" ? "" : "%",
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        InfoCard(
          icon: Icons.light_mode, // Ikon cahaya
          iconColor: Colors.orange.shade600,
          title: "Intensitas Cahaya",
          value: intensitas,
          unit: "lux",
        ),
        _buildSectionTitle("Status Sensor"),
        SystemStatusBanner(
          judul: "Status Pompa Nutrisi",
          ficon: Icons.local_drink,
          ricon: pompaNutrisiStatus ? Icons.check_circle : Icons.cancel,
          text: pompaNutrisiStatus ? "Aktif" : "Non-Aktif",
          color: pompaNutrisiStatus ? AppColors.primary : Colors.grey,
        ),
      ],
    );
  }
  Widget _buildKolamView(DeviceData data) {
    final currentSystemId = ref.watch(currentSystemIdProvider);
    final sensor = data.sensorValue;
    final aktuator = data.aktuatorStatus;
    final permukaan_kolam = (sensor.permukaanNutrisi ?? "").isEmpty
        ? "N/A"
        : sensor.permukaanKolam!;
    final suhuAir = (sensor.suhuUdara ?? "").isEmpty
        ? "N/A"
        : sensor.suhuUdara!;
    final tdsKolam = (sensor.tdsKolam ?? "").isEmpty ? "N/A" : sensor.tdsKolam!;
    final phKolam = (sensor.phKolam ?? "").isEmpty ? "N/A" : sensor.phKolam!;
    final pompaKolamStatus = aktuator.pompaKolam == "on";
    return Column(
      key: ValueKey('kolam'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Live Kamera"),
        LiveCameraView(deviceId: currentSystemId ?? ""),
        _buildSectionTitle("Informasi sensor"),
        Row(
          children: [
            Expanded(
              child: InfoCard(
                icon: Icons.thermostat,
                iconColor: Colors.red.shade400,
                title: "Suhu Air",
                value: suhuAir,
                unit: suhuAir == "N/A" ? "" : "°C",
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: InfoCard(
                icon: Icons.water_drop_outlined,
                iconColor: Colors.blue.shade400,
                title: "TDS Kolam",
                value: tdsKolam,
                unit: tdsKolam == "N/A" ? "" : "ppm",
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InfoCard(
                icon: Icons.science_outlined,
                iconColor: Colors.purple.shade400,
                title: "pH Kolam",
                value: phKolam,
                unit: "",
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: InfoCard(
                icon: Icons.height,
                iconColor: Colors.green.shade600,
                title: "Permukaan Kolam ",
                value: permukaan_kolam,
                unit: "cm",
              ),
            ),
          ],
        ),
        _buildSectionTitle("Status Sensor"),
        SystemStatusBanner(
          judul: "Status Pompa Kolam",
          text: pompaKolamStatus ? "Aktif" : "Non-Aktif",
          color: pompaKolamStatus ? AppColors.primary : Colors.grey,
          ficon: Icons.water,
          ricon: pompaKolamStatus ? Icons.check_circle : Icons.cancel,
        ),
      ],
    );
  }
}
