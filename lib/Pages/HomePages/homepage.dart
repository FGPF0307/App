import 'package:flutter/material.dart';
import 'package:greengymapp/Pages/SessionPages/JoinSessionPage.dart';
import 'package:greengymapp/Pages/SessionPages/session_models.dart';

class FitnessDashboardPage extends StatelessWidget {
  const FitnessDashboardPage({super.key});

  // Helper untuk membuat dekorasi bergaya Neo-Brutalism (Border Tebal + Hard Shadow)
  BoxDecoration _brutalistDecoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: Colors.black, width: 2),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          offset: Offset(4, 4), // Bayangan tegas kaku ke kanan bawah
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menyesuaikan warna background lembut dari mockup figma kamu
    const scaffoldBgColor = Color(0xFFE1DCD3);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // 1. HEADER: USER PROFILE & LEVEL PROGRESS
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'HELLO,',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 28,
                          height: 0.9,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'JOHN GREENJIM',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 36,
                          height: 1.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  // Foto Profil Melingkar dengan Border Hitam
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Ganti dengan asset fotomu
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // KOTAK PROGRESS LEVEL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _brutalistDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Level 24 : Kinetic',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1A3F39),
                          ),
                        ),
                        Text(
                          '12,000 / 40,000',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar Kustom
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 12000,
                            child: Container(color: const Color(0xFFC3E29E)), // Warna hijau bar figma
                          ),
                          Expanded(
                            flex: 28000,
                            child: Container(color: Colors.transparent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // ============================================================
              // 2. CARD: UPCOMING TASK (RUNNING)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _brutalistDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Hitam Tulisan Putih
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      color: Colors.black,
                      child: const Text(
                        'UPCOMING TASK',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'RUNNING (NEXT SESSION)',
                      style: TextStyle(fontFamily: 'BebasNeue', fontSize: 26, letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Keep the streak alive. Complete your daily run and collect your XP.',
                      style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    // Row Stats Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTaskStat('DURATION', '120 mins'),
                        _buildTaskStat('REWARD', '200 pts'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(child: _buildTaskStat('BONUS', '500 XP')),
                    const SizedBox(height: 20),
                    // Tombol Check-in Now
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JoinSessionPage(
                              session: SessionData.running),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        color: Colors.black,
                        child: const Text(
                          'Check-in Now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // ============================================================
              // 3. CARD: ACTIVE SESSION (BASKETBALL)
              // ============================================================
              const Text(
                'ACTIVE SESSION',
                style: TextStyle(fontFamily: 'BebasNeue', fontSize: 22, letterSpacing: 1.0),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _brutalistDecoration(),
                child: Column(
                  children: [
                    // Gambar Bola Basket (Menggunakan Icon besar sebagai representasi mockup)
                    const Icon(Icons.sports_basketball, size: 100, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      'BASKETBALL 3V3',
                      style: TextStyle(fontFamily: 'BebasNeue', fontSize: 24, letterSpacing: 1.0),
                    ),
                    const Text(
                      'Decathlon Alam Sutera',
                      style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Bar Data Abu-abu dengan pembatas hitam
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _buildActiveSessionStat('REWARD', '200 pts')),
                          Container(width: 1.5, height: 40, color: Colors.black),
                          Expanded(child: _buildActiveSessionStat('END TIME', '18.30 PM')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tombol View Details (Model Border Outline)
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JoinSessionPage(
                              session: SessionData.basketballActive),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Text(
                          'View Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // ============================================================
              // 4. GRID SECTIONS: FITNESS SCORECARD
              // ============================================================
              const Text(
                'FITNESS SCORECARD',
                style: TextStyle(fontFamily: 'BebasNeue', fontSize: 22, letterSpacing: 1.0),
              ),
              const SizedBox(height: 10),
              // Baris pertama Scorecard (Kiri & Kanan)
              Row(
                children: [
                  Expanded(
                    child: _buildScorecardCard(Icons.star_border, 'Points Earned', '2,450 pts'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildScorecardCard(Icons.access_time, 'Workout Mins', '1,240 mins'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Baris kedua Scorecard (Full Lebar Bawah)
              _buildScorecardCard(Icons.calendar_today_outlined, 'Active Streak', '14 Days', isFullWidth: true),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Pembantu untuk Komponen Kecil Stats di Card Atas
  Widget _buildTaskStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Widget Pembantu untuk Stats di dalam Kotak Abu-abu Active Session
  Widget _buildActiveSessionStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Widget Pembantu untuk Membuat Grid Kotak Skor Fitness
  Widget _buildScorecardCard(IconData icon, String title, String value, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: _brutalistDecoration(),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 22, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}