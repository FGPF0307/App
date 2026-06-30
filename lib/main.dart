import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitarena/Pages/splash_screen.dart';

// Menyambungkan Flutter dengan Supabase.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lloibeyejbqfqklnimtn.supabase.co',
    publishableKey: 'sb_publishable_G_JJnPpVrhbZBaQ-qCHsTA_15DSqqRv',
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const FitArenaApp(),
    ),
  );
}

class FitArenaApp extends StatelessWidget {
  const FitArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Konfigurasi Device Preview (aktif hanya saat debug).
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'FitArena',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFE1DCD3),
      ),
      home: const SplashScreen(),
    );
  }
}
