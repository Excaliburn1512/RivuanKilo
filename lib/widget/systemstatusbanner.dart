import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart';

class SystemStatusBanner extends StatelessWidget {
  final String? judul;
  final IconData? ficon;
  final IconData? ricon;
  final String? text;
  final Color color;

  const SystemStatusBanner({
    Key? key,
    this.judul,
    this.ficon,
    this.ricon,
    this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [
          Icon(ficon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Text(
                  judul!,
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  text!,
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(ricon, color: AppColors.primary),
        ],
      ),
    );
  }
}
