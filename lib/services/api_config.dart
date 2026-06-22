import 'package:flutter/foundation.dart';

/// Base URL backend, menyesuaikan target run.
/// - Web / Windows / iOS sim: localhost
/// - Android emulator: 10.0.2.2 (alias localhost host)
String get apiBaseUrl {
  if (kIsWeb) return 'http://localhost:3000';
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000';
  }
  return 'http://localhost:3000';
}

const Duration apiTimeout = Duration(seconds: 10);
