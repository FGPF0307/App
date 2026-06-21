import 'package:flutter/material.dart';
import 'package:greengymapp/Pages/SessionPages/session_models.dart';
import 'package:greengymapp/Pages/SessionPages/secure_spot_sheet.dart';

class ExploreAllTab extends StatelessWidget {
  const ExploreAllTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        for (final session in exploreSessions)
          _buildExploreCard(context, session),
      ],
    );
  }

  Widget _buildExploreCard(BuildContext context, SessionData session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Sesi
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: session.imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul & Nomor
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        session.title,
                        style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 28,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Text(
                      session.number,
                      style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Lokasi & Waktu
                Text(
                  '${session.location}   ${session.startTime} ${session.day}',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Spot tersisa & Tombol Join
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${session.spotsFilled} / ${session.spotsTotal} SPOTS\nLEFT',
                      style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 16,
                        height: 1.2,
                        letterSpacing: 1.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showSecureSpotSheet(context, session),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Text(
                          'JOIN',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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
    );
  }
}
