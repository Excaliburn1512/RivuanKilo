import 'package:flutter/material.dart';
import 'package:rivu_v1/auth/view/auth_gate.dart';
import 'dart:async';
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
      _bubbleMoves.add(
        Tween<Offset>(
          begin: const Offset(0, 1.5), 
          end: const Offset(0, -1.5), 
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
      _bubbleOpacities.add(
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(begin: 0.0, end: 0.7),
            weight: 30,
          ), 
          TweenSequenceItem(
            tween: Tween(begin: 0.7, end: 0.7),
            weight: 40,
          ), 
          TweenSequenceItem(
            tween: Tween(begin: 0.7, end: 0.0),
            weight: 30,
          ), 
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
    const double logoStartTime = 0.4; 
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          logoStartTime,
          logoStartTime + 0.3,
          curve: Curves.easeOutBack,
        ), 
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
    _controller.forward();
    Timer(const Duration(milliseconds: 4500), () {
      if (!mounted) return; 
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500), 
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AuthGate(),
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
  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3), 
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
      backgroundColor: Colors.white, 
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildAnimatedBubble(0, left: 30, size: 25),
              _buildAnimatedBubble(1, left: 100, size: 40),
              _buildAnimatedBubble(2, right: 40, size: 30),
              _buildAnimatedBubble(3, right: 120, size: 20),
              _buildAnimatedBubble(4, left: 60, size: 35),
              _buildAnimatedBubble(5, right: 80, size: 25),
              _buildAnimatedBubble(6, left: 150, size: 30),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
  Widget _buildAnimatedBubble(
    int index, {
    double? left,
    double? right,
    required double size,
  }) {
    return Positioned(
      left: left,
      right: right,
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
