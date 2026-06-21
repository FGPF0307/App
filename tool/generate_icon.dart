// Generator launcher icon FitArena.
// Jalankan: dart run tool/generate_icon.dart
//
// Menggambar logo "A" pada kanvas besar (supersample) lalu memperkecil ke
// 1024px agar tepinya halus (anti-alias), disimpan ke assets/icon/.

import 'dart:io';
import 'package:image/image.dart' as img;

const int base = 4096; // kanvas supersample
const int out = 1024; // ukuran akhir

void main() {
  Directory('assets/icon').createSync(recursive: true);

  final image = img.Image(width: base, height: base, numChannels: 4);

  // Warna
  final bg = img.ColorRgb8(245, 245, 245);
  final black = img.ColorRgb8(17, 17, 17);
  final green = img.ColorRgb8(197, 232, 158);

  img.fill(image, color: bg);

  img.Point p(double fx, double fy) =>
      img.Point(fx * base, fy * base);

  // Segitiga luar "A" (hitam)
  img.fillPolygon(
    image,
    vertices: [p(0.5, 0.30), p(0.19, 0.82), p(0.81, 0.82)],
    color: black,
  );
  // Lubang dalam (diisi warna background → membentuk dua kaki)
  img.fillPolygon(
    image,
    vertices: [p(0.5, 0.50), p(0.405, 0.82), p(0.595, 0.82)],
    color: bg,
  );

  // Topi kecil di puncak
  img.fillRect(
    image,
    x1: (0.445 * base).round(),
    y1: (0.255 * base).round(),
    x2: (0.555 * base).round(),
    y2: (0.305 * base).round(),
    color: black,
  );

  // Palang hijau muda melintang
  img.fillRect(
    image,
    x1: (0.32 * base).round(),
    y1: (0.595 * base).round(),
    x2: (0.68 * base).round(),
    y2: (0.638 * base).round(),
    color: green,
  );

  final resized = img.copyResize(
    image,
    width: out,
    height: out,
    interpolation: img.Interpolation.average,
  );

  File('assets/icon/fitarena_icon.png')
      .writeAsBytesSync(img.encodePng(resized));

  stdout.writeln('OK: assets/icon/fitarena_icon.png (${out}x$out)');
}
