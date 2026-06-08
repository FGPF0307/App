import 'package:flutter/material.dart';

class BadgeGalleryPage extends StatelessWidget {
  const BadgeGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const scaffoldBgColor = Color(0xFFE1DCD3);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: _buildCustomAppBar(context, 'BADGE\nGALLERY'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        children: [
          _buildBadgeItem(
            number: '01',
            title: 'DYNAMIC DUO',
            iconData: Icons.people_alt,
            desc: 'HIGH-INTENSITY SYNCHRONIZED SESSIONS',
            progressText: '42/60 SESSIONS',
            tier: '[PRO]',
            isLocked: false,
          ),
          _buildBadgeItem(
            number: '02',
            title: 'EARLY BIRD',
            iconData: Icons.wb_sunny,
            desc: 'PRE-DAWN PERFORMANCE CYCLE',
            progressText: '15/20 SESSIONS',
            tier: '[SILVER]',
            isLocked: false,
          ),
          _buildBadgeItem(
            number: '03',
            title: 'TRENDSETTER',
            iconData: Icons.show_chart,
            desc: 'SOCIAL INFLUENCE & NETWORK SCALING',
            progressText: '08/20 SESSIONS',
            tier: '[LOCKED]',
            isLocked: true,
          ),
          _buildBadgeItem(
            number: '04',
            title: 'ACTIVE FOLLOWERS',
            iconData: Icons.add_circle,
            desc: 'SESSION PARTICIPATION PROTOCOL',
            progressText: '00/20 SESSIONS',
            tier: '[LOCKED]',
            isLocked: true,
          ),
          _buildBadgeItem(
            number: '05',
            title: 'IRON STREAK',
            iconData: Icons.bolt,
            desc: 'CONSECUTIVE DAILY MOMENTUM',
            progressText: '1/14 DAYS',
            tier: '[LOCKED]',
            isLocked: true,
          ),
          _buildBadgeItem(
            number: '06',
            title: 'COMMUNITY HOPPER',
            iconData: Icons.map,
            desc: 'MULTI-VENUE GEOGRAPHIC EXPLORATION',
            progressText: '5/20 LOCATIONS',
            tier: '[LOCKED]',
            isLocked: true,
          ),
        ],
      ),
    );
  }

  // WIDGET ITEM BADGE
  Widget _buildBadgeItem({
    required String number,
    required String title,
    required IconData iconData,
    required String desc,
    required String progressText,
    required String tier,
    required bool isLocked,
  }) {
    // Jika badge terkunci (locked), warna teksnya menjadi abu-abu
    Color textColor = isLocked ? Colors.grey : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor Badge (Kecil di atas kiri)
          Text(number, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, color: textColor, fontWeight: FontWeight.bold)),
          
          // Judul dan Ikon
          Row(
            children: [
              Text(title, style: TextStyle(fontFamily: 'BebasNeue', fontSize: 26, letterSpacing: 1.0, color: textColor)),
              const SizedBox(width: 8),
              Icon(iconData, size: 22, color: textColor),
            ],
          ),
          const SizedBox(height: 4),

          // Deskripsi Badge
          Text(desc, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 9, color: textColor, letterSpacing: 0.5)),
          const SizedBox(height: 16),

          // Baris Bawah: Teks Progress & Status Tier (Pro/Locked)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(progressText, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: textColor, fontWeight: FontWeight.bold)),
              Text(tier, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: textColor, fontWeight: FontWeight.bold)),
            ],
          ),
          
          // Garis Hitam Solid sebagai pemisah/indikator
          const SizedBox(height: 6),
          Container(height: 2, width: double.infinity, color: textColor),
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