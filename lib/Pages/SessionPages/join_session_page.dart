import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';
import 'package:fitarena/Pages/SessionPages/session_join.dart';

/// Halaman detail "Join This Session" (layar penuh).
class JoinSessionPage extends StatelessWidget {
  final SessionData session;
  const JoinSessionPage({super.key, required this.session});

  static const Color _cream = Color(0xFFE1E2D6);
  static const Color _darkGreen = Color(0xFF00342B);
  static const Color _black = Color(0xFF111111);

  // Foto kecil anggota (squad). Dipakai berulang sesuai jumlah peserta.
  static const List<String> _squadAvatars = [
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
  ];

  void _join(BuildContext context) {
    // Simpan ke My Schedule (+ XP) lalu kembali ke halaman Session.
    unawaited(performJoinFlow(context, session));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(image: session.imageProvider, fit: BoxFit.cover),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 14,
                      child: Text(
                        session.title,
                        style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 44,
                          height: 1.0,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _accentCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _kv('Location', session.location.toUpperCase()),
                          const SizedBox(height: 14),
                          _kv('Time', session.timeRange.toUpperCase()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _accentCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _kv('Reward', '+${session.rewardPoints} points'),
                          const SizedBox(height: 14),
                          _kv('Achievements', '+${session.xp} XP'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'THE SQUAD',
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 22,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          '${session.spotsFilled}/${session.spotsTotal} PARTICIPANTS',
                          style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 18,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 64,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: session.spotsFilled,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            image: DecorationImage(
                              image: NetworkImage(
                                _squadAvatars[i % _squadAvatars.length],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'THE HOST',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDCDDDB),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/profile/JohnGreenjim.jpeg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                session.host.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 24,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: () => _join(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        color: _black,
                        child: const Text(
                          'JOIN THIS SESSION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            color: Colors.white,
                            fontSize: 30,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Kartu putih dengan aksen hijau di kiri + hard shadow.
  Widget _accentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: _darkGreen, width: 6)),
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: child,
    );
  }

  // Pasangan label (kecil) + value (besar).
  Widget _kv(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
