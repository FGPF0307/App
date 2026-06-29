import 'package:flutter/material.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';
import 'package:fitarena/Pages/SocialPages/community_store.dart';
import 'package:fitarena/services/session_api.dart';
import 'package:fitarena/services/xp_api.dart';
import 'package:fitarena/services/profile_service.dart';

const Color _darkGreen = Color(0xFF043927);
const Color _brown = Color(0xFF9E6E38);

/// Alur join terpusat: simpan ke My Schedule, sinkron ke komunitas & backend,
/// beri XP, dan tampilkan snackbar. Dipakai oleh tombol "Secure My Spot"
/// (bottom sheet) maupun "Join This Session" (halaman detail).
///
/// Bagian sinkron (menyimpan ke My Schedule + snackbar) berjalan langsung,
/// sehingga pemanggil bisa langsung menutup halaman/sheet; pemberian XP
/// (jaringan) berjalan di belakang dan menampilkan snackbar saat selesai.
Future<void> performJoinFlow(BuildContext context, SessionData session) async {
  final messenger = ScaffoldMessenger.of(context);
  final already = SessionStore.instance.isJoined(session);

  // Simpan ke My Schedule (muncul di bawah daftar) + komunitas + backend.
  SessionStore.instance.join(session);
  CommunityStore.instance.addFromSession(session);
  final id = session.id;
  if (id != null) {
    SessionApi.joinSession(id).catchError((_) => session);
  }

  messenger.showSnackBar(
    SnackBar(
      backgroundColor: _darkGreen,
      content: Text(
        already
            ? 'Kamu sudah tergabung di sesi ini.'
            : 'Berhasil join "${session.title}"! Cek My Schedule.',
        style: const TextStyle(fontFamily: 'JetBrainsMono'),
      ),
    ),
  );

  if (already) return;

  // Beri XP (backend) — hanya untuk join baru.
  final result = await XpApi.award(
    action: 'join',
    startHour: XpApi.parseStartHour(session.startTime),
    startMinute: XpApi.parseStartMinute(session.startTime),
    spotsFilled: session.spotsFilled + 1,
    spotsTotal: session.spotsTotal,
    location: session.location,
    rewardPoints: session.rewardPoints,
    minutes: XpApi.durationMinutes(session.startTime, session.endTime),
  );
  if (result != null && result.gainedXp > 0) {
    final parts = <String>['+${result.gainedXp} XP'];
    if (result.leveledUp) parts.add('LEVEL UP! (Lvl ${result.level})');
    if (result.newBadges.isNotEmpty) {
      parts.add('Badge baru: ${result.newBadges.join(', ')}');
    }
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: _brown,
        content: Text(
          parts.join('  •  '),
          style: const TextStyle(fontFamily: 'JetBrainsMono'),
        ),
      ),
    );
  }

  // Segarkan profil agar Home & Profile langsung menampilkan XP/stats terbaru.
  await ProfileStore.instance.refresh();
}
