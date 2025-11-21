
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;
  final bool isObscure;
  const ProfileInfoField({
    Key? key,
    required this.label,
    required this.value,
    this.isObscure = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true, 
          obscureText: isObscure,
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            suffixIcon: isObscure
                ? Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.grey[500],
                    size: 20,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
