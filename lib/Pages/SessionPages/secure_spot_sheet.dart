import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';
import 'package:fitarena/Pages/SessionPages/session_join.dart';
import 'package:fitarena/Pages/SessionPages/join_session_page.dart';

/// Menampilkan bottom sheet "Secure My Spot" yang muncul menggeser dari bawah.
/// - "Secure My Spot" langsung menyimpan sesi ke My Schedule (+ XP).
/// - "View Details" membuka halaman [JoinSessionPage].
Future<void> showSecureSpotSheet(BuildContext context, SessionData session) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      void openDetail() {
        Navigator.of(sheetContext).pop(); // tutup sheet
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => JoinSessionPage(session: session)),
        );
      }

      void secureSpot() {
        Navigator.of(sheetContext).pop(); // tutup sheet
        // Simpan ke My Schedule (+ XP). Halaman Session otomatis pindah
        // ke tab My Schedule karena daftarnya bertambah.
        unawaited(performJoinFlow(context, session));
      }

      return _SecureSpotSheet(
        session: session,
        onOpenDetail: openDetail,
        onSecure: secureSpot,
      );
    },
  );
}

class _SecureSpotSheet extends StatelessWidget {
  final SessionData session;
  final VoidCallback onOpenDetail;
  final VoidCallback onSecure;

  const _SecureSpotSheet({
    required this.session,
    required this.onOpenDetail,
    required this.onSecure,
  });

  static const Color _darkGreen = Color(0xFF00342B);
  static const Color _olive = Color(0xFF8A7A1F);
  static const Color _boxBg = Color(0xFFF1F0E8);
  static const Color _black = Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grab handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── BARIS HOST + VIEW DETAILS ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/profile/JohnGreenjim.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HOSTING BY',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: Colors.black45,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      session.host.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 22,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onOpenDetail,
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ── JUDUL & WAKTU ──
          Text(
            session.title,
            style: const TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 38,
              height: 1.0,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${session.day}, ${session.startTime}   •   ${session.location}',
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // ── BOX SPOTS FILLED ──
          _infoBox(
            accent: _darkGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${session.slotsLeft} SLOTS LEFT',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.spotsFilled}/${session.spotsTotal} Spots Filled',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── BOX REWARD & ACHIEVEMENTS ──
          _infoBox(
            accent: _olive,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reward & Achievements',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _olive,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '+${session.rewardPoints} Points',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '+${session.xp} XP',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── TOMBOL SECURE MY SPOT ──
          GestureDetector(
            onTap: onSecure,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              color: _black,
              child: const Text(
                'SECURE MY SPOT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  color: Colors.white,
                  fontSize: 32,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox({required Color accent, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _boxBg,
        border: Border(left: BorderSide(color: accent, width: 6)),
      ),
      child: child,
    );
  }
}
