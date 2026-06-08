import 'package:flutter/material.dart';

class LevelEvolutionPage extends StatelessWidget {
  const LevelEvolutionPage({super.key});

  @override
  Widget build(BuildContext context) {
    const scaffoldBgColor = Color(0xFFE1DCD3);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: _buildCustomAppBar(context, 'LEVEL\nEVOLUTION'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // LEVEL 0-9 (COMPLETED)
          _buildTimelineStep(
            status: '[ x ] COMPLETED',
            levelRange: 'LVL 0-9',
            title: 'SPARK',
            tags: ['ENDURANCE BASE', 'MECHANICAL CORE'],
            bgColor: const Color(0xFF5A6676), // Slate Grey
            iconData: Icons.check,
            isCompleted: true,
          ),
          // LEVEL 10-19 (COMPLETED)
          _buildTimelineStep(
            status: '[ x ] COMPLETED',
            levelRange: 'LVL 10-19',
            title: 'HABIT BUILDER',
            tags: ['CONSISTENCY', 'RECOVERY CYCLE'],
            bgColor: const Color(0xFF48566E), // Darker Slate
            iconData: Icons.check,
            isCompleted: true,
          ),
          // LEVEL 20-29 (ON PROGRESS)
          _buildTimelineStep(
            status: '[ ! ] ON PROGRESS',
            levelRange: 'LVL 20-29',
            title: 'KINETIC',
            tags: ['POWER OUTPUT', 'DYNAMIC SPEED'],
            bgColor: const Color(0xFF273E95), // Royal Blue
            iconData: Icons.flash_on,
            isCompleted: true, // Icon background is active
          ),
          // LEVEL 30-39 (LOCKED)
          _buildTimelineStep(
            status: '[ ] LOCKED',
            levelRange: 'LVL 30-39',
            title: 'IRON WILL',
            tags: ['MENTAL FORTITUDE', 'LOAD CAPACITY'],
            bgColor: const Color(0xFF1D2C76), // Dark Blue
            iconData: Icons.lock,
            isCompleted: false,
          ),
          // LEVEL 40-49 (LOCKED)
          _buildTimelineStep(
            status: '[ ] LOCKED',
            levelRange: 'LVL 40-49',
            title: 'CATALYST',
            tags: ['STAMINA PEAK', 'METABOLIC DRIVE'],
            bgColor: const Color(0xFF65753E), // Olive Green
            iconData: Icons.lock,
            isCompleted: false,
          ),
          // LEVEL 50-59 (LOCKED)
          _buildTimelineStep(
            status: '[ ] LOCKED',
            levelRange: 'LVL 50-59',
            title: 'VANGUARD',
            tags: ['ARENA DOMINANCE', 'EXPLOSIVE FORCE'],
            bgColor: const Color(0xFF4A572D), // Dark Olive
            iconData: Icons.lock,
            isCompleted: false,
          ),
          // LEVEL 60-69 (LOCKED)
          _buildTimelineStep(
            status: '[ ] LOCKED',
            levelRange: 'LVL 60-69',
            title: 'APEX RAIDER',
            tags: ['TACTICAL', 'MAX POWER'],
            bgColor: const Color(0xFF942828), // Red
            iconData: Icons.lock,
            isCompleted: false,
            isLast: true, // Garis berhenti di sini (atau teruskan sesuai data)
          ),
        ],
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
    required bool isCompleted,
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
                    color: isCompleted ? const Color(0xFF5C6A79) : Colors.transparent, // Warna bundaran ikon
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, size: 14, color: isCompleted ? Colors.white : Colors.black),
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
            child: const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
          ),
        )
      ],
    );
  }
}