import 'package:flutter/material.dart';

/// Logo FitArena. Memakai file gambar asli di [assetPath]; bila file belum
/// tersedia, otomatis fallback ke versi vektor (digambar) agar app tidak rusak.
class FitArenaLogo extends StatelessWidget {
  final double size;
  final Color markColor;
  final Color barColor;

  /// Path aset logo asli (PNG transparan / berlatar terang).
  static const String assetPath = 'assets/icon/fitarena_logo.png';

  const FitArenaLogo({
    super.key,
    this.size = 120,
    this.markColor = const Color(0xFF111111),
    this.barColor = const Color(0xFFC5E89E),
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      // Fallback bila file logo belum ditambahkan ke assets/icon/.
      errorBuilder: (context, error, stack) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _LogoPainter(markColor, barColor)),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color markColor;
  final Color barColor;
  _LogoPainter(this.markColor, this.barColor);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final mark = Paint()
      ..color = markColor
      ..isAntiAlias = true;
    final bar = Paint()
      ..color = barColor
      ..isAntiAlias = true;

    Offset p(double fx, double fy) => Offset(fx * s, fy * s);

    final path = Path()
      ..moveTo(p(0.5, 0.30).dx, p(0.5, 0.30).dy)
      ..lineTo(p(0.19, 0.82).dx, p(0.19, 0.82).dy)
      ..lineTo(p(0.81, 0.82).dx, p(0.81, 0.82).dy)
      ..close()
      ..moveTo(p(0.5, 0.50).dx, p(0.5, 0.50).dy)
      ..lineTo(p(0.405, 0.82).dx, p(0.405, 0.82).dy)
      ..lineTo(p(0.595, 0.82).dx, p(0.595, 0.82).dy)
      ..close();
    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, mark);

    canvas.drawRect(
      Rect.fromLTRB(0.445 * s, 0.255 * s, 0.555 * s, 0.305 * s),
      mark,
    );
    canvas.drawRect(
      Rect.fromLTRB(0.32 * s, 0.595 * s, 0.68 * s, 0.638 * s),
      bar,
    );
  }

  @override
  bool shouldRepaint(covariant _LogoPainter old) =>
      old.markColor != markColor || old.barColor != barColor;
}
