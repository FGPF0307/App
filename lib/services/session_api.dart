import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitarena/Pages/SessionPages/session_models.dart';
import 'package:fitarena/services/api_config.dart';

/// Layanan untuk mengonsumsi REST API FitArena (backend Express).
/// Pastikan backend berjalan: `cd backend && npm run dev`.
class SessionApi {
  static String get baseUrl => apiBaseUrl;
  static const Duration _timeout = apiTimeout;

  /// READ — ambil semua sesi.
  static Future<List<SessionData>> fetchSessions() async {
    final res = await http
        .get(Uri.parse('$baseUrl/api/sessions'))
        .timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat sesi (HTTP ${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (body['data'] as List).cast<Map<String, dynamic>>();
    return list.map(SessionData.fromJson).toList();
  }

  /// CREATE — buat sesi baru (dipakai saat Host Session).
  static Future<SessionData> createSession(SessionData session) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/api/sessions'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(session.toJson()),
        )
        .timeout(_timeout);
    if (res.statusCode != 201) {
      throw Exception('Gagal membuat sesi (HTTP ${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return SessionData.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// UPDATE — join sesi (spotsFilled + 1).
  static Future<SessionData> joinSession(String id) async {
    final res = await http
        .post(Uri.parse('$baseUrl/api/sessions/$id/join'))
        .timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal join sesi (HTTP ${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return SessionData.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// DELETE — hapus sesi.
  static Future<void> deleteSession(String id) async {
    final res = await http
        .delete(Uri.parse('$baseUrl/api/sessions/$id'))
        .timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus sesi (HTTP ${res.statusCode})');
    }
  }
}
