import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/widget/dashboard/dashboardbanner.dart';
import 'package:rivu_v1/widget/dashboard/weathercard.dart';
import 'package:rivu_v1/widget/systemstatusbanner.dart';
import 'package:rivu_v1/widget/infocard.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              DashboardHeader(userName: "Saipul Teams"),
              Positioned(
                top: 160, 
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: WeatherCard(),
                ),
              ),
            ],
          ),
          SizedBox(height: 110), 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SystemStatusBanner(judul: "Status System",text: "Semua System Normal",color: AppColors.primary),
                SizedBox(height: 24),
                _buildSectionTitle("Informasi Greenhouse"),
                Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        icon: Icons.water_drop_outlined,
                        iconColor: Colors.blue.shade600,
                        title: "pH Kolam",
                        value: "7,5",
                        unit: "",
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: InfoCard(
                        icon: Icons.waves_outlined,
                        iconColor: Colors.green.shade600,
                        title: "TDS Kolam",
                        value: "750",
                        unit: "ppm",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: InfoCard(
                    icon: Icons.eco_outlined,
                    iconColor: Colors.teal.shade600,
                    title: "TDS Nutrisi Tanaman",
                    value: "690",
                    unit: "ppm",
                  ),
                ),
                SizedBox(height: 24),
  
              ],
            ),
          ),
        ],
      ),
    );
  }
}
