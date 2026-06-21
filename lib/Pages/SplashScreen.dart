import 'package:flutter/material.dart';
import 'package:fitarena/widgets/fitarena_logo.dart';
import 'package:fitarena/Pages/LandingPages/LandingPage1.dart';

/// Splash screen yang tampil saat app dibuka. Pindah ke Landing Page 1
/// saat layar di-tap (bukan otomatis).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FitArenaLogo(size: 200),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: const Text(
                      'FIT ARENA',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 46,
                        letterSpacing: 1.0,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Petunjuk untuk tap
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Text(
                  'Tap anywhere to continue',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    letterSpacing: 0.5,
                    color: Colors.black.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
