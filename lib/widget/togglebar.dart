import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart'; 

class ToggleBar extends StatelessWidget {
  final bool isTanamanView;
  final VoidCallback? onTanamanPressed;
  final VoidCallback? onKolamPressed;
  final VoidCallback? onPompaPressed;
  final String title;

  const ToggleBar({
    Key? key,
    required this.isTanamanView,
    this.onTanamanPressed,
    this.onKolamPressed,
    this.onPompaPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
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
          if (title == "History") ...[
            _buildToggleItem("Tanaman", isTanamanView, onTanamanPressed!),
            _buildToggleItem("Pompa", !isTanamanView, onPompaPressed!),
          ] else ...[
            _buildToggleItem("Tanaman", isTanamanView, onTanamanPressed!),
            _buildToggleItem("Kolam", !isTanamanView, onKolamPressed!),
          ],
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
              borderRadius: BorderRadius.circular(20.0),
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
