import 'package:flutter/material.dart';
import 'package:fitarena/Pages/HomePages/homepage.dart' show currentUserName;
import 'communities_page.dart';
import 'buddy_messages_page.dart';
import 'chat_room_page.dart';
import 'community_store.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';
import 'package:fitarena/Pages/SessionPages/join_session_page.dart';
import 'package:fitarena/services/session_api.dart';

class SocialHubPage extends StatefulWidget {
  const SocialHubPage({super.key});

  @override
  State<SocialHubPage> createState() => _SocialHubPageState();
}

class _SocialHubPageState extends State<SocialHubPage> {
  // Variabel warna tema
  static const Color creamBg = Color(0xFFE1DCD3);
  static const Color darkGreen = Color(0xFF043927);

  late Future<List<SessionData>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = SessionApi.fetchSessions();
    CommunityStore.instance.load();
  }

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
                    Text(
                      currentUserName(),
                      style: const TextStyle(
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
              // Data diambil dari REST API (backend). JOIN membawa ke halaman
              // detail "Join This Session".
              FutureBuilder<List<SessionData>>(
                future: _sessionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(color: darkGreen),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return _buildHubError();
                  }
                  final sessions = snapshot.data ?? const <SessionData>[];
                  if (sessions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Belum ada sesi aktif.',
                        style:
                            TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final s in sessions)
                        _buildActiveSessionCard(
                          session: s,
                          onJoin: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JoinSessionPage(session: s),
                            ),
                          ),
                        ),
                    ],
                  );
                },
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
                      builder: (context) => const CommunitiesPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              // Daftar reaktif — bertambah otomatis saat user join sebuah sesi.
              AnimatedBuilder(
                animation: CommunityStore.instance,
                builder: (context, _) {
                  final store = CommunityStore.instance;
                  if (store.loading && store.communities.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(color: darkGreen),
                      ),
                    );
                  }
                  if (store.communities.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Belum ada komunitas.',
                        style:
                            TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final c in store.communities)
                        _buildCommunityChatCard(
                          community: c,
                          onOpenChat: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatRoomPage.group(c),
                            ),
                          ),
                        ),
                    ],
                  );
                },
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
                      builder: (context) => const BuddyMessagesPage(),
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
                      builder: (context) => ChatRoomPage.personal('RAKA ARKADIAN'),
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
                      builder: (context) => ChatRoomPage.personal('OLIVER MARTINEZ'),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomPage.personal('DANENDRA J.'),
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

  Widget _buildHubError() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Gagal memuat sesi dari server.',
            style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text(
            'Jalankan backend: cd backend → npm run dev',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'JetBrainsMono', fontSize: 10, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () =>
                setState(() => _sessionsFuture = SessionApi.fetchSessions()),
            child: const Text(
              'RETRY',
              style: TextStyle(
                  fontFamily: 'BebasNeue', fontSize: 18, color: darkGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard({
    required SessionData session,
    required VoidCallback onJoin,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.number,
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
                  session.title,
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
                      session.location,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '• ${session.startTime}',
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
                    Text(
                      '${session.day} ',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '• ${session.slotsLeft} slots left',
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
                      onPressed: onJoin,
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
    required CommunityData community,
    required VoidCallback onOpenChat,
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
              Expanded(
                child: Text(
                  community.title,
                  style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 18),
                ),
              ),
              Text(
                community.members,
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
                child: communityImage(community.imageUrl,
                    width: 44, height: 44),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  community.lastMessage,
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
              onPressed: onOpenChat,
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