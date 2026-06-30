import 'package:flutter/material.dart';
import 'package:fitarena/widgets/fit_dialog.dart';
import 'package:fitarena/services/reward_api.dart';
import 'package:fitarena/services/profile_service.dart';

class MyRewardsPage extends StatefulWidget {
  const MyRewardsPage({super.key});

  @override
  State<MyRewardsPage> createState() => _MyRewardsPageState();
}

class _MyRewardsPageState extends State<MyRewardsPage> {
  static const Color cream = Color(0xFFE1E2D6);
  static const Color green = Color(0xFFCFE99F);
  static const Color black = Color(0xFF111111);

  int _points = 0;
  late Future<List<RewardItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = RewardApi.fetchRewards();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final data = await ProfileService.fetchMyProfile();
    if (!mounted) return;
    setState(() => _points = data.pointsTotal);
  }

  void _reload() => setState(() => _future = RewardApi.fetchRewards());

  // Memisah ribuan: _grouped(100000, '.') -> "100.000"
  String _grouped(int n, String sep) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(sep);
      buf.write(s[i]);
    }
    return buf.toString();
  }

  Future<void> _redeem(RewardItem r) async {
    if (_points < r.cost) {
      await showFitInfoDialog(
        context,
        title: 'NOT ENOUGH POINTS',
        message:
            "You haven't reached the amount of points needed to redeem this reward.",
      );
      return;
    }

    final ok = await showFitConfirmDialog(
      context,
      title: 'REDEEM REWARD',
      message:
          'Are you sure you want to redeem "${r.oneLine}" for ${_grouped(r.cost, '.')} PTS?',
    );
    if (!ok) return;

    setState(() => _points -= r.cost);
    if (!mounted) return;
    await showFitInfoDialog(
      context,
      title: 'SUCCESS',
      message: 'Reward redeemed! Check your email for the voucher.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8, top: 4),
                      child: Icon(Icons.arrow_back_ios_new,
                          size: 22, color: black),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'MY\nREWARDS',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 48,
                        height: 0.92,
                        letterSpacing: 1.0,
                        color: black,
                      ),
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFDCDDDB),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: black, offset: Offset(6, 6)),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'POINTS WALLET',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      color: green,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      alignment: Alignment.center,
                      child: Text(
                        '${_grouped(_points, ',')} PTS',
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              FutureBuilder<List<RewardItem>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFF00342B)),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return _buildError();
                  }
                  final items = snapshot.data ?? const <RewardItem>[];
                  final vouchers =
                      items.where((r) => r.category == 'voucher').toList();
                  final nutritions =
                      items.where((r) => r.category == 'nutrition').toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('BRAND VOUCHERS'),
                      const SizedBox(height: 16),
                      for (final r in vouchers) _rewardCard(r),
                      const SizedBox(height: 16),
                      _sectionHeader('NUTRITIONS & HYDRATIONS'),
                      const SizedBox(height: 16),
                      for (final r in nutritions) _rewardCard(r),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const Icon(Icons.cloud_off, size: 44, color: Colors.black45),
          const SizedBox(height: 10),
          const Text(
            'Gagal memuat reward.',
            style: TextStyle(fontFamily: 'BebasNeue', fontSize: 22),
          ),
          const Text(
            'Pastikan backend berjalan (npm run dev).',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'JetBrainsMono', fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _reload,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              color: black,
              child: const Text(
                'RETRY',
                style: TextStyle(
                    fontFamily: 'BebasNeue', color: green, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 30,
            letterSpacing: 0.5,
            color: black,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
            child: SizedBox(height: 5, child: ColoredBox(color: black))),
      ],
    );
  }

  Widget _rewardCard(RewardItem r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: black, width: 2),
        boxShadow: const [BoxShadow(color: black, offset: Offset(5, 5))],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.name,
                  style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 22,
                    height: 1.0,
                    letterSpacing: 0.5,
                    color: black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_grouped(r.cost, '.')} PTS',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _redeem(r),
            child: Container(
              decoration: const BoxDecoration(
                color: green,
                boxShadow: [BoxShadow(color: black, offset: Offset(3, 3))],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: const Text(
                'REDEEM',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 22,
                  letterSpacing: 1.0,
                  color: black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
