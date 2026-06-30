import 'package:flutter/material.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';
import 'package:fitarena/Pages/SessionPages/secure_spot_sheet.dart';
import 'package:fitarena/services/session_api.dart';

class ExploreAllTab extends StatefulWidget {
  const ExploreAllTab({super.key});

  @override
  State<ExploreAllTab> createState() => _ExploreAllTabState();
}

class _ExploreAllTabState extends State<ExploreAllTab> {
  late Future<List<SessionData>> _future;

  @override
  void initState() {
    super.initState();
    _future = SessionApi.fetchSessions();
  }

  void _reload() {
    setState(() => _future = SessionApi.fetchSessions());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SessionData>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00342B)),
          );
        }
        if (snapshot.hasError) {
          return _ErrorView(
            message: snapshot.error.toString(),
            onRetry: _reload,
          );
        }
        final sessions = snapshot.data ?? const <SessionData>[];
        if (sessions.isEmpty) {
          return _EmptyView(onRefresh: _reload);
        }
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              for (final session in sessions) _buildExploreCard(context, session),
            ],
          ),
        );
      },
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

/// Tampilan saat gagal memuat dari API (mis. backend belum jalan).
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.black45),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat sesi',
              style: TextStyle(fontFamily: 'BebasNeue', fontSize: 24),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pastikan backend berjalan:\ncd backend  →  npm run dev',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: Colors.black38,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                color: const Color(0xFF111111),
                child: const Text(
                  'RETRY',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    color: Color(0xFFCFE99F),
                    fontSize: 20,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Belum ada sesi.',
            style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onRefresh,
            child: const Text(
              'Muat ulang',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
