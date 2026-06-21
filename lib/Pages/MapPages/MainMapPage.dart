import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  // Titik pusat awal: Area Alam Sutera (mendekati Decathlon)
  final LatLng _initialCenter = const LatLng(-6.2246, 106.6531);
  final MapController _mapController = MapController();

  // ─── FUNGSI TRIGGER BOTTOM SHEET ───
  void _showLocationDetails(BuildContext context) {
    const Color darkCharcoal = Color(0xFF0F110F);
    const Color lightGreen = Color(0xFFCEE5A4);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Transparan agar bisa mengatur sudut melengkung manual
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. JUDUL LOKASI
              const Text(
                'DECATHLON\nALAM SUTERA',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 48,
                  height: 0.9,
                  color: darkCharcoal,
                ),
              ),
              const SizedBox(height: 16),

              // 2. KOTAK KEPADATAN (CROWD DENSITY)
              Container(
                color: lightGreen,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('CROWD DENSITY', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, letterSpacing: 1.5, color: darkCharcoal)),
                    SizedBox(height: 4),
                    Text('LOW', style: TextStyle(fontFamily: 'BebasNeue', fontSize: 24, color: darkCharcoal)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 16),

              // 3. LOCAL LEGEND
              const Text('CURRENT LOCAL LEGEND', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, letterSpacing: 1.5, color: darkCharcoal)),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 24.0), // Indentasi nama
                child: Text('FARREL GANENDRA', style: TextStyle(fontFamily: 'BebasNeue', fontSize: 28, color: darkCharcoal)),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.black, thickness: 1),
              const SizedBox(height: 16),

              // 4. ACTIVE TIME
              const Text('ACTIVE TIME', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, letterSpacing: 1.5, color: darkCharcoal)),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 24.0),
                child: Text('08.00 - 22.00', style: TextStyle(fontFamily: 'BebasNeue', fontSize: 28, color: darkCharcoal)),
              ),
              const SizedBox(height: 32),

              // 5. TOMBOL CHECK DETAILS
              SizedBox(
                width: double.infinity,
                height: 70, // Tombol tinggi besar kaku
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightGreen,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Sudut tajam
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Logika masuk ke halaman detail
                    Navigator.pop(context); // Menutup bottom sheet
                  },
                  child: const Text(
                    'CHECK DETAILS',
                    style: TextStyle(fontFamily: 'BebasNeue', fontSize: 32, color: darkCharcoal),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color creamBg = Color(0xFFE1DCD3);
    const Color darkCharcoal = Color(0xFF0F110F);

    return Scaffold(
      backgroundColor: creamBg,
      body: SafeArea(
        bottom: false, // Membiarkan peta menyentuh batas bawah layar
        child: Column(
          children: [
            // ─── BAGIAN 1: HEADER & SEARCH BAR KUSTOM ───
            Container(
              color: creamBg,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HELLO,\nFARREL GANENDRA',
                        style: TextStyle(fontFamily: 'BebasNeue', fontSize: 36, height: 0.9, color: darkCharcoal),
                      ),
                      const CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage('assets/images/profile_dummy.jpg'), // Path foto lo
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Kotak Pencarian (Search Bar) Putih Polos
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    // Jika butuh input teks, ganti child ini dengan TextField
                    child: const SizedBox.shrink(), 
                  ),
                ],
              ),
            ),

            // ─── BAGIAN 2: MESIN PETA OPENSTREETMAP ───
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _initialCenter,
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.fitarena.app',
                  ),
                  
                  // Titik Lokasi
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _initialCenter,
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            // Saat pin merah diklik, Bottom Sheet akan muncul
                            _showLocationDetails(context);
                          },
                          child: const Icon(
                            Icons.location_on, // Menggunakan pin merah standar map
                            color: Color(0xFFD32F2F),
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}