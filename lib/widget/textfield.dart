import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? label;
  final IconData? icon;
  final Color? wlabel;
  final TextEditingController controller;
  final bool obscureText;
  const CustomTextField({
    Key? key,
    required this.hintText,
    this.label,
    this.icon,
    this.wlabel,
    required this.controller,
    this.obscureText = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!, 
            style: GoogleFonts.poppins(
              color: wlabel ?? Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (label != null) const SizedBox(height: 1),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
