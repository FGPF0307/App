import 'package:flutter/material.dart';
import 'package:greengymapp/Pages/ProfilePages/badge_gallery_page.dart';
import 'package:greengymapp/Pages/ProfilePages/level_evolution_page.dart';
import 'fitness_summary_page.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const scaffoldBgColor = Color(0xFFE1DCD3);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HELLO,\nFARREL GANENDRA!',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 32,
                      height: 1.0,
                      letterSpacing: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Ganti dengan foto profil
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- HERO IMAGE: LEVEL & PROGRESS ---
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/running_track.jpg'), // Ganti dengan asset gambar lari
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.4), // Dark overlay agar teks terbaca
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('LEVEL 24', style: TextStyle(fontFamily: 'BebasNeue', fontSize: 32, color: Colors.white, letterSpacing: 2.0)),
                      const Text('KINETIC', style: TextStyle(fontFamily: 'BebasNeue', fontSize: 48, color: Colors.white, height: 0.9, letterSpacing: 2.0)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('PROGRESS', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('12,000 / 40,000 XP', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Progress Bar
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 12, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)))),
                            Expanded(flex: 28, child: Container(color: Colors.transparent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- PERFORMANCE INDEX ---
              _buildSectionHeader('PERFORMANCE INDEX'),
              _buildIndexRow('POINTS TOTAL', '2,450'),
              _buildIndexRow('MINUTES TRAINING', '1,200'),
              _buildIndexRow('CURRENT STREAK', '07 DAYS', valueColor: const Color(0xFF4A6B38)), // Warna hijau
              const SizedBox(height: 30),

              // --- EARNED BADGE ---
              _buildSectionHeader('EARNED BADGE'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEmptyBadge(),
                    _buildEmptyBadge(),
                    _buildEmptyBadge(),
                  ],
                ),
              ),
              const SizedBox(height: 40),

// --- PERFORMANCE DIRECTORY ---
              _buildSectionHeader('PERFORMANCE DIRECTORY'),
              
              _buildMenuItem('LEVEL EVOLUTION', onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const LevelEvolutionPage()),
                );
              }),
              
              _buildMenuItem('BADGE GALLERY', onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const BadgeGalleryPage()),
                );
              }),
              
              _buildMenuItem('FITNESS SUMMARY', onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const FitnessSummaryPage()),
                );
              }),
              const SizedBox(height: 30),

              // --- ACCOUNT SETTINGS ---
              _buildSectionHeader('ACCOUNT SETTINGS'),
              _buildMenuItem('EDIT ATHLETE PROFILE', onTap: () {}),
              _buildMenuItem('SPORT HISTORY', onTap: () {}),
              _buildMenuItem('PRIVACY & SECURITY', onTap: () {}),
              _buildMenuItem('LOG OUT', onTap: () {}),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET BANTUAN
  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 20, letterSpacing: 1.0, color: Colors.black),
        ),
        const Divider(color: Colors.black, thickness: 1.5, height: 16),
      ],
    );
  }

  Widget _buildIndexRow(String label, String value, {Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, fontWeight: FontWeight.bold)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomPaint(painter: DottedLinePainter()), // Garis putus-putus
            ),
          ),
          Text(value, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 13, fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildEmptyBadge() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildMenuItem(String title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFDCDDDB), width: 1)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
              const Icon(Icons.arrow_forward, size: 16, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

// Painter untuk garis putus-putus di Performance Index
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.grey..strokeWidth = 1;
    var max = size.width;
    var dashWidth = 3.0;
    var dashSpace = 3.0;
    double startX = 0;
    while (startX < max) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}