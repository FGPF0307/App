import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fitarena/Pages/HomePages/homepage.dart' show currentUserName;
import 'package:fitarena/Pages/SessionPages/session_models.dart';
import 'package:fitarena/Pages/SessionPages/join_session_page.dart';
import 'package:fitarena/services/session_api.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  // Titik pusat awal: Area Alam Sutera (mendekati Decathlon)
  final LatLng _initialCenter = const LatLng(-6.2246, 106.6531);
  final MapController _mapController = MapController();

  void _showSessionDetails(BuildContext context, SessionData session) {
    const Color darkCharcoal = Color(0xFF0F110F);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.title,
                style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 44,
                  height: 0.95,
                  color: darkCharcoal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                session.location.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  letterSpacing: 1.0,
                  color: darkCharcoal,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.black, thickness: 1),
              _detailRow('HOST', session.host.toUpperCase()),
              const Divider(color: Colors.black, thickness: 1),
              _detailRow(
                  'SPOTS', '${session.slotsLeft} / ${session.spotsTotal} LEFT'),
              const Divider(color: Colors.black, thickness: 1),
              _detailRow('TIME', '${session.startTime} - ${session.endTime}'),
              const SizedBox(height: 24),

              // TOMBOL CHECK DETAILS → halaman Join This Session
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkCharcoal,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JoinSessionPage(session: session),
                      ),
                    );
                  },
                  child: const Text(
                    'CHECK DETAILS',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 30,
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              letterSpacing: 1.5,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 26,
                color: Color(0xFF0F110F),
              ),
            ),
          ),
        ],
      ),
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
            Container(
              color: creamBg,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HELLO,\n${currentUserName()}',
                        style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 36, height: 0.9, color: darkCharcoal),
                      ),
                      const CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage('assets/images/profile_dummy.jpg'), // Path foto lo
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
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
                  
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _initialCenter,
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () async {
                            // Ambil sesi dari REST API; fallback ke data lokal
                            // bila backend tidak aktif.
                            SessionData session;
                            try {
                              final list = await SessionApi.fetchSessions();
                              session = list.isNotEmpty
                                  ? list.first
                                  : exploreSessions.first;
                            } catch (_) {
                              session = exploreSessions.first;
                            }
                            if (!context.mounted) return;
                            _showSessionDetails(context, session);
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