import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';

/// Data satu komunitas / grup chat olahraga.
class CommunityData {
  final String title;
  final String members;
  final String location;
  final String lastMessage;
  final String imageUrl; // URL http(s) ATAU path file lokal (hasil pick gallery)

  const CommunityData({
    required this.title,
    this.members = '1 Member',
    this.location = '',
    this.lastMessage = '',
    required this.imageUrl,
  });

  bool get isNetwork =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
}

/// State terpusat daftar komunitas. Saat user join sebuah sesi, grup chatnya
/// otomatis bertambah di sini dan semua halaman yang mendengarkan ikut update.
class CommunityStore extends ChangeNotifier {
  CommunityStore._();
  static final CommunityStore instance = CommunityStore._();

  final List<CommunityData> _communities = [
    const CommunityData(
      title: 'BASKET SWEAT CLUB',
      members: '20 Members',
      location: 'Sutera Sports Center',
      lastMessage: '“where are you guys right now??....”',
      imageUrl:
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=200',
    ),
    const CommunityData(
      title: 'RUNNER CLUB',
      members: '20 Members',
      location: 'Flavor Bliss Alam Sutera',
      lastMessage: '“Are we going to run right now??....”',
      imageUrl:
          'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=200',
    ),
  ];

  List<CommunityData> get communities => List.unmodifiable(_communities);

  bool exists(String title) => _communities.any((c) => c.title == title);

  void add(CommunityData c) {
    if (exists(c.title)) return;
    _communities.insert(0, c);
    notifyListeners();
  }

  /// Dipanggil saat user join sebuah sesi — grup chatnya otomatis muncul
  /// di daftar Sport Communities yang sudah di-join.
  void addFromSession(SessionData s) {
    if (exists(s.title)) return;
    _communities.insert(
      0,
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
    notifyListeners();
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
