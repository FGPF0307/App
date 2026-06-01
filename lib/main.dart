import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:greengymapp/Pages/LandingPage1.dart';
// import 'package:greengymapp/Pages/profilePage.dart'; Hanya testing saja

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const GreenGymApp(),
  ),
);

class GreenGymApp extends StatelessWidget {
  const GreenGymApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Konfigurasi wajib Device Preview
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFE1DCD3)),
      home: const OnboardingScreen(),
    );
  }
}
