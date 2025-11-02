import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rivu_v1/onboarding.dart'; 

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double logoSizeFraction = 0.4; 

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<Offset> _text1SlideAnimation;
  late Animation<double> _text1OpacityAnimation;
  late Animation<double> _text2OpacityAnimation;

  late List<Animation<Offset>> _bubbleMoves;
  late List<Animation<double>> _bubbleOpacities;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 4000, 
      ),
    );

    _bubbleMoves = [];
    _bubbleOpacities = [];
    const int bubbleCount = 7;
    final List<double> startTimes = [0.0, 0.1, 0.2, 0.3, 0.05, 0.15, 0.25];
    final List<double> durations = [0.6, 0.7, 0.5, 0.7, 0.65, 0.55, 0.75];

    final List<Curve> curves = [
      Curves.linear,
      Curves.easeIn,
      Curves.easeOut,
      Curves.linear,
      Curves.easeIn,
      Curves.easeOut,
      Curves.linear,
    ];

    for (int i = 0; i < bubbleCount; i++) {
      // 1. Animasi Gerakan (dari bawah ke atas)
      _bubbleMoves.add(
        Tween<Offset>(
          begin: const Offset(0, 1.5), // Mulai dari 1.5x tinggi layar di bawah
          end: const Offset(0, -1.5), // Selesai 1.5x tinggi layar di atas
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              startTimes[i],
              startTimes[i] + durations[i],
              curve: curves[i],
            ),
          ),
        ),
      );

      // 2. Animasi Opacity (Fade in lalu fade out)
      _bubbleOpacities.add(
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(begin: 0.0, end: 0.7),
            weight: 30,
          ), // Fade in
          TweenSequenceItem(
            tween: Tween(begin: 0.7, end: 0.7),
            weight: 40,
          ), // Tahan
          TweenSequenceItem(
            tween: Tween(begin: 0.7, end: 0.0),
            weight: 30,
          ), // Fade out
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              startTimes[i],
              startTimes[i] + durations[i],
              curve: Curves.linear,
            ),
          ),
        ),
      );
    }

    // --- FASE 2: Inisialisasi Logo & Teks (Mulai 1.6s) ---
    const double logoStartTime = 0.4; // Mulai di 1.6 detik (0.4 * 4000ms)

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          logoStartTime,
          logoStartTime + 0.3,
          curve: Curves.easeOutBack,
        ), // Efek "pop"
      ),
    );
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          logoStartTime,
          logoStartTime + 0.2,
          curve: Curves.linear,
        ),
      ),
    );

    // Teks 1 (Mulai 2.0s)
    _text1SlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              logoStartTime + 0.1,
              logoStartTime + 0.4,
              curve: Curves.easeOutCubic,
            ),
          ),
        );
    _text1OpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          logoStartTime + 0.1,
          logoStartTime + 0.4,
          curve: Curves.easeIn,
        ),
      ),
    );

    // Teks 2 (Mulai 2.4s)
    _text2OpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          logoStartTime + 0.2,
          logoStartTime + 0.5,
          curve: Curves.easeIn,
        ),
      ),
    );

    // Mulai semua animasi
    _controller.forward();

    // --- FASE 3: Navigasi ---
    // Navigasi setelah animasi 4s + jeda 0.5s = 4.5 detik
    Timer(const Duration(milliseconds: 4500), () {
      if (!mounted) return; // Pastikan widget masih ada
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500), // Fade 0.5s
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Onboarding(),
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
        color: Colors.blue.withOpacity(0.3), // Sedikit lebih gelap
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize =
        MediaQuery.of(context).size.width * logoSizeFraction;

    return Scaffold(
      backgroundColor: Colors.white, // Sesuai desain Anda
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // --- Render Gelembung (FASE 1) ---
              // Kita posisikan 7 gelembung di lokasi 'left'/'right' yang berbeda
              _buildAnimatedBubble(0, left: 30, size: 25),
              _buildAnimatedBubble(1, left: 100, size: 40),
              _buildAnimatedBubble(2, right: 40, size: 30),
              _buildAnimatedBubble(3, right: 120, size: 20),
              _buildAnimatedBubble(4, left: 60, size: 35),
              _buildAnimatedBubble(5, right: 80, size: 25),
              _buildAnimatedBubble(6, left: 150, size: 30),

              // --- Render Logo & Teks (FASE 2) ---
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- BAGIAN LOGO GRAFIK ---
                    ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: Opacity(
                        opacity: _logoOpacityAnimation.value,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: logoSize,
                          height: logoSize,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SlideTransition(
                      position: _text1SlideAnimation,
                      child: FadeTransition(
                        opacity: _text1OpacityAnimation,
                        child: const Text(
                          "RIVU",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
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
                          color: Color(0xFF388E3C),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper widget untuk merender gelembung yang sudah dianimasi
  Widget _buildAnimatedBubble(
    int index, {
    double? left,
    double? right,
    required double size,
  }) {
    return Positioned(
      left: left,
      right: right,
      // 'bottom' tidak diatur agar SlideTransition bisa mengontrol posisi vertikal
      child: SlideTransition(
        position: _bubbleMoves[index],
        child: FadeTransition(
          opacity: _bubbleOpacities[index],
          child: _buildBubble(size),
        ),
      ),
    );
  }
}
