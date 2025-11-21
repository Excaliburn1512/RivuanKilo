
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart';
class DeviceControlCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;
  final bool isActive;
  final ValueChanged<bool> onChanged;
  const DeviceControlCard({
    Key? key,
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            onChanged(!isActive); 
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      iconData,
                      color: isActive ? AppColors.primary : Colors.grey[700],
                      size: 28,
                    ),
                    Transform.scale(
                      scale: 0.8, 
                      child: Switch(
                        value: isActive,
                        onChanged: onChanged,
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
