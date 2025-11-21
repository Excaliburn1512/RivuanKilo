import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/widget/filtertab3.dart';
import 'package:rivu_v1/widget/listitem.dart';
class NotificationView extends StatefulWidget {
  const NotificationView({super.key});
  @override
  State<NotificationView> createState() => _NotificationViewState();
}
class _NotificationViewState extends State<NotificationView> {
  int _subFilterIndex = 0;
  final List<Map<String, dynamic>> notifications = [
    {"title": "Informasi Nutrisi", "status": "Cember Nutrisi Kosong"},
    {"title": "System Error", "status": "Pompa kolam rusak"},
    {"title": "Informasi Nutrisi", "status": "Cember Nutrisi Kosong"},
    {"title": "System Error", "status": "Pompa kolam rusak"},
    {"title": "System Error", "status": "Pompa kolam rusak"},
    {"title": "Informasi Nutrisi", "status": "Cember Nutrisi Kosong"},
  ];
  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListItem(
                  title: item['title']!,
                  date: "27/10/2025",
                  statusText: item['status']!,
                  isStatusActive: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
