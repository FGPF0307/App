import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitarena/services/api_config.dart';

/// Hasil pemberian XP dari backend.
class AwardResult {
  final int gainedXp;
  final bool leveledUp;
  final int level;
  final List<String> newBadges;

  const AwardResult({
    required this.gainedXp,
    required this.leveledUp,
    required this.level,
    required this.newBadges,
  });
}

/// Klien untuk endpoint XP/level di backend Express (`/api/profiles`).
/// Backend yang menghitung XP, level, dan badge lalu menyimpannya ke Supabase.
class XpApi {
  static String get _baseUrl => apiBaseUrl;
  static const Duration _timeout = apiTimeout;

  /// Tanggal lokal device 'YYYY-MM-DD' untuk perhitungan streak harian.
  static String _localToday() {
    final n = DateTime.now();
    final mm = n.month.toString().padLeft(2, '0');
    final dd = n.day.toString().padLeft(2, '0');
    return '${n.year}-$mm-$dd';
  }

  /// Jam mulai (0-23) dari string seperti "18.00" / "06:30". Null jika gagal.
  static int? parseStartHour(String startTime) {
    final m = RegExp(r'(\d{1,2})').firstMatch(startTime);
    if (m == null) return null;
    final h = int.tryParse(m.group(1)!);
    if (h == null || h < 0 || h > 23) return null;
    return h;
  }

  /// Menit dari string seperti "06.30" / "18:00". 0 jika tidak ada.
  static int parseStartMinute(String startTime) {
    final m = RegExp(r'\d{1,2}[.:](\d{2})').firstMatch(startTime);
    if (m == null) return 0;
    return int.tryParse(m.group(1)!) ?? 0;
  }

  /// Durasi menit dari "18.00"-"19.30" (best-effort, 0 jika gagal/negatif).
  static int durationMinutes(String startTime, String endTime) {
    int? toMin(String t) {
      final m = RegExp(r'(\d{1,2})[.:](\d{2})').firstMatch(t);
      if (m == null) return null;
      return int.parse(m.group(1)!) * 60 + int.parse(m.group(2)!);
    }

    final s = toMin(startTime);
    final e = toMin(endTime);
    if (s == null || e == null) return 0;
    final d = e - s;
    return d > 0 ? d : 0;
  }

  /// Kirim aksi ke backend untuk diberi XP. `action`: 'join' | 'host' | 'checkin'.
  /// Best-effort: mengembalikan null bila gagal (tidak menghentikan UX).
  static Future<AwardResult?> award({
    required String action,
    int? startHour,
    int startMinute = 0,
    int spotsFilled = 0,
    int spotsTotal = 0,
    String location = '',
    int rewardPoints = 0,
    int minutes = 0,
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final res = await http
          .post(
            Uri.parse('$_baseUrl/api/profiles/$userId/award'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'action': action,
              'startHour': ?startHour,
              'startMinute': startMinute,
              'spotsFilled': spotsFilled,
              'spotsTotal': spotsTotal,
              'location': location,
              'rewardPoints': rewardPoints,
              'minutes': minutes,
              'clientDate': _localToday(), // streak berbasis hari lokal user
            }),
          )
          .timeout(_timeout);
      if (res.statusCode != 200) return null;
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) return null;
      return AwardResult(
        gainedXp: (data['gainedXp'] as num?)?.toInt() ?? 0,
        leveledUp: data['leveledUp'] == true,
        level: (data['level'] as num?)?.toInt() ?? 1,
        newBadges:
            (data['newBadges'] as List?)?.map((e) => e.toString()).toList() ??
                const [],
      );
    } catch (_) {
      return null;
    }
  }
}
