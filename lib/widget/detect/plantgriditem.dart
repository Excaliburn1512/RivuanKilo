import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/models/plant_image_model.dart';
import 'package:rivu_v1/colors.dart';

class PlantGridItem extends StatelessWidget {
  final PlantImageModel? data;

  const PlantGridItem({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      // Tampilan jika slot kosong (belum ada foto)
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
        ),
      );
    }

    // Logika warna berdasarkan diagnosa
    final isHealthy = data!.diagnosisResult?.contains("Sehat") ?? false;
    final statusColor = isHealthy ? AppColors.primary : Colors.red;
    final statusText = data!.diagnosisResult ?? "Memproses...";

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Gambar Tanaman
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            data!.fullImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.grey),
                    SizedBox(height: 4),
                    Text("Gagal muat", style: TextStyle(fontSize: 10)),
                  ],
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),

        // 2. Overlay Gradient untuk teks agar terbaca
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),
        ),

        // 3. Badge Status Diagnosa
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (data!.diagnosisConfidence != null)
                Text(
                  "${(data!.diagnosisConfidence! * 100).toStringAsFixed(0)}%",
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 9,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
