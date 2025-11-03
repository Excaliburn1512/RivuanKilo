import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart'; 

class SubFilterBar extends StatelessWidget {
  final int activeIndex;
  final Function(int) onFilterPressed;

  const SubFilterBar({
    Key? key,
    required this.activeIndex,
    required this.onFilterPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], 
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          _buildFilterItem("Semua", 0, activeIndex == 0),
          _buildFilterItem("Minggu", 1, activeIndex == 1),
          _buildFilterItem("Bulan", 2, activeIndex == 2),
        ],
      ),
    );
  }

  Widget _buildFilterItem(String title, int index, bool isActive) {
    return Expanded(
      child: InkWell(
        onTap: () => onFilterPressed(index),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent, 
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isActive ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
