import 'package:flutter/material.dart';

/// Model data satu sesi olahraga. Dipakai bersama oleh Explore All,
/// bottom sheet "Secure My Spot", halaman "Join This Session", dan
/// daftar "Next Session" di My Schedule.
class SessionData {
  final String title;
  final String location;
  final String day; // "Today", "Wed", "Sat"
  final String startTime; // "18.00"
  final String endTime; // "19.30"
  final String image; // path asset atau URL
  final bool isNetwork;
  final String host;
  final int spotsFilled;
  final int spotsTotal;
  final int rewardPoints;
  final int xp;
  final String number; // "01" untuk daftar Explore
  final String? id; // id dari backend (null untuk data statis lokal)

  const SessionData({
    required this.title,
    required this.location,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.image,
    this.isNetwork = true,
    this.host = 'John Greenjim',
    required this.spotsFilled,
    required this.spotsTotal,
    this.rewardPoints = 200,
    this.xp = 300,
    this.number = '',
    this.id,
  });

  int get slotsLeft => spotsTotal - spotsFilled;

  ImageProvider get imageProvider =>
      isNetwork ? NetworkImage(image) : AssetImage(image) as ImageProvider;

  /// "Today, 17.00 Taman Alam Sutera" (subjudul kartu Next Session)
  String get scheduleLine => '$day, $startTime $location';

  /// "Today, 18.00 - 19.30"
  String get timeRange => '$day, $startTime - $endTime';

  // ── Serialisasi JSON (untuk REST API) ──
  factory SessionData.fromJson(Map<String, dynamic> json) => SessionData(
        id: json['id'] as String?,
        title: (json['title'] ?? '') as String,
        location: (json['location'] ?? '') as String,
        day: (json['day'] ?? 'Today') as String,
        startTime: (json['startTime'] ?? '') as String,
        endTime: (json['endTime'] ?? '') as String,
        image: (json['image'] ?? '') as String,
        isNetwork: true,
        host: (json['host'] ?? 'Anonymous') as String,
        spotsFilled: (json['spotsFilled'] as num?)?.toInt() ?? 0,
        spotsTotal: (json['spotsTotal'] as num?)?.toInt() ?? 0,
        rewardPoints: (json['rewardPoints'] as num?)?.toInt() ?? 200,
        xp: (json['xp'] as num?)?.toInt() ?? 300,
        number: (json['number'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'location': location,
        'day': day,
        'startTime': startTime,
        'endTime': endTime,
        'image': image,
        'host': host,
        'spotsFilled': spotsFilled,
        'spotsTotal': spotsTotal,
        'rewardPoints': rewardPoints,
        'xp': xp,
        'number': number,
      };

  /// Sesi "Running" default yang sudah ada di My Schedule sejak awal.
  /// Datanya disamakan dengan kartu "RUNNING (NEXT SESSION)" di Home:
  /// 200 pts, 500 XP, durasi 120 menit (17.00 - 19.00).
  static const SessionData running = SessionData(
    title: 'RUNNING (NEXT SESSION)',
    location: 'Taman Alam Sutera',
    day: 'Today',
    startTime: '17.00',
    endTime: '19.00',
    image: 'assets/images/NextSessionsRunning.jpg',
    isNetwork: false,
    spotsFilled: 4,
    spotsTotal: 8,
    rewardPoints: 200,
    xp: 500,
  );

  /// Sesi "Active Session" di Home (kartu BASKETBALL 3V3 → View Details).
  static const SessionData basketballActive = SessionData(
    title: 'BASKETBALL 3V3',
    location: 'Decathlon Alam Sutera',
    day: 'Today',
    startTime: '17.00',
    endTime: '18.30',
    image:
        'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&w=800&q=80',
    spotsFilled: 4,
    spotsTotal: 6,
    rewardPoints: 200,
    xp: 300,
  );
}

/// Daftar sesi yang muncul di tab "Explore All".
const List<SessionData> exploreSessions = [
  SessionData(
    title: 'MORNING RUN CLUB',
    location: 'IKEA Alam Sutera',
    day: 'Today',
    startTime: '18.00',
    endTime: '19.30',
    image:
        'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?auto=format&fit=crop&q=80',
    spotsFilled: 5,
    spotsTotal: 8,
    rewardPoints: 200,
    xp: 300,
    number: '01',
  ),
  SessionData(
    title: 'SUNDAY TENNIS',
    location: 'Tennis Court',
    day: 'Today',
    startTime: '10.00',
    endTime: '11.30',
    image:
        'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?auto=format&fit=crop&q=80',
    spotsFilled: 3,
    spotsTotal: 6,
    rewardPoints: 150,
    xp: 250,
    number: '02',
  ),
  SessionData(
    title: 'SLOW YOGA',
    location: 'Yoga Station',
    day: 'Today',
    startTime: '15.00',
    endTime: '16.00',
    image:
        'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&q=80',
    spotsFilled: 5,
    spotsTotal: 10,
    rewardPoints: 180,
    xp: 280,
    number: '03',
  ),
];

/// Kategori olahraga untuk alur "Host Session".
class SportCategory {
  final String name; // "BASKETBALL"
  final String emoji; // "🏀"
  final String keyword; // keyword foto (LoremFlickr)

  const SportCategory({
    required this.name,
    required this.emoji,
    required this.keyword,
  });

  /// 8 foto bertema olahraga ini. `lock` membuat hasilnya konsisten
  /// (tidak berubah-ubah tiap render) namun beda satu sama lain.
  List<String> get photos => List.generate(
        8,
        (i) => 'https://loremflickr.com/500/500/$keyword?lock=${i + 1}',
      );
}

const List<SportCategory> hostCategories = [
  SportCategory(name: 'BASKETBALL', emoji: '🏀', keyword: 'basketball'),
  SportCategory(name: 'TENNIS', emoji: '🎾', keyword: 'tennis,court'),
  SportCategory(name: 'FOOTBALL', emoji: '⚽', keyword: 'soccer'),
  SportCategory(name: 'YOGA', emoji: '🧘', keyword: 'yoga'),
  SportCategory(name: 'RUNNING', emoji: '👟', keyword: 'running'),
  SportCategory(name: 'CYCLING', emoji: '🚲', keyword: 'cycling'),
  SportCategory(name: 'BADMINTON', emoji: '🏸', keyword: 'badminton,court'),
  SportCategory(name: 'PADEL', emoji: '🏓', keyword: 'padel,tennis'),
];

/// State terpusat sederhana untuk menyimpan sesi yang sudah di-join user.
/// Begitu user join, daftar ini bertambah dan semua widget yang
/// mendengarkan ([ListenableBuilder]) ikut ter-update.
class SessionStore extends ChangeNotifier {
  SessionStore._();
  static final SessionStore instance = SessionStore._();

  final List<SessionData> _mySessions = [SessionData.running];

  /// Sesi yang tampil di "Next Session" pada My Schedule.
  List<SessionData> get mySessions => List.unmodifiable(_mySessions);

  bool isJoined(SessionData s) => _mySessions.any((e) => e.title == s.title);

  void join(SessionData s) {
    if (isJoined(s)) return;
    _mySessions.add(s);
    notifyListeners();
  }
}
