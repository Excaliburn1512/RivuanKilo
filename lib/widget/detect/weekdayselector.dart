import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekDaySelector extends StatefulWidget {
  const WeekDaySelector({Key? key}) : super(key: key);

  @override
  _WeekDaySelectorState createState() => _WeekDaySelectorState();
}

class _WeekDaySelectorState extends State<WeekDaySelector> {
  int _selectedDayIndex = 2; 

  final List<Map<String, String>> days = [
    {"day": "Mon", "date": "5"},
    {"day": "Tue", "date": "6"},
    {"day": "Wed", "date": "7"},
    {"day": "Thu", "date": "8"},
    {"day": "Fri", "date": "9"},
    {"day": "Sat", "date": "10"},
    {"day": "Sun", "date": "11"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(days.length, (index) {
          bool isSelected = _selectedDayIndex == index;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Column(
              children: [
                Text(
                  days[index]['day']!,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.black : Colors.grey[400],
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  days[index]['date']!,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.black : Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
