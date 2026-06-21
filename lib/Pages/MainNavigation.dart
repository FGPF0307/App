import 'package:flutter/material.dart';
import 'package:greengymapp/Pages/HomePages/homepage.dart';
import 'package:greengymapp/Pages/MapPages/MainMapPage.dart';
import 'package:greengymapp/Pages/SessionPages/SessionPage1.dart';
import 'package:greengymapp/Pages/SocialPages/socialpage1.dart';
import 'package:greengymapp/Pages/ProfilePages/profilePage.dart';

/// Kerangka utama aplikasi: menampung 5 halaman + bottom navigation bar
/// custom dengan lingkaran hitam yang "menggeser" ke tab yang aktif.
class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex = widget.initialIndex;

  // Halaman tiap tab — URUTAN HARUS SAMA dengan _items di bawah.
  final List<Widget> _pages = const [
    FitnessDashboardPage(), // Home
    MainMapScreen(), // Map
    SessionPage(), // Session
    Socialpage1(), // Social
    ProfilePage(), // Profile
  ];

  // Ikon + label tiap tab.
  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.map_rounded, label: 'Map'),
    _NavItem(icon: Icons.bolt, label: 'Session'),
    _NavItem(icon: Icons.forum_rounded, label: 'Social'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  void _onTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1DCD3),
      // IndexedStack menjaga state tiap halaman tetap hidup saat berpindah tab
      // (posisi scroll, controller peta, dll. tidak hilang).
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: _currentIndex,
        items: _items,
        onTap: _onTap,
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  static const Color barColor = Color(0xFFE1E3D6); // warna bar
  static const Color circleColor = Color(0xFF0F110F); // lingkaran hitam
  static const double _poke = 29; // seberapa tinggi lingkaran naik di atas bar
  static const double _barHeight = 64; // tinggi bar
  static const double _circleSize = 58; // diameter lingkaran
  static const double _iconSize = 26;
  static const Duration duration = Duration(milliseconds: 350);
  static const Curve _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: _poke + _barHeight + bottomInset,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slotWidth = constraints.maxWidth / items.length;
          final circleLeft =
              slotWidth * currentIndex + (slotWidth - _circleSize) / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // 1) Bar berwarna (memanjang sampai area aman bawah)
              Positioned(
                top: _poke,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(color: barColor),
              ),

              // 2) Baris item: ikon hitam (saat tidak aktif) + label (saat aktif)
              Positioned(
                top: _poke,
                left: 0,
                right: 0,
                height: _barHeight,
                child: Row(
                  children: List.generate(items.length, (i) {
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTap(i),
                        child: _NavSlot(
                          item: items[i],
                          selected: i == currentIndex,
                          iconSize: _iconSize,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // 3) Lingkaran hitam yang MENGGESER ke tab aktif, ikon putih
              //    di dalamnya ikut berganti dengan animasi crossfade.
              AnimatedPositioned(
                duration: duration,
                curve: _curve,
                top: 0,
                left: circleLeft,
                width: _circleSize,
                height: _circleSize,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: duration,
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Icon(
                      items[currentIndex].icon,
                      key: ValueKey<int>(currentIndex),
                      color: Colors.white,
                      size: _iconSize,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavSlot extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final double iconSize;

  const _NavSlot({
    required this.item,
    required this.selected,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ikon hitam di tengah — disembunyikan saat aktif karena sudah
        // diwakili oleh lingkaran + ikon putih di atasnya.
        Center(
          child: AnimatedOpacity(
            duration: _FloatingNavBar.duration,
            opacity: selected ? 0 : 1,
            child: Icon(
              item.icon,
              color: _FloatingNavBar.circleColor,
              size: iconSize,
            ),
          ),
        ),
        // Label di bawah — hanya muncul saat tab aktif.
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: AnimatedOpacity(
              duration: _FloatingNavBar.duration,
              opacity: selected ? 1 : 0,
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _FloatingNavBar.circleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
