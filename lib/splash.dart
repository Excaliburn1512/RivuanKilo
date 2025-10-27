import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:async';
import 'package:rivu_v1/dashboard/view/dashboard.dart'; // Pastikan path ini benar

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Animasi untuk Grafik Logo (Ikan/Daun)
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  // Animasi untuk Teks "RIVULET"
  late Animation<Offset> _text1SlideAnimation;
  late Animation<double> _text1OpacityAnimation;

  // Animasi untuk Teks "AQUAPONICS MONITORING"
  late Animation<double> _text2OpacityAnimation;

  // Animasi untuk Gelembung
  late Animation<Offset> _bubble1Move;
  late Animation<double> _bubble1Opacity;
  late Animation<Offset> _bubble2Move;
  late Animation<double> _bubble2Opacity;
  late Animation<Offset> _bubble3Move;
  late Animation<double> _bubble3Opacity;

  @override
  void initState() {
    super.initState();
    // Hapus native splash screen bawaan
    FlutterNativeSplash.remove();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2500,
      ), // Durasi total animasi 2.5 detik
    );

    // 1. Animasi Logo (0s - 1.2s)
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.easeOutBack,
        ), // Efek "pop"
      ),
    );
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.linear),
      ),
    );

    // 2. Animasi Teks "RIVULET" (0.8s - 1.5s)
    _text1SlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
          ),
        );
    _text1OpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    // 3. Animasi Teks "AQUAPONICS..." (1.2s - 2.0s)
    _text2OpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
      ),
    );

    // 4. Animasi Gelembung (muncul bertahap setelah logo)
    // Gelembung Besar
    _bubble1Move = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -25))
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.9, curve: Curves.easeOutSine),
          ),
        );
    _bubble1Opacity = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
    // Gelembung Sedang
    _bubble2Move = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -20))
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOutSine),
          ),
        );
    _bubble2Opacity = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );
    // Gelembung Kecil
    _bubble3Move = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -15))
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOutSine),
          ),
        );
    _bubble3Opacity = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.easeIn),
      ),
    );

    // Mulai semua animasi
    _controller.forward();

    // Navigasi setelah animasi selesai
    Timer(const Duration(milliseconds: 3000), () {
      // Beri jeda 0.5s setelah animasi
      if (!mounted) return; // Pastikan widget masih ada
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Dashboard(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper widget untuk membuat gelembung
  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.15), // Warna gelembung transparan
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ukuran logo relatif terhadap lebar layar
    final double logoSize = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      backgroundColor: Colors.white, // Sesuai desain Anda
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- BAGIAN LOGO GRAFIK + GELEMBUNG ---
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Gambar logo statis (ikan, daun, gelembung statis)
                        Image.asset(
                          'assets/images/logo_graphic.png', // ASET PENTING ANDA
                          width: logoSize,
                          height: logoSize,
                        ),

                        // --- Gelembung Animasi (Overlay) ---
                        // Kita posisikan gelembung baru ini di atas gelembung statis
                        // Sesuaikan nilai 'bottom' dan 'right' agar pas dengan logo Anda

                        // Gelembung Besar (kira-kira di kiri atas gelembung lain)
                        Positioned(
                          bottom: logoSize * 0.28, // 28% dari bawah tumpukan
                          right: logoSize * 0.35, // 35% dari kanan tumpukan
                          child: SlideTransition(
                            position: _bubble1Move,
                            child: Opacity(
                              opacity: _bubble1Opacity.value,
                              child: _buildBubble(
                                logoSize * 0.12,
                              ), // 12% dari ukuran logo
                            ),
                          ),
                        ),
                        // Gelembung Sedang (di tengah)
                        Positioned(
                          bottom: logoSize * 0.2, // 20% dari bawah
                          right: logoSize * 0.28, // 28% dari kanan
                          child: SlideTransition(
                            position: _bubble2Move,
                            child: Opacity(
                              opacity: _bubble2Opacity.value,
                              child: _buildBubble(
                                logoSize * 0.09,
                              ), // 9% dari ukuran logo
                            ),
                          ),
                        ),
                        // Gelembung Kecil (kanan bawah)
                        Positioned(
                          bottom: logoSize * 0.12, // 12% dari bawah
                          right: logoSize * 0.25, // 25% dari kanan
                          child: SlideTransition(
                            position: _bubble3Move,
                            child: Opacity(
                              opacity: _bubble3Opacity.value,
                              child: _buildBubble(
                                logoSize * 0.06,
                              ), // 6% dari ukuran logo
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- BAGIAN TEKS "RIVULET" ---
                SlideTransition(
                  position: _text1SlideAnimation,
                  child: FadeTransition(
                    opacity: _text1OpacityAnimation,
                    child: const Text(
                      "RIVULET",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50), // Biru gelap (sesuaikan)
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // --- BAGIAN TEKS "AQUAPONICS MONITORING" ---
                FadeTransition(
                  opacity: _text2OpacityAnimation,
                  child: const Text(
                    "AQUAPONICS MONITORING",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF388E3C), // Hijau (sesuaikan)
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
