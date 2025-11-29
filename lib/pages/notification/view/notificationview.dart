import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/core/api/auth_api_client.dart';
import 'package:rivu_v1/core/services/firebase_service.dart';
import 'package:rivu_v1/models/notification_model.dart';
import 'package:rivu_v1/widget/filtertab3.dart';
import 'package:rivu_v1/widget/listitem.dart';
import 'package:intl/intl.dart';

// Provider fetch data dari API
final notificationListProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
      final systemId = ref.watch(currentSystemIdProvider);
      if (systemId == null) return [];
      return ref.watch(authApiClientProvider).getNotifications(systemId);
    });

class NotificationView extends ConsumerStatefulWidget {
  const NotificationView({super.key});

  @override
  ConsumerState<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends ConsumerState<NotificationView> {
  int _subFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final notificationAsync = ref.watch(notificationListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Notifikasi",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black87),
            onPressed: () => ref.refresh(notificationListProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SubFilterBar(
              activeIndex: _subFilterIndex,
              onFilterPressed: (index) {
                setState(() {
                  _subFilterIndex = index;
                });
              },
            ),
          ),
          Expanded(
            child: notificationAsync.when(
              data: (notifications) {
                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Belum ada notifikasi",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final item = notifications[index];

                    // Format Tanggal
                    String formattedDate = item.createdAt;
                    try {
                      final date = DateTime.parse(item.createdAt).toLocal();
                      formattedDate = DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(date);
                    } catch (_) {}

                    return ListItem(
                      title: item.title,
                      date: formattedDate,
                      statusText: item.body,
                      // LOGIKA WARNA STATUS:
                      // Jika mengandung kata-kata negatif -> False (Merah)
                      // Selain itu -> True (Hijau/Biru)
                      isStatusActive:
                          !(item.title.toLowerCase().contains("error") ||
                              item.title.toLowerCase().contains("peringatan") ||
                              item.body.toLowerCase().contains("kosong") ||
                              item.body.toLowerCase().contains(
                                "habis",
                              ) || // Deteksi Nutrisi Habis
                              item.body.toLowerCase().contains(
                                "surut",
                              ) // Deteksi Air Surut
                              ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text("Gagal memuat notifikasi: $err")),
            ),
          ),
        ],
      ),
    );
  }
}
