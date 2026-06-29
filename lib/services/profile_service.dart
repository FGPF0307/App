import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Data profil pengguna yang tersimpan di tabel `profiles` Supabase.
class ProfileData {
  final String fullName;
  final String title;
  final int level;
  final int currentXp;
  final int xpToNext;
  final int pointsTotal;
  final int minutesTraining;
  final int currentStreak;
  final int sessionsCompleted;
  final String lastActiveDate; // 'YYYY-MM-DD' ('' jika belum pernah aktif)
  final List<String> badges;
  // Progres 6 badge (Badge Gallery)
  final int dynamicDuo;
  final int earlyBird;
  final int trendsetter;
  final int activeFollowers;
  final int locationsCount;
  // Onboarding
  final List<String> preferences;
  final bool onboarded;
  final String avatarUrl;

  const ProfileData({
    required this.fullName,
    required this.title,
    required this.level,
    required this.currentXp,
    required this.xpToNext,
    required this.pointsTotal,
    required this.minutesTraining,
    required this.currentStreak,
    required this.sessionsCompleted,
    required this.lastActiveDate,
    required this.badges,
    required this.dynamicDuo,
    required this.earlyBird,
    required this.trendsetter,
    required this.activeFollowers,
    required this.locationsCount,
    required this.preferences,
    required this.onboarded,
    required this.avatarUrl,
  });

  bool hasBadge(String key) => badges.contains(key);

  /// Streak "sebenarnya" saat ditampilkan: kalau aktivitas terakhir lebih lama
  /// dari kemarin (bolong), streak dianggap putus -> 0. Memakai tanggal LOKAL
  /// device, sehingga benar walau user sedang tidak melakukan aktivitas baru.
  int get effectiveStreak {
    if (lastActiveDate.isEmpty) return currentStreak == 0 ? 0 : currentStreak;
    final last = DateTime.tryParse(lastActiveDate);
    if (last == null) return currentStreak;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(last.year, last.month, last.day);
    final gap = today.difference(lastDay).inDays;
    // 0 = aktif hari ini, 1 = kemarin (masih nyambung), >1 = putus.
    return gap <= 1 ? currentStreak : 0;
  }

  /// Fraksi progress XP menuju level berikutnya (0.0 - 1.0).
  double get xpFraction {
    if (xpToNext <= 0) return 0;
    return (currentXp / xpToNext).clamp(0.0, 1.0);
  }

