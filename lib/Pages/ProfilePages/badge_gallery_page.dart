import 'package:flutter/material.dart';
import 'package:fitarena/services/profile_service.dart';

/// Definisi satu badge pada Badge Gallery (sesuai image_bf5e80.png).
class _BadgeDef {
  final String number; // "01".."06"
  final String title;
  final String subtext;
  final IconData icon;
  final int target;
  final String unit; // SESSIONS / DAYS / LOCATIONS
  final String tier; // label kasta saat terbuka: [PRO], [SILVER], dst.
  final int Function(ProfileData p) value; // progres saat ini dari profil

  const _BadgeDef({
    required this.number,
    required this.title,
    required this.subtext,
    required this.icon,
    required this.target,
    required this.unit,
    required this.tier,
    required this.value,
  });
}

// 6 badge sesuai spesifikasi.
const List<_BadgeDef> _badgeDefs = [
  _BadgeDef(
    number: '01',
    title: 'DYNAMIC DUO',
    subtext: 'HIGH-INTENSITY SYNCHRONIZED SESSIONS',
    icon: Icons.people,
    target: 60,
    unit: 'SESSIONS',
    tier: '[GOLD]',
    value: _dynamicDuo,
  ),
  _BadgeDef(
    number: '02',
    title: 'EARLY BIRD',
    subtext: 'PRE-DAWN PERFORMANCE CYCLE',
    icon: Icons.wb_sunny,
    target: 20,
    unit: 'SESSIONS',
    tier: '[PRO]',
    value: _earlyBird,
  ),
  _BadgeDef(
    number: '03',
    title: 'TRENDSETTER',
    subtext: 'SOCIAL INFLUENCE & NETWORK SCALING',
    icon: Icons.trending_up,
    target: 20,
    unit: 'SESSIONS',
    tier: '[SILVER]',
    value: _trendsetter,
  ),
  _BadgeDef(
    number: '04',
    title: 'ACTIVE FOLLOWERS',
    subtext: 'SESSION PARTICIPATION PROTOCOL',
    icon: Icons.add,
    target: 20,
    unit: 'SESSIONS',
    tier: '[BRONZE]',
    value: _activeFollowers,
  ),
  _BadgeDef(
    number: '05',
    title: 'IRON STREAK',
    subtext: 'CONSECUTIVE DAILY MOMENTUM',
    icon: Icons.bolt,
    target: 14,
    unit: 'DAYS',
    tier: '[ELITE]',
    value: _ironStreak,
  ),
  _BadgeDef(
    number: '06',
    title: 'COMMUNITY HOPPER',
    subtext: 'MULTI-VENUE GEOGRAPHIC EXPLORATION',
    icon: Icons.map,
    target: 20,
    unit: 'LOCATIONS',
    tier: '[GOLD]',
    value: _communityHopper,
  ),
];

// Fungsi top-level agar bisa dipakai di konstanta (_BadgeDef bersifat const).
int _dynamicDuo(ProfileData p) => p.dynamicDuo;
int _earlyBird(ProfileData p) => p.earlyBird;
int _trendsetter(ProfileData p) => p.trendsetter;
int _activeFollowers(ProfileData p) => p.activeFollowers;
int _ironStreak(ProfileData p) => p.effectiveStreak;
int _communityHopper(ProfileData p) => p.locationsCount;

class BadgeGalleryPage extends StatefulWidget {
  const BadgeGalleryPage({super.key});

  @override
  State<BadgeGalleryPage> createState() => _BadgeGalleryPageState();
}

class _BadgeGalleryPageState extends State<BadgeGalleryPage> {
  // Palet Neo-Brutalisme sesuai referensi UI.
  static const Color _sand = Color(0xFFE2E2D5);
  static const Color _ink = Color(0xFF111111);

  ProfileData _data = ProfileData.fallback('ATHLETE');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ProfileService.fetchMyProfile();
    if (!mounted) return;
    setState(() => _data = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _sand,
      appBar: AppBar(
        backgroundColor: _sand,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _ink, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'BADGE\nGALLERY',
          style: TextStyle(
            fontFamily: 'BebasNeue',
            color: _ink,
            fontSize: 28,
            height: 1.0,
            letterSpacing: 1.0,
          ),
        ),
        toolbarHeight: 80,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: _ink,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          itemCount: _badgeDefs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 26),
          itemBuilder: (context, i) => _BadgeTile(def: _badgeDefs[i], data: _data),
        ),
      ),
    );
  }
}

/// Kartu satu badge: nomor + nama + subtext (kiri), ikon (kanan),
/// lalu progress bar linear datar di bawahnya.
class _BadgeTile extends StatelessWidget {
  final _BadgeDef def;
  final ProfileData data;

  const _BadgeTile({required this.def, required this.data});

  static const Color _ink = Color(0xFF111111);

  String _fmt(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final int value = def.value(data).clamp(0, def.target);
    final bool unlocked = value >= def.target;
    final double fraction = def.target == 0 ? 0 : value / def.target;

    // Badge terkunci tampil memudar (opacity 0.4) untuk nama & ikon.
    final Color textColor = unlocked ? _ink : _ink.withValues(alpha: 0.4);
    final String tierLabel = unlocked ? def.tier : '[LOCKED]';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nomor badge
        Text(
          def.number,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 2),
        // Nama + subtext (kiri) dan ikon (kanan)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    def.title,
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 30,
                      letterSpacing: 1.5,
                      height: 1.0,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    def.subtext,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 9,
                      letterSpacing: 0.5,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(def.icon, size: 32, color: textColor),
          ],
        ),
        const SizedBox(height: 12),
        // Baris progress: "42/60 SESSIONS"  ...  [TIER]
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_fmt(value)}/${def.target} ${def.unit}',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              tierLabel,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Progress bar linear datar (tanpa rounded): hitam = terisi, abu = sisa.
        SizedBox(
          height: 6,
          width: double.infinity,
          child: Stack(
            children: [
              Container(color: _ink.withValues(alpha: 0.15)),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fraction.clamp(0.0, 1.0),
                child: Container(color: _ink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
