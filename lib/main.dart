import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:greengymapp/Pages/LandingPages/LandingPage1.dart';
import 'package:greengymapp/Pages/MapPages/MainMapPage.dart';
import 'package:greengymapp/Pages/SignUpandSignInPage/signuppage.dart';
import 'package:greengymapp/Pages/SessionPages/SessionPage1.dart';


//mennyambungkan flutter dengan supabase
Future<void> main() async {
  await Supabase.initialize(
   url: 'https://lloibeyejbqfqklnimtn.supabase.co',
   anonKey: 'sb_publishable_G_JJnPpVrhbZBaQ-qCHsTA_15DSqqRv',
 );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, 
      builder: (context) => const GreenGymApp(), 
    ),
  );
}

class GreenGymApp extends StatelessWidget {
  const GreenGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Konfigurasi wajib Device Preview
      useInheritedMediaQuery: true, 
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE1DCD3), 
      ),
      home: const SessionPage(), 
    );
  }
}