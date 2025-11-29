import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rivu_v1/auth/controller/auth_controller.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/core/services/weather_service.dart';
import 'package:rivu_v1/widget/dashboard/dashboardbanner.dart';
import 'package:rivu_v1/widget/dashboard/weathercard.dart';
import 'package:rivu_v1/widget/systemstatusbanner.dart';
import 'package:rivu_v1/widget/infocard.dart';

class Dashboard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final userName = authState.valueOrNull?.user?.displayName ?? "User";
    final weatherAsync = ref.watch(weatherFutureProvider);
    String currentCondition = "Clear";
    if (weatherAsync.hasValue) {
      currentCondition = weatherAsync.value!.weather.first.main;
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              DashboardHeader(userName: userName),
              Positioned(
                top: 160,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: weatherAsync.when(
                    data: (weather) => WeatherCard(
                      temp: "${weather.main.temp.toStringAsFixed(0)}°c",
                      location: weather.name,
                      condition: weather.weather.first.main,
                    ),
                    loading: () => const WeatherCard(
                      temp: "--",
                      location: "Sedang memuat...",
                      condition: "Clear",
                    ),
                    error: (err, stack) => const WeatherCard(
                      temp: "-",
                      location: "Gagal memuat",
                      condition: "Storm",
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SystemStatusBanner(
                  judul: "Status System",
                  text: "Semua System Normal",
                  color: AppColors.primary,
                ),
                SizedBox(height: 24),
                _buildSectionTitle("Perangkat Terhubung"),
                if (authState.valueOrNull?.systems?.isNotEmpty ?? false)
                  ...authState.value!.systems!.map(
                    (system) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: SystemStatusBanner(
                        judul: system.systemName,
                        text:
                            "ID: ${system.systemId.toString().substring(0, 25)}...",
                        ficon: Icons.developer_board,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                else
                  SystemStatusBanner(
                    judul: "Tidak Ada Perangkat",
                    text: "Silakan tambahkan perangkat baru",
                    ficon: Icons.link_off,
                    ricon: Icons.add,
                    color: Colors.grey,
                  ),
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
