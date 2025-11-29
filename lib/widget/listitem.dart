import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String date;
  final String statusText;
  final bool? isStatusActive;

  const ListItem({
    Key? key,
    required this.title,
    required this.date,
    required this.statusText,
    this.isStatusActive,
  }) : super(key: key);

  Color _getStatusColor() {
    if (isStatusActive == true) {
      return AppColors.primary;
    } else if (isStatusActive == false) {
      return AppColors.errortext;
    } else {
      return Colors.grey[600]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- BAGIAN YANG DIPERBAIKI ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align ke atas jika teks panjang
            children: [
              // 1. Bungkus Judul dengan Expanded agar teks panjang otomatis turun (wrap)
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(
                width: 8,
              ), // Beri jarak sedikit antara judul dan tanggal
              // 2. Tanggal tetap di kanan (ukurannya menyesuaikan konten)
              Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),

          // --- AKHIR PERBAIKAN ---
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Status: ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Expanded(
                child: Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: _getStatusColor(),
                    fontWeight: isStatusActive != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
