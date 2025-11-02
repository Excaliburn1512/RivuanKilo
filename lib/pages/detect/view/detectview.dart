import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/colors.dart';

import 'package:rivu_v1/widget/detect/detecttogglebar.dart';
import 'package:rivu_v1/widget/detect/weekdayselector.dart';
import 'package:rivu_v1/widget/infocard.dart';
import 'package:rivu_v1/widget/systemstatusbanner.dart';
import 'package:rivu_v1/widget/detect/livecameraview.dart';
import 'package:rivu_v1/widget/detect/plantgriditem.dart';

class DetectPage extends StatefulWidget {
  const DetectPage({super.key});

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  bool _isTanamanView = true;

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
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
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          DetectToggleBar(
            isTanamanView: _isTanamanView,
            onTanamanPressed: () {
              setState(() {
                _isTanamanView = true;
              });
            },
            onKolamPressed: () {
              setState(() {
                _isTanamanView = false;
              });
            },
          ),
          SizedBox(height: 10),
          WeekDaySelector(),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _isTanamanView
                ? _buildTanamanView()
                : _buildKolamView(), 
          ),
        ],
      ),
    );
  }

  Widget _buildTanamanView() {
    return Column(
      key: ValueKey('tanaman'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Baris 1"),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => PlantGridItem(),
        ),
        _buildSectionTitle("Baris 2"),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => PlantGridItem(),
        ),
        _buildSectionTitle("Informasi sensor"),
        Row(
          children: [
            Expanded(
              child: InfoCard(
                icon: Icons.thermostat,
                iconColor: Colors.red.shade400,
                title: "Suhu Udara",
                value: "28",
                unit: "°C",
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: InfoCard(
                icon: Icons.water_drop_outlined,
                iconColor: Colors.blue.shade400,
                title: "TDS",
                value: "950",
                unit: "ppm",
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        InfoCard(
          icon: Icons.height,
          iconColor: Colors.green.shade600,
          title: "Permukaan Nutrisi",
          value: "5",
          unit: "cm",
        ),
        _buildSectionTitle("Status Sensor"),
        SystemStatusBanner(
          judul: "Status Pompa Nutrisi",
          ficon: Icons.local_drink, 
          ricon: Icons.check_circle,
          text: "Aktif",
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildKolamView() {
    return Column(
      key: ValueKey('kolam'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Live Kamera"),
        LiveCameraView(),
        _buildSectionTitle("Informasi sensor"),
        Row(
          children: [
            Expanded(
              child: InfoCard(
                icon: Icons.thermostat,
                iconColor: Colors.red.shade400,
                title: "Suhu Air",
                value: "28",
                unit: "°C",
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: InfoCard(
                icon: Icons.water_drop_outlined,
                iconColor: Colors.blue.shade400,
                title: "TDS",
                value: "950",
                unit: "ppm",
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InfoCard(
                icon: Icons.science_outlined,
                iconColor: Colors.purple.shade400,
                title: "pH Kolam",
                value: "7,5",
                unit: "",
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: InfoCard(
                icon: Icons.height,
                iconColor: Colors.green.shade600,
                title: "Permukaan Kolam ",
                value: "5",
                unit: "cm",
              ),
            ),
          ],
        ),
        _buildSectionTitle("Status Sensor"),
        SystemStatusBanner(
          judul: "Status Pompa Kolam",
          text: "Aktif",
          color: AppColors.primary,
          ficon: Icons.water, 
          ricon: Icons.check_circle,
        ),
      ],
    );
  }
}
