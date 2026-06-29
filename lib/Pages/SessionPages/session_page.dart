import 'package:flutter/material.dart';
import 'package:fitarena/Pages/SessionPages/explore_all.dart';
import 'package:fitarena/Pages/SessionPages/host_session.dart';
import 'package:fitarena/Pages/SessionPages/join_session_page.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  // Untuk mendeteksi sesi baru yang di-join.
  int _lastCount = SessionStore.instance.mySessions.length;

  @override
  void initState() {
    super.initState();
    SessionStore.instance.addListener(_onStoreChanged);
  }

  // Saat user join sesi baru, otomatis pindah ke tab "My Schedule".
  void _onStoreChanged() {
    final count = SessionStore.instance.mySessions.length;
    if (count > _lastCount && mounted) {
      _tabController.animateTo(0);
    }
    _lastCount = count;
  }

  @override
  void dispose() {
    SessionStore.instance.removeListener(_onStoreChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1E2D6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FIT ARENA',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 36,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: const BoxDecoration(color: Color(0xFF00342B)),
                    child: const Text(
                      'LIVE NOW : BASKETBALL TRAINING\n(42:15)',
                      style: TextStyle(
                        color: Color(0xFFCFE99F),
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRAINING',
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 16,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Text(
                            'SESSIONS',
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 32,
                              height: 1.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HostCategoryPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00342B),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'HOST',
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black26, width: 1.5),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14,
                ),
                indicatorColor: const Color(0xFF00342B),
                indicatorWeight: 3.0,
                tabs: const [
                  Tab(text: 'My Schedule'),
                  Tab(text: 'Explore All'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  MyScheduleTab(),
                  ExploreAllTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyScheduleTab extends StatelessWidget {
  const MyScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Next Session',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),

          // Daftar Next Session — ikut bertambah saat user join sesi baru.
          ListenableBuilder(
            listenable: SessionStore.instance,
            builder: (context, _) {
              final sessions = SessionStore.instance.mySessions;
              return Column(
                children: [
                  for (final s in sessions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildNextSessionCard(context, s),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),

          const Text(
            'Later This Week',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          _buildSmallCard(Icons.sports_basketball, 'BASKETBALL 3X3',
              'Wed, 17.00 Decathlon Alam Sutera'),
          const SizedBox(height: 16),
          _buildSmallCard(Icons.sports_tennis, 'PINGPONG', 'Sat, 19.00 GOR'),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Kartu besar "Next Session" dengan tombol CHECK-IN NOW.
  Widget _buildNextSessionCard(BuildContext context, SessionData session) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: session.imageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 30,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session.scheduleLine,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JoinSessionPage(session: session),
                        ),
                      );
                    },
                    child: Container(
                      width: 220,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(color: Color(0xFFCFE99F)),
                      child: const Text(
                        'CHECK-IN NOW',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.0,
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

  Widget _buildSmallCard(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(color: Colors.black),
            child: Icon(icon, size: 30, color: Colors.white),
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
                    fontSize: 24,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
