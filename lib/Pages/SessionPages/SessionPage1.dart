import 'package:flutter/material.dart';
import 'package:greengymapp/Pages/SessionPages/ExploreAll.dart';
import 'package:greengymapp/Pages/SessionPages/HostSession.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        backgroundColor: const Color(0xFFE1E2D6),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GREENGYM',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 36,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16), // Jarak disesuaikan

                    // Banner Live Now
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                                builder: (context) => const HostSessionPage(),
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

              // -Tab Bar My Schedule & Explore All
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black26, width: 1.5),
                  ),
                ),
                child: const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                  ),
                  indicatorColor: Color(0xFF00342B),
                  indicatorWeight: 3.0,
                  tabs: [
                    Tab(text: 'My Schedule'),
                    Tab(text: 'Explore All'),
                  ],
                ),
              ),

              // TabBar View
              Expanded(
                child: TabBarView(
                  children: [
                    const MyScheduleTab(),
                    const ExploreAllTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget My Schedule
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
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/NextSessionsRunning.jpg'),
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
                      const Text(
                        'RUNNING (NEXT SESSION)',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 30,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Today, 17.00 Taman Alam\nSutera',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Center(
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          const Text(
            'Later This Week',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          _buildSmallCard(Icons.sports_basketball, 'BASKETBALL 3X3', 'Wed, 17.00 Decathlon Alam Sutera'),
          const SizedBox(height: 16),
          _buildSmallCard(Icons.sports_tennis, 'PINGPONG', 'Sat, 19.00 GOR'),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSmallCard(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFDCDDDB),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Icon(icon, size: 30, color: Colors.black),
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