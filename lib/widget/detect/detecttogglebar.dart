import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart'; //

class DetectToggleBar extends StatelessWidget {
  final bool isTanamanView;
  final VoidCallback onTanamanPressed;
  final VoidCallback onKolamPressed;

  const DetectToggleBar({
    Key? key,
    required this.isTanamanView,
    required this.onTanamanPressed,
    required this.onKolamPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
      child: Row(
        children: [
          _buildToggleItem("Tanaman", isTanamanView, onTanamanPressed),
          _buildToggleItem("Kolam", !isTanamanView, onKolamPressed),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, bool isActive, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(6.0),
        child: InkWell(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.white, //
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isActive ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
