import 'package:flutter/material.dart';
import 'package:fitarena/services/profile_service.dart';

class FitnessSummaryPage extends StatefulWidget {
  const FitnessSummaryPage({super.key});

  @override
  State<FitnessSummaryPage> createState() => _FitnessSummaryPageState();
}

class _FitnessSummaryPageState extends State<FitnessSummaryPage> {
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

  String _fmt(int n) => n.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]},',
      );

  @override
  Widget build(BuildContext context) {
    const scaffoldBgColor = Color(0xFFE1DCD3);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'YOUR FITNESS\nSUMMARY',
          style: TextStyle(fontFamily: 'BebasNeue', color: Colors.black, fontSize: 28, height: 1.0, letterSpacing: 1.0),
        ),
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white, size: 22),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildStatCard(
              icon: Icons.stars,
              value: _fmt(_data.pointsTotal),
              label: 'POINTS',
              desc: 'Stack rewards by hosting and joining active sessions.',
              bgColor: Colors.white,
              textColor: Colors.black,
            ),
            const SizedBox(height: 20),
            _buildStatCard(
              icon: Icons.timer,
              value: _fmt(_data.minutesTraining),
              label: 'MINUTES',
              desc: 'Time spent moving, connecting and dominating.',
              bgColor: const Color(0xFF5A6A3A), // Hijau Olive
              textColor: Colors.white,
            ),
            const SizedBox(height: 20),
            _buildStatCard(
              icon: Icons.calendar_today_outlined,
              value: '${_data.effectiveStreak.toString().padLeft(2, '0')} DAYS',
              label: 'STREAK',
              desc: 'Maintain the momentum. Attend your next session to unlock elite tier status.',
              bgColor: const Color(0xFF333333), // Dark Grey
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required String desc,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 28),
          const SizedBox(height: 24),
          Text(
            value,
            style: TextStyle(fontFamily: 'BebasNeue', fontSize: 56, color: textColor, height: 1.0, letterSpacing: 2.0),
          ),
          Text(
            label,
            style: TextStyle(fontFamily: 'BebasNeue', fontSize: 18, color: textColor, letterSpacing: 1.0),
          ),
          const SizedBox(height: 16),
          Divider(color: textColor.withValues(alpha: 0.5), thickness: 1),
          const SizedBox(height: 16),
          Text(
            desc,
            style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, color: textColor, height: 1.5),
          ),
        ],
      ),
    );
  }
}
