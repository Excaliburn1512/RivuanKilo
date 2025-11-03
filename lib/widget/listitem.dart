import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart'; //

class ListItem extends StatelessWidget {
  final String title;
  final String date;
  final String statusText;
  final bool? isStatusActive; 

  const ListItem({
    Key? key,
    required this.title,
    required this.date,
    required this.statusText,
    this.isStatusActive,
  }) : super(key: key);

  Color _getStatusColor() {
    if (isStatusActive == true) {
      return AppColors.primary; 
    } else if (isStatusActive == false) {
      return AppColors.errortext;
    } else {
      return Colors.grey[600]!; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 12.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          
          // Baris 2: Status
          Row(
            children: [
              Text(
                "Status: ",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Expanded(
                child: Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: _getStatusColor(),
                    fontWeight: isStatusActive != null ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
