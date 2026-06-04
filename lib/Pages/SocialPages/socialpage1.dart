import 'package:flutter/material.dart';
import 'socialpage2.dart'; 
import 'socialpage3.dart'; // Memastikan rute ke halaman daftar pesan aktif
import 'socialpage5.dart'; // Memastikan rute ke chatroom personal aktif

class Socialpage1 extends StatefulWidget {
  const Socialpage1({Key? key}) : super(key: key);

  @override
  State<Socialpage1> createState() => _Socialpage1State();
}

class _Socialpage1State extends State<Socialpage1> {
  // Variabel warna tema
  static const Color creamBg = Color(0xFFE1DCD3);
  static const Color darkGreen = Color(0xFF043927);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. SECTION: COMMUNITY (LOCAL LEGEND)
              // ==========================================
              _buildSectionTitle('COMMUNITY'),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: darkGreen,
                  border: Border.all(color: const Color(0xFF00A2E8), width: 3),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 140,
                        height: 140,
                        color: Colors.grey[400],
                        child: Image.network(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Current Local Legend',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'JOHN GREENJIM',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        color: Colors.white,
                        fontSize: 32,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF00A2E8),
                          width: 1.5,
                        ),
                      ),
                      child: const Text(
                        'LVL 24',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Dominating : Taman Alam Sutera\n58 Days Streak',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ==========================================
              // 2. SECTION: ACTIVE SESSION HUB
              // ==========================================
              _buildSectionTitle('ACTIVE SESSION HUB'),
              const SizedBox(height: 10),
              _buildActiveSessionCard(
                number: '01',
                title: 'MORNING RUN CLUB',
                location: 'IKEA Alam Sutera',
                time: '18.00',
                slotsLeft: '3 slots left',
              ),
              _buildActiveSessionCard(
                number: '02',
                title: 'SUNDAY TENNIS',
                location: 'Tenis Court',
                time: '10.00',
                slotsLeft: '3 slots left',
              ),
              _buildActiveSessionCard(
                number: '03',
                title: 'SLOW YOGA',
                location: 'Yoga Station',
                time: '15.00',
                slotsLeft: '5 slots left',
              ),

              const SizedBox(height: 24),

              // ==========================================
              // 3. SECTION: SPORT COMMUNITIES
              // ==========================================
              _buildSectionTitleWithSeeAll(
                'SPORT COMMUNITIES',
                onSeeAllTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Socialpage2(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildCommunityChatCard(
                title: 'BASKET SWEAT CLUB',
                members: '20 Members',
                lastMessage: '“where are you guys right now??....“',
                imageUrl:
                    'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=100',
              ),
              _buildCommunityChatCard(
                title: 'RUNNER CLUB',
                members: '28 Members',
                lastMessage: '“Are we going to run right now??....“',
                imageUrl:
                    'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=100',
              ),

              const SizedBox(height: 24),

              // ==========================================
              // 4. SECTION: BUDDY MESSAGES
              // ==========================================
              _buildSectionTitleWithSeeAll(
                'BUDDY MESSAGES',
                onSeeAllTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Socialpage3(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildBuddyMessageCard(
                name: 'RAKA ARKADIAN',
                time: '14.30',
                message:
                    'Ready for the 16.00 run?...i’m already in the bus station',
                imageUrl:
                    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
                onCardTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Socialpage5(),
                      settings: const RouteSettings(arguments: 'RAKA ARKADIAN'),
                    ),
                  );
                },
              ),
              _buildBuddyMessageCard(
                name: 'OLIVER MARTINEZ',
                time: 'Yesterday',
                message: 'That was a killer HIIT session. My quads are dead.',
                imageUrl:
                    'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100',
                onCardTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Socialpage5(),
                      settings: const RouteSettings(arguments: 'OLIVER MARTINEZ'),
                    ),
                  );
                },
              ),
              _buildBuddyMessageCard(
                name: 'DANENDRA J.',
                time: '10.00',
                message:
                    'How do i get the Local Legend Badge for Decathlon Alam Sutera?...',
                imageUrl:
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                onCardTap: () {
                  // PERBAIKAN: Mengisi kode yang terputus dan mengarahkannya ke rute Socialpage5 secara aman
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Socialpage5(),
                      settings: const RouteSettings(arguments: 'DANENDRA J.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'BebasNeue',
        fontSize: 26,
        letterSpacing: 1.0,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSectionTitleWithSeeAll(
    String title, {
    VoidCallback? onSeeAllTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 26,
              letterSpacing: 1.0,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSeeAllTap,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                'See All',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard({
    required String number,
    required String title,
    required String location,
    required String time,
    required String slotsLeft,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 36,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '• $time',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Text(
                      'Today ',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '• $slotsLeft',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 100,
                    height: 28,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'JOIN',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityChatCard({
    required String title,
    required String members,
    required String lastMessage,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 18),
              ),
              Text(
                members,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imageUrl,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.group, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lastMessage,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(100, 28),
              ),
              onPressed: () {},
              child: const Text(
                'Open Chat',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyMessageCard({
    required String name,
    required String time,
    required String message,
    required String imageUrl,
    VoidCallback? onCardTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onCardTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}