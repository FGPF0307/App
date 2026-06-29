import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fitarena/services/api_config.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';

/// Data satu komunitas / grup chat olahraga.
class CommunityData {
  final String? id;
  final String title;
  final String members;
  final String location;
  final String lastMessage;
  final String imageUrl; // URL http(s) ATAU path file lokal (hasil pick gallery)

  const CommunityData({
    this.id,
    required this.title,
    this.members = '1 Member',
    this.location = '',
    this.lastMessage = '',
    required this.imageUrl,
  });

  bool get isNetwork =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  factory CommunityData.fromJson(Map<String, dynamic> json) => CommunityData(
        id: json['id'] as String?,
        title: (json['title'] ?? '') as String,
        members: (json['members'] ?? '1 Member') as String,
        location: (json['location'] ?? '') as String,
        lastMessage: (json['lastMessage'] ?? '') as String,
        imageUrl: (json['imageUrl'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'members': members,
        'location': location,
        'lastMessage': lastMessage,
        'imageUrl': imageUrl,
      };
}

/// Store komunitas yang didukung REST API. Daftar diambil dari backend
/// (`GET /api/communities`); menambah komunitas mengirim `POST`. Tetap
/// `ChangeNotifier` agar UI (SocialHubPage & CommunitiesPage) reaktif.
class CommunityStore extends ChangeNotifier {
  CommunityStore._();
  static final CommunityStore instance = CommunityStore._();

  final List<CommunityData> _communities = [];
  bool _loaded = false;
  bool loading = false;
  String? error;

  List<CommunityData> get communities => List.unmodifiable(_communities);

  /// READ — muat daftar komunitas dari API (sekali, kecuali force).
  Future<void> load({bool force = false}) async {
    if (_loaded && !force) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final res = await http
          .get(Uri.parse('$apiBaseUrl/api/communities'))
          .timeout(apiTimeout);
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final list = (body['data'] as List)
          .cast<Map<String, dynamic>>()
          .map(CommunityData.fromJson)
          .toList();
      _communities
        ..clear()
        ..addAll(list);
      _loaded = true;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  bool exists(String title) => _communities.any((c) => c.title == title);

  /// CREATE — tambah komunitas (POST). Fallback ke lokal bila API gagal.
  Future<void> add(CommunityData c) async {
    if (exists(c.title)) return;
    CommunityData toInsert = c;
    try {
      final res = await http
          .post(
            Uri.parse('$apiBaseUrl/api/communities'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(c.toJson()),
          )
          .timeout(apiTimeout);
      if (res.statusCode == 201) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        toInsert = CommunityData.fromJson(body['data'] as Map<String, dynamic>);
      }
    } catch (_) {
      // Abaikan; pakai data lokal sebagai fallback.
    }
    _communities.insert(0, toInsert);
    notifyListeners();
  }

  /// Saat user join sesi — grup chatnya muncul di Sport Communities.
  Future<void> addFromSession(SessionData s) async {
    if (exists(s.title)) return;
    await add(
      CommunityData(
        title: s.title,
        members: '1 Member',
        location: s.location,
        lastMessage: '“You just joined! Say hi to the squad 👋”',
        imageUrl: s.isNetwork
            ? s.image
            : 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=200',
      ),
    );
  }
}

/// Helper menampilkan gambar komunitas (mendukung URL maupun file lokal).
Widget communityImage(
  String src, {
  double width = 44,
  double height = 44,
  BoxFit fit = BoxFit.cover,
}) {
  Widget fallback() => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.group, color: Colors.grey),
      );

  final isNet = src.startsWith('http://') || src.startsWith('https://');
  if (isNet) {
    return Image.network(src,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => fallback());
  }
  return Image.file(File(src),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => fallback());
}
