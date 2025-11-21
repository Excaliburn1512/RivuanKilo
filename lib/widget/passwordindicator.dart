import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
enum PasswordStrength { Weak, Medium, Strong }
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  const PasswordStrengthIndicator({Key? key, required this.password})
    : super(key: key);
  PasswordStrength _checkStrength(String pass) {
    if (pass.isEmpty) {
      return PasswordStrength.Weak;
    }
    bool hasUppercase = pass.contains(RegExp(r'[A-Z]'));
    bool hasDigits = pass.contains(RegExp(r'[0-9]'));
    bool hasSpecial = pass.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    int length = pass.length;
    if (length >= 8 && hasUppercase && hasDigits && hasSpecial) {
      return PasswordStrength.Strong;
    } else if (length >= 6 && (hasUppercase || hasDigits || hasSpecial)) {
      return PasswordStrength.Medium;
    } else {
      return PasswordStrength.Weak;
    }
  }
  @override
  Widget build(BuildContext context) {
    final strength = _checkStrength(password);
    String strengthText;
    Color weakColor, mediumColor, strongColor;
    switch (strength) {
      case PasswordStrength.Weak:
        strengthText = "Lemah";
        weakColor = Colors.red[700]!;
        mediumColor = Colors.white.withOpacity(0.2);
        strongColor = Colors.white.withOpacity(0.2);
        break;
      case PasswordStrength.Medium:
        strengthText = "Sedang";
        weakColor = Colors.orange[700]!;
        mediumColor = Colors.orange[700]!;
        strongColor = Colors.white.withOpacity(0.2);
        break;
      case PasswordStrength.Strong:
        strengthText = "Kuat";
        weakColor = Colors.green[700]!;
        mediumColor = Colors.green[700]!;
        strongColor = Colors.green[700]!;
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildIndicatorBar(weakColor)),
            SizedBox(width: 4),
            Expanded(child: _buildIndicatorBar(mediumColor)),
            SizedBox(width: 4),
            Expanded(child: _buildIndicatorBar(strongColor)),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "Kekuatan Sandi: $strengthText",
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  Widget _buildIndicatorBar(Color color) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
