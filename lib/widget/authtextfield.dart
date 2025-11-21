import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Authtextfield extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final Function(String)? onChanged;
  const Authtextfield({
    super.key,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    required this.controller,
    this.onChanged,
  });
  @override
  State<Authtextfield> createState() => _AuthtextfieldState();
}
class _AuthtextfieldState extends State<Authtextfield> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscure : false,
      onChanged: widget.onChanged,
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        prefixIcon: Icon(widget.icon, color: Colors.white70),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
