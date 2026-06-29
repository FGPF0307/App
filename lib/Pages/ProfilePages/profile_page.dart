import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitarena/Pages/ProfilePages/badge_gallery_page.dart';
import 'package:fitarena/Pages/ProfilePages/level_evolution_page.dart';
import 'package:fitarena/Pages/ProfilePages/my_rewards_page.dart';
import 'package:fitarena/Pages/SignUpandSigninPage/signuppage.dart';
import 'package:fitarena/services/profile_service.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';
import 'package:fitarena/widgets/fit_dialog.dart';
import 'fitness_summary_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Data dari store reaktif; ikut ter-update setelah join/host (XP bertambah).
  ProfileData get _data => ProfileStore.instance.data;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    ProfileStore.instance.refresh();
  }

  Future<void> _pickAvatar() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 800,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      final ext = picked.name.contains('.') ? picked.name.split('.').last : 'jpg';
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('Uploading photo...')),
      );
      await ProfileStore.instance.uploadAvatar(bytes, ext);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Profile photo updated!'),
          backgroundColor: Color(0xFF043927),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload photo. Try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _loadProfile() => ProfileStore.instance.refresh();

  /// Format angka dengan pemisah ribuan (mis. 2450 -> "2,450").
  String _fmt(int n) => n.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]},',
      );

  Future<void> _editName() async {
    final controller = TextEditingController(text: _data.fullName);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFFE1DCD3),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: const Text(
            'EDIT NAME',
            style: TextStyle(fontFamily: 'BebasNeue', fontSize: 24, letterSpacing: 1.0),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'FULL NAME',
              labelStyle: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL',
                  style: TextStyle(fontFamily: 'BebasNeue', color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF043927),
                shape:
                    const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('SAVE',
                  style: TextStyle(fontFamily: 'BebasNeue', color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (newName == null || newName.isEmpty || newName == _data.fullName) return;

    try {
      await ProfileService.updateName(newName);
      await _loadProfile();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name updated!'), backgroundColor: Colors.green),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update name. Try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const scaffoldBgColor = Color(0xFFE1DCD3);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: ProfileStore.instance,
          builder: (context, _) => RefreshIndicator(
          onRefresh: _loadProfile,
          color: const Color(0xFF043927),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _editName,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                'HELLO,\n${_data.fullName.toUpperCase()}!',
                                style: const TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 32,
                                  height: 1.0,
                                  letterSpacing: 1.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(Icons.edit, size: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickAvatar,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey,
                              backgroundImage: _data.avatarUrl.isNotEmpty
                                  ? NetworkImage(_data.avatarUrl)
                                  : null,
                              child: _data.avatarUrl.isEmpty
                                  ? const Icon(Icons.person,
                                      color: Colors.white, size: 30)
                                  : null,
                            ),
                          ),
                          // Badge kamera kecil sebagai penanda bisa diganti.
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF043927),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 12),
                            ),
                          ),
                        ],
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
                      image: AssetImage('assets/images/running_track.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LEVEL ${_data.level}',
                            style: const TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 32,
                                color: Colors.white,
                                letterSpacing: 2.0)),
                        Text(_data.title.toUpperCase(),
                            style: const TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 48,
                                color: Colors.white,
                                height: 0.9,
                                letterSpacing: 2.0)),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('PROGRESS',
                                style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '${_fmt(_data.currentXp)} / ${_fmt(_data.xpToNext)} XP',
                                style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Progress Bar (lebar terisi sesuai fraksi XP)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 8,
                            width: double.infinity,
                            color: Colors.white.withValues(alpha: 0.3),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _data.xpFraction,
                              child: Container(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- PREFERRED SPORTS (dari onboarding) ---
                if (_data.preferences.isNotEmpty) ...[
                  _buildSectionHeader('PREFERRED SPORTS'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final p in _data.preferences) _buildPrefChip(p),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],

                // --- PERFORMANCE INDEX ---
                _buildSectionHeader('PERFORMANCE INDEX'),
                _buildIndexRow('POINTS TOTAL', _fmt(_data.pointsTotal)),
                _buildIndexRow('MINUTES TRAINING', _fmt(_data.minutesTraining)),
                _buildIndexRow(
                    'CURRENT STREAK',
                    '${_data.currentStreak.toString().padLeft(2, '0')} DAYS',
                    valueColor: const Color(0xFF4A6B38)),
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
                _buildMenuItem('MY REWARDS', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyRewardsPage()),
                  );
                }),
                const SizedBox(height: 30),

                // --- ACCOUNT SETTINGS ---
                _buildSectionHeader('ACCOUNT SETTINGS'),
                _buildMenuItem('EDIT ATHLETE PROFILE', onTap: _editName),
                _buildMenuItem('SPORT HISTORY', onTap: () {
                  showFitInfoDialog(
                    context,
                    title: 'UNDER CONSTRUCTION',
                    message: 'This feature is under construction.',
                  );
                }),
                _buildMenuItem('PRIVACY & SECURITY', onTap: () {
                  showFitInfoDialog(
                    context,
                    title: 'UNDER CONSTRUCTION',
                    message: 'This feature is under construction.',
                  );
                }),
                _buildMenuItem('LOG OUT', onTap: () async {
                  final ok = await showFitConfirmDialog(
                    context,
                    title: 'LOG OUT',
                    message: 'Are you sure you want to log out?',
                  );
                  if (!ok) return;
                  try {
                    await Supabase.instance.client.auth.signOut();
                  } catch (_) {}
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                    (route) => false,
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  // Chip preferensi olahraga (emoji + nama).
  Widget _buildPrefChip(String name) {
    final emoji = hostCategories
        .firstWhere(
          (c) => c.name == name,
          orElse: () => const SportCategory(name: '', emoji: '🏅', photoIds: []),
        )
        .emoji;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
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
          style: const TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 20,
              letterSpacing: 1.0,
              color: Colors.black),
        ),
        const Divider(color: Colors.black, thickness: 1.5, height: 16),
      ],
    );
  }

  Widget _buildIndexRow(String label, String value,
      {Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomPaint(painter: DottedLinePainter()),
            ),
          ),
          Text(value,
              style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: valueColor)),
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
              Text(title,
                  style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
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
    var paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
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
