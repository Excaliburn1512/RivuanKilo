import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/models/plant_image_model.dart';
import 'package:intl/intl.dart';

class PlantDetailDialog extends StatelessWidget {
  final PlantImageModel data;

  const PlantDetailDialog({Key? key, required this.data}) : super(key: key);

  // Helper untuk mendapatkan deskripsi berdasarkan hasil diagnosis
  String _getDescription(String result) {
    if (result.contains("-N") || result.contains("Nitrogen")) {
      return "Tanaman terdeteksi kekurangan Nitrogen. Gejala umum meliputi daun tua yang menguning (klorosis) mulai dari ujung daun merambat ke tulang daun. Pertumbuhan tanaman mungkin terhambat. \n\nSaran: Tambahkan nutrisi A/B Mix dengan kadar Nitrogen lebih tinggi atau cek sirkulasi air.";
    } else if (result.contains("-P") || result.contains("Fosfor")) {
      return "Tanaman terdeteksi kekurangan Fosfor. Gejala terlihat dari warna daun yang berubah menjadi hijau tua keunguan atau kemerahan, terutama pada bagian bawah daun. Perkembangan akar mungkin terganggu.\n\nSaran: Pastikan PH air stabil dan tambahkan unsur Fosfor.";
    } else if (result.contains("-K") || result.contains("Kalium")) {
      return "Tanaman terdeteksi kekurangan Kalium. Gejala terlihat seperti pinggiran daun menguning atau hangus (nekrosis), serta bercak-bercak pada daun. Batang tanaman mungkin menjadi lemah.\n\nSaran: Tambahkan suplemen Kalium pada larutan nutrisi.";
    } else if (result.contains("Sehat") || result.contains("Normal")) {
      return "Tanaman Anda terdeteksi dalam kondisi SEHAT dan tumbuh dengan baik. Tidak ditemukan tanda-tanda kekurangan nutrisi atau penyakit yang signifikan.\n\nSaran: Pertahankan parameter air (pH, TDS, Suhu) agar tetap stabil.";
    } else {
      return "Hasil deteksi: $result. \nSistem mendeteksi adanya anomali namun belum dapat dikategorikan secara spesifik. Harap periksa kondisi fisik tanaman secara langsung.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd MMMM yyyy, HH:mm',
    ).format(DateTime.parse(data.capturedAt).toLocal());

    // Tentukan warna badge berdasarkan hasil
    final isHealthy = data.diagnosisResult?.contains("Sehat") ?? false;
    final badgeColor = isHealthy ? AppColors.primary : AppColors.errortext;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Title ---
            Center(
              child: Text(
                "Detail",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Gambar Besar ---
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                data.fullImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      Text(
                        "Gagal memuat gambar",
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Badge Diagnosis ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                data.diagnosisResult ?? "Tidak Diketahui",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // --- Tanggal & Akurasi ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                if (data.diagnosisConfidence != null)
                  Text(
                    "Akurasi: ${(data.diagnosisConfidence! * 100).toStringAsFixed(1)}%",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // --- Deskripsi ---
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  _getDescription(data.diagnosisResult ?? ""),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Tombol Tutup ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Tutup",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
