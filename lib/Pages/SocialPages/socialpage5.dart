import 'package:flutter/material.dart';

class Socialpage5 extends StatefulWidget {
  const Socialpage5({Key? key}) : super(key: key);

  @override
  State<Socialpage5> createState() => _Socialpage5State();
}

class _Socialpage5State extends State<Socialpage5> {
  // Warna background sesuai tema Figma
  static const Color figmaBg = Color(0xFFE2E1D6);
  static const Color figmaGreen = Color(0xFF043927);
  static const Color figmaOrange = Color(0xFF8B5A2B);

  final TextEditingController _transcriptController = TextEditingController();

  @override
  void dispose() {
    _transcriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menangkap data lemparan dari halaman sebelumnya
    final args = ModalRoute.of(context)?.settings.arguments;
    final String activeUserName = (args is String) ? args : 'DANENDRA J.';

    return Scaffold(
      backgroundColor: figmaBg,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // HEADER CUSTOM SESUAI FIGMA
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 4.0, right: 8.0),
                      child: Text(
                        '<',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeUserName.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 32,
                            letterSpacing: 0.5,
                            color: Colors.black,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              '● ',
                              style: TextStyle(fontSize: 10, color: Colors.black),
                            ),
                            Expanded(
                              child: Text(
                                'Currently training at decathlon alam sutera',
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 10,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Foto Profil Kanan Atas
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey, width: 56, height: 56, child: const Icon(Icons.person)),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // AREA CHAT LIST
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    
                    // Badge Pemisah 'TODAY'
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'TODAY',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 14,
                          letterSpacing: 1.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pesan Masuk (Kiri)
                    _buildLeftMessage(
                      text: 'Hey! just finished the first set heavy back squats. are you still coming for the run session at 7?',
                      time: '15.10 PM',
                    ),
                    
                    const SizedBox(height: 24),

                    // Pesan Keluar (Kanan)
                    _buildRightMessage(
                      text: "i'll definitely be there",
                      time: '15.12 PM',
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // INPUT BAR: WRITE TRANSCRIPT
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 54,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      color: Colors.black54,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _transcriptController,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Write Transcript',
                          hintStyle: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            color: Colors.black38,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.black87),
                      onPressed: () {
                        if (_transcriptController.text.trim().isNotEmpty) {
                          _transcriptController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Pesan Masuk (Garis Hijau di Kiri)
  Widget _buildLeftMessage({required String text, required String time}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Garis Vertikal Hijau Tebal Khas Figma
                Container(
                  width: 4,
                  height: 64, // Menyesuaikan tinggi blok teks perkiraan
                  color: figmaGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 13,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                time,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Pesan Keluar (Garis Cokelat di Kanan & Teks Rata Kanan)
  Widget _buildRightMessage({required String text, required String time}) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 13,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Garis Vertikal Cokelat Tebal Khas Figma
                Container(
                  width: 4,
                  height: 32,
                  color: figmaOrange,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                time,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}