import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart'; 
class ProfileActionButton extends StatelessWidget {
  final String text;
  final bool isFilled;
  final VoidCallback onPressed;
  const ProfileActionButton({
    Key? key,
    required this.text,
    required this.isFilled,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled ? AppColors.primary : Colors.white, 
          foregroundColor: isFilled ? Colors.white : Colors.black87,
          elevation: 0,
          side: BorderSide(
            color: isFilled ? AppColors.primary : Colors.grey.shade300, 
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
