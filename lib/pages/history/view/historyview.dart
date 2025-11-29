import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/core/api/auth_api_client.dart';
import 'package:rivu_v1/core/services/firebase_service.dart';
import 'package:rivu_v1/models/history_model.dart';
import 'package:rivu_v1/models/plant_image_model.dart'; // Import Model Gambar
import 'package:rivu_v1/widget/detect/plant_detail_dialog.dart';
import 'package:rivu_v1/widget/togglebar.dart';
import 'package:rivu_v1/widget/filtertab3.dart';
import 'package:rivu_v1/widget/listitem.dart';
import 'package:intl/intl.dart';

// Provider untuk Log Aktuator (Pompa/Kipas)
final historyLogProvider = FutureProvider.autoDispose<List<HistoryModel>>((
  ref,
) async {
  final systemId = ref.watch(currentSystemIdProvider);
  if (systemId == null) return [];
  return ref.watch(authApiClientProvider).getHistoryLogs(systemId);
});

// Provider untuk History Tanaman (Semua Gambar)
final plantHistoryProvider = FutureProvider.autoDispose<List<PlantImageModel>>((
  ref,
) async {
  final systemId = ref.watch(currentSystemIdProvider);
  if (systemId == null) return [];
  // Ambil semua gambar dari API (sudah urut waktu dari backend)
  return ref.watch(authApiClientProvider).getPlantImages(systemId);
});

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  bool _isTanamanView = true;
  int _subFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyLogProvider);
    final plantHistoryAsync = ref.watch(
      plantHistoryProvider,
    ); // Watch data tanaman

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(historyLogProvider);
          ref.refresh(plantHistoryProvider); // Refresh kedua provider
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              ToggleBar(
                title: "History",
                isTanamanView: _isTanamanView,
                onTanamanPressed: () => setState(() => _isTanamanView = true),
                onPompaPressed: () => setState(() => _isTanamanView = false),
              ),
              const SizedBox(height: 16),
              SubFilterBar(
                activeIndex: _subFilterIndex,
                onFilterPressed: (index) =>
                    setState(() => _subFilterIndex = index),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isTanamanView
                    ? plantHistoryAsync.when(
                        // Gunakan data API untuk Tanaman
                        data: (images) => _buildTanamanListFromApi(images),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            Center(child: Text('Error: $err')),
                      )
                    : historyAsync.when(
                        // Gunakan data API untuk Pompa
                        data: (logs) => _buildPompaListFromApi(logs),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            Center(child: Text('Error: $err')),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi Builder untuk List Tanaman (DARI API)
  Widget _buildTanamanListFromApi(List<PlantImageModel> images) {
    if (images.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Belum ada riwayat deteksi tanaman."),
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey('tanaman_list_api'),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final item = images[index];

        // Format Tanggal
        String formattedDate = item.capturedAt;
        try {
          final date = DateTime.parse(item.capturedAt).toLocal();
          formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
        } catch (_) {}

        // Format Status Teks (tambah confidence jika ada)
        String statusText = item.diagnosisResult ?? "Memproses...";

        // Bungkus ListItem dengan InkWell/GestureDetector agar bisa diklik
        return GestureDetector(
          onTap: () {
            // TAMPILKAN POP-UP DETAIL DI SINI
            showDialog(
              context: context,
              builder: (context) => PlantDetailDialog(data: item),
            );
          },
          child: ListItem(
            title: statusText, // Judul adalah hasil diagnosa
            date: formattedDate,
            statusText: item.diagnosisConfidence != null
                ? "Akurasi: ${(item.diagnosisConfidence! * 100).toStringAsFixed(1)}%"
                : "Menunggu hasil...",
            isStatusActive:
                item.diagnosisResult?.contains("Sehat") ??
                false, // Hijau jika sehat, Merah jika sakit
          ),
        );
      },
    );
  }

  // Fungsi Builder untuk List Pompa (Tetap sama)
  Widget _buildPompaListFromApi(List<HistoryModel> logs) {
    if (logs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Belum ada riwayat aktivitas pompa."),
        ),
      );
    }
    return ListView.builder(
      key: const ValueKey('pompa_list_api'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final item = logs[index];
        String formattedDate = item.createdAt;
        try {
          final date = DateTime.parse(item.createdAt).toLocal();
          formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
        } catch (_) {}
        return ListItem(
          title: item.deviceName,
          date: formattedDate,
          statusText: item.status,
          isStatusActive: item.isActive,
        );
      },
    );
  }
}