  factory ProfileData.fromMap(Map<String, dynamic> m) {
    int asInt(dynamic v, int fallback) =>
        v is int ? v : (v is num ? v.toInt() : fallback);
    return ProfileData(
      fullName: (m['full_name'] as String?)?.trim().isNotEmpty == true
          ? (m['full_name'] as String).trim()
          : 'ATHLETE',
      title: (m['title'] as String?) ?? 'ROOKIE',
      level: asInt(m['level'], 1),
      currentXp: asInt(m['current_xp'], 0),
      xpToNext: asInt(m['xp_to_next'], 1000),
      pointsTotal: asInt(m['points_total'], 0),
      minutesTraining: asInt(m['minutes_training'], 0),
      currentStreak: asInt(m['current_streak'], 0),
      sessionsCompleted: asInt(m['sessions_completed'], 0),
      lastActiveDate: (m['last_active_date'] as String?) ?? '',
      badges: (m['badges'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      dynamicDuo: asInt(m['bg_dynamic_duo'], 0),
      earlyBird: asInt(m['bg_early_bird'], 0),
      trendsetter: asInt(m['bg_trendsetter'], 0),
      activeFollowers: asInt(m['bg_active_followers'], 0),
      locationsCount: (m['bg_locations'] as List?)?.length ?? 0,
      preferences:
          (m['preferences'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
      onboarded: m['onboarded'] == true,
      avatarUrl: (m['avatar_url'] as String?) ?? '',
    );
  }

  /// Nilai default ketika profil belum tersedia (offline / tabel belum dibuat).
  factory ProfileData.fallback(String name) => ProfileData(
        fullName: name.trim().isEmpty ? 'ATHLETE' : name.trim(),
        title: 'ROOKIE',
        level: 1,
        currentXp: 0,
        xpToNext: 1000,
        pointsTotal: 0,
        minutesTraining: 0,
        currentStreak: 0,
        sessionsCompleted: 0,
        lastActiveDate: '',
        badges: const [],
        dynamicDuo: 0,
        earlyBird: 0,
        trendsetter: 0,
        activeFollowers: 0,
        locationsCount: 0,
        preferences: const [],
        onboarded: false,
        avatarUrl: '',
      );
}

/// Layanan profil pengguna berbasis Supabase (tabel `profiles`).
class ProfileService {
  static SupabaseClient get _client => Supabase.instance.client;

  static String get _metaName {
    final meta = _client.auth.currentUser?.userMetadata;
    final name = meta?['full_name'] as String?;
    return (name == null || name.trim().isEmpty) ? 'ATHLETE' : name.trim();
  }

  /// Ambil profil user yang sedang login. Jika gagal/baris belum ada,
  /// kembalikan nilai default agar UI tetap bisa tampil.
  static Future<ProfileData> fetchMyProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return ProfileData.fallback(_metaName);
    try {
      final row = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (row == null) return ProfileData.fallback(_metaName);
      return ProfileData.fromMap(row);
    } catch (_) {
      return ProfileData.fallback(_metaName);
    }
  }

  /// Ubah nama tampilan: disimpan ke tabel `profiles` sekaligus ke
  /// metadata akun Supabase agar konsisten.
  static Future<void> updateName(String name) async {
    final user = _client.auth.currentUser;
    final clean = name.trim();
    if (user == null || clean.isEmpty) return;
    await _client.from('profiles').update({'full_name': clean}).eq('id', user.id);
    await _client.auth.updateUser(UserAttributes(data: {'full_name': clean}));
  }

  /// Selesaikan onboarding: simpan nama + preferensi, tandai onboarded.
  static Future<void> completeOnboarding({
    required String name,
    required List<String> preferences,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    final clean = name.trim().isEmpty ? 'ATHLETE' : name.trim();
    await _client.from('profiles').update({
      'full_name': clean,
      'preferences': preferences,
      'onboarded': true,
    }).eq('id', user.id);
    await _client.auth.updateUser(UserAttributes(data: {'full_name': clean}));
  }

  /// Upload foto profil ke Storage (bucket `avatars`) lalu simpan URL-nya.
  /// `bytes` = isi file, `ext` = ekstensi (jpg/png). Cross-platform (web & mobile).
  static Future<void> uploadAvatar(Uint8List bytes, String ext) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    final safeExt = (ext.isEmpty ? 'jpg' : ext).toLowerCase();
    final path = '${user.id}.$safeExt';
    final contentType = safeExt == 'png' ? 'image/png' : 'image/jpeg';
    await _client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(upsert: true, contentType: contentType),
        );
    // Cache-busting agar foto baru langsung muncul (path-nya sama).
    final url = _client.storage.from('avatars').getPublicUrl(path);
    final busted = '$url?v=${DateTime.now().millisecondsSinceEpoch}';
    await _client.from('profiles').update({'avatar_url': busted}).eq('id', user.id);
  }
}

/// Sumber data profil reaktif (single source of truth). Halaman Home & Profile
/// mendengarkan store ini; panggil [refresh] setelah XP berubah agar UI
/// langsung ikut ter-update tanpa perlu buka ulang halaman.
class ProfileStore extends ChangeNotifier {
  ProfileStore._();
  static final ProfileStore instance = ProfileStore._();

  ProfileData _data = ProfileData.fallback('ATHLETE');
  ProfileData get data => _data;

  /// Ambil ulang profil terbaru dari Supabase lalu beritahu listener.
  Future<void> refresh() async {
    _data = await ProfileService.fetchMyProfile();
    notifyListeners();
  }

  /// Ubah nama lalu refresh.
  Future<void> updateName(String name) async {
    await ProfileService.updateName(name);
    await refresh();
  }

  /// Upload foto profil lalu refresh.
  Future<void> uploadAvatar(Uint8List bytes, String ext) async {
    await ProfileService.uploadAvatar(bytes, ext);
    await refresh();
  }
}
