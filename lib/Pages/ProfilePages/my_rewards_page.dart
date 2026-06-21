import 'package:flutter/material.dart';
import 'package:fitarena/widgets/fit_dialog.dart';

class _Reward {
  final String name; // boleh 2 baris (\n)
  final int cost;
  const _Reward(this.name, this.cost);

  String get oneLine => name.replaceAll('\n', ' ');
}

class MyRewardsPage extends StatefulWidget {
  const MyRewardsPage({super.key});

  @override
  State<MyRewardsPage> createState() => _MyRewardsPageState();
}

class _MyRewardsPageState extends State<MyRewardsPage> {
  static const Color cream = Color(0xFFE1E2D6);
  static const Color green = Color(0xFFCFE99F);
  static const Color black = Color(0xFF111111);

  int _points = 2450;

  static const List<_Reward> _vouchers = [
    _Reward('NIKE -20% OFF\nRUNNING SHOES', 100000),
    _Reward('ADIDAS -10% OFF\nRUNNING SHOES', 100000),
    _Reward('PUMA -5% OFF\nRUNNING SHOES', 100000),
  ];

  static const List<_Reward> _nutritions = [
    _Reward('MILK\n(100 ML)', 20000),
    _Reward('ISOTONIC DRINK\n(500 ML)', 35000),
    _Reward('MINERAL WATER\n(500 ML)', 10000),
  ];

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

  Future<void> _redeem(_Reward r) async {
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
              // ── HEADER ──
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
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/profile/JohnGreenjim.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── POINTS WALLET ──
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

              _sectionHeader('BRAND VOUCHERS'),
              const SizedBox(height: 16),
              for (final r in _vouchers) _rewardCard(r),

              const SizedBox(height: 16),
              _sectionHeader('NUTRITIONS & HYDRATIONS'),
              const SizedBox(height: 16),
              for (final r in _nutritions) _rewardCard(r),
            ],
          ),
        ),
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
        const Expanded(child: SizedBox(height: 5, child: ColoredBox(color: black))),
      ],
    );
  }

  Widget _rewardCard(_Reward r) {
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
