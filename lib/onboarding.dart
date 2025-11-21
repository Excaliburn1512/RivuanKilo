import "package:flutter/material.dart";
import "package:rivu_v1/auth/view/auth_gate.dart";
class OnboardingPageData {
  final String title;
  final String description;
  OnboardingPageData({required this.title, required this.description});
}
class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  @override
  State<Onboarding> createState() => _OnboardingState();
}
class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: "Selamat Datang di Rivu",
      description:
          "Solusi all-in-one untuk memantau dan mengelola sistem akuaponik Anda dengan mudah.",
    ),
    OnboardingPageData(
      title: "Pantau Kualitas Air Real-Time",
      description:
          "Dapatkan data langsung tentang pH, suhu, dan amonia untuk menjaga ikan serta tanaman tetap sehat.",
    ),
    OnboardingPageData(
      title: "Notifikasi Instan",
      description:
          "Terima peringatan langsung di ponsel Anda jika ada parameter yang keluar dari batas normal.",
    ),
  ];
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == _pages.length - 1;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background/onboarding_background.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPageContent(_pages[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ).copyWith(bottom: 40.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: _currentPage > 0,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: const Text(
                            "Kembali",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      _buildPageIndicator(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (isLastPage) {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const AuthGate(),
                                transitionDuration: const Duration(
                                  milliseconds: 1500,
                                ),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      final curve = Curves.ease;
                                      final tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));
                                      final offsetAnimation = animation.drive(
                                        tween,
                                      );
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(30.0),
                                            topRight: Radius.circular(30.0),
                                          ),
                                          child: child,
                                        ),
                                      );
                                    },
                              ),
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                        child: Text(
                          isLastPage ? "Mulai Sekarang" : "Selanjutnya",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPageContent(OnboardingPageData page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
