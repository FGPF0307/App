import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitarena/Pages/main_navigation.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';
import 'package:fitarena/services/profile_service.dart';

/// Onboarding pemain baru: isi nama lalu pilih preferensi olahraga.
/// Keduanya disimpan ke profil (Supabase) dan dipakai di halaman lain.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const Color _sand = Color(0xFFE1DCD3);
  static const Color _ink = Color(0xFF111111);

  int _step = 0;
  bool _saving = false;
  final TextEditingController _nameController = TextEditingController();
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    // Pra-isi dengan nama dari pendaftaran (metadata akun), jika ada.
    final meta = Supabase.instance.client.auth.currentUser?.userMetadata;
    final name = meta?['full_name'] as String?;
    if (name != null && name.trim().isNotEmpty) _nameController.text = name.trim();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _goToPreferences() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Isi nama dulu, challenger!'),
        ),
      );
      return;
    }
    setState(() => _step = 1);
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    try {
      await ProfileService.completeOnboarding(
        name: _nameController.text.trim(),
        preferences: _selected.toList(),
      );
      await ProfileStore.instance.refresh();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Gagal menyimpan. Coba lagi.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _sand,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WELCOME NEW CHALLENGER',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 3,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(child: _step == 0 ? _buildNameStep() : _buildPrefStep()),
            ],
          ),
        ),
      ),
    );
  }

  // ── LANGKAH 1: NAMA ──
  Widget _buildNameStep() {
    return Column(
      children: [
        _hardShadowBox(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ENTER YOUR NAME',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 34,
                  letterSpacing: 1,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                color: _ink,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'TYPE HERE',
                    hintStyle: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _journeyButton(onTap: _goToPreferences),
            ],
          ),
        ),
      ],
    );
  }

  // ── LANGKAH 2: PREFERENSI ──
  Widget _buildPrefStep() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text(
            'CHOOSE YOUR PREFERENCES',
            style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 34,
              letterSpacing: 1,
              color: _ink,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 22,
            crossAxisSpacing: 22,
            padding: const EdgeInsets.symmetric(vertical: 4),
            children: [
              for (final c in hostCategories) _buildSportTile(c),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _journeyButton(onTap: _saving ? null : _finish, loading: _saving),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSportTile(SportCategory c) {
    final bool selected = _selected.contains(c.name);
    return GestureDetector(
      onTap: () => setState(() {
        if (selected) {
          _selected.remove(c.name);
        } else {
          _selected.add(c.name);
        }
      }),
      child: _hardShadowBox(
        color: selected ? _ink : Colors.white,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(c.emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 10),
            Text(
              c.name,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
                color: selected ? Colors.white : _ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── KOMPONEN BERSAMA ──
  Widget _hardShadowBox({
    required Widget child,
    required Color color,
    required EdgeInsets padding,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: _ink, width: 3),
        boxShadow: const [
          BoxShadow(color: _ink, offset: Offset(6, 6)),
        ],
      ),
      child: child,
    );
  }

  Widget _journeyButton({required VoidCallback? onTap, bool loading = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: _ink,
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Text(
                'START YOUR JOURNEY',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                  letterSpacing: 2,
                ),
              ),
      ),
    );
  }
}
