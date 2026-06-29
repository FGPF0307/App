import 'package:flutter/material.dart';
import 'package:fitarena/services/profile_service.dart';

/// Definisi satu tingkatan (tier) evolusi level.
class _Tier {
  final int lo;
  final int hi;
  final String title;
  final List<String> tags;
  final Color bgColor;
  const _Tier(this.lo, this.hi, this.title, this.tags, this.bgColor);
}

// 10 tier kasta sesuai spesifikasi (Level 1-99).
const List<_Tier> _tiers = [
  _Tier(1, 10, 'SPARK', ['NEW JOINER', 'ENDURANCE BASE'], Color(0xFF5A6676)),
  _Tier(11, 20, 'HABIT BUILDER', ['CONSISTENCY', 'RECOVERY CYCLE'], Color(0xFF48566E)),
  _Tier(21, 30, 'KINETIC', ['POWER OUTPUT', 'DYNAMIC SPEED'], Color(0xFF273E95)),
  _Tier(31, 40, 'IRON CORE', ['MENTAL FORTITUDE', 'LOAD CAPACITY'], Color(0xFF1D2C76)),
  _Tier(41, 50, 'ELITE STRIDER', ['LOCAL DRIVER', 'STAMINA PEAK'], Color(0xFF65753E)),
  _Tier(51, 60, 'APEX', ['CITY TOP TIER', 'EXPLOSIVE FORCE'], Color(0xFF4A572D)),
  _Tier(61, 70, 'VANGUARD', ['CLAN LEADER', 'ARENA DOMINANCE'], Color(0xFF8A5A20)),
  _Tier(71, 80, 'INFINITE', ['ABOVE AVERAGE', 'MAX DURABILITY'], Color(0xFF7A3E10)),
  _Tier(81, 90, 'OVERLORD', ['LOCAL LEGEND', 'REGION RULER'], Color(0xFF942828)),
  _Tier(91, 99, 'ABSOLUTE MASTER', ['FITNESS DEITY', 'PUBLIC ICON'], Color(0xFF111111)),
];

class LevelEvolutionPage extends StatefulWidget {
  const LevelEvolutionPage({super.key});

  @override
  State<LevelEvolutionPage> createState() => _LevelEvolutionPageState();
}

class _LevelEvolutionPageState extends State<LevelEvolutionPage> {
  int _level = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ProfileService.fetchMyProfile();
    if (!mounted) return;
    setState(() => _level = data.level);
  }

  @override
  Widget build(BuildContext context) {
    const scaffoldBgColor = Color(0xFFE1DCD3);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: _buildCustomAppBar(context, 'LEVEL\nEVOLUTION'),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _tiers.length,
        itemBuilder: (context, i) {
          final t = _tiers[i];
          // Status dihitung dari level user saat ini.
          final bool completed = _level > t.hi;
          final bool inProgress = _level >= t.lo && _level <= t.hi;
          final String status = completed
              ? '[ x ] COMPLETED'
              : inProgress
                  ? '[ ! ] ON PROGRESS'
                  : '[ ] LOCKED';
          final IconData icon = completed
              ? Icons.check
              : inProgress
                  ? Icons.flash_on
                  : Icons.lock;
          return _buildTimelineStep(
            status: status,
            levelRange: 'LVL ${t.lo}-${t.hi}',
            title: t.title,
            tags: t.tags,
            bgColor: t.bgColor,
            iconData: icon,
            isActive: completed || inProgress,
            isLast: i == _tiers.length - 1,
          );
        },
      ),
    );
  }

  // WIDGET TIMELINE & CARD
  Widget _buildTimelineStep({
    required String status,
    required String levelRange,
    required String title,
    required List<String> tags,
    required Color bgColor,
    required IconData iconData,
    required bool isActive,
    bool isLast = false,
  }) {
    // Warna teks berubah jadi lime green jika background terlalu gelap (seperti Titan/Absolute Master)
    bool isDarkTheme = title == 'TITAN' || title == 'ABSOLUTE MASTER';
    Color titleColor = isDarkTheme ? const Color(0xFFC3E29E) : Colors.white;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // KIRI: Garis Vertikal & Ikon
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Expanded(child: Container(width: 1.5, color: Colors.black)), // Garis atas
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF5C6A79) : Colors.transparent, // Warna bundaran ikon
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, size: 14, color: isActive ? Colors.white : Colors.black),
                ),
                Expanded(child: Container(width: 1.5, color: isLast ? Colors.transparent : Colors.black)), // Garis bawah
              ],
            ),
          ),
          const SizedBox(width: 16),
          // KANAN: Kotak Level Brutalist
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0), // Jarak antar kotak
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris Atas: Status & Range
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(status, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: Colors.white)),
                        Text(levelRange, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Judul Level
                    Text(title, style: TextStyle(fontFamily: 'BebasNeue', fontSize: 42, color: titleColor, letterSpacing: 1.5, height: 1.0)),
                    const SizedBox(height: 12),
                    // Tag Bawah (Putih Border Hitam)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 1.5)),
                        child: Text(tag, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET APPBAR KUSTOM
  PreferredSizeWidget _buildCustomAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: const Color(0xFFE1DCD3),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context), // <--- UBAH JADI onPressed
      ),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'BebasNeue', color: Colors.black, fontSize: 28, height: 1.0, letterSpacing: 1.0),
      ),
      toolbarHeight: 80,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)),
            child: const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white, size: 22)),
          ),
        )
      ],
    );
  }
}