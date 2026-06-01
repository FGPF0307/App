import 'package:flutter/material.dart';

class ExploreAllTab extends StatelessWidget {
  const ExploreAllTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildExploreCard(
          imageUrl: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?auto=format&fit=crop&q=80',
          title: 'MORNING RUN CLUB',
          number: '01',
          location: 'Ikea Alam Sutera',
          time: '18.00 Today',
          spots: '5 / 8',
        ),
        _buildExploreCard(
          imageUrl: 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?auto=format&fit=crop&q=80',
          title: 'SUNDAY TENNIS',
          number: '02',
          location: 'Tennis Court',
          time: '10.00 Today',
          spots: '3 / 6',
        ),
        _buildExploreCard(
          imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&q=80',
          title: 'SLOW YOGA',
          number: '03',
          location: 'Yoga Station',
          time: '15.00 Today',
          spots: '5 / 10',
        ),
      ],
    );
  }

  Widget _buildExploreCard({
    required String imageUrl,
    required String title,
    required String number,
    required String location,
    required String time,
    required String spots,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
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
                image: NetworkImage(imageUrl),
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 28,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      number,
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
                  '$location   $time',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$spots SPOTS\nLEFT',
                          style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 16,
                            height: 1.2,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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