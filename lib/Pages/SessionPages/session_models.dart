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
  final List<String> photoIds; // ID foto Unsplash terkurasi (estetik, negative space)

  const SportCategory({
    required this.name,
    required this.emoji,
    required this.photoIds,
  });

  /// Foto pilihan bertema olahraga ini (Unsplash, komposisi bersih).
  List<String> get photos => photoIds
      .map((id) =>
          'https://images.unsplash.com/photo-$id?w=800&q=80&auto=format&fit=crop')
      .toList();
}

/// 10 foto per olahraga (Unsplash, kata kunci "minimal/aesthetic" untuk
/// komposisi bersih & banyak negative space). Semua diverifikasi HTTP 200.
const List<SportCategory> hostCategories = [
  SportCategory(name: 'BASKETBALL', emoji: '🏀', photoIds: [
    '1667406600896-0e35082f84e9',
    '1598658149962-737f5196b388',
    '1519339859931-96ff5c81fbe6',
    '1629213776339-53609f483639',
    '1780039319910-3aaf210c9f05',
    '1757771460100-8afb64500e1a',
    '1618185663342-c66c72b454df',
    '1572004894563-5a657de7e580',
    '1676372979745-a2926753fa46',
    '1643493485012-42835dbd4eef',
  ]),
  SportCategory(name: 'TENNIS', emoji: '🎾', photoIds: [
    '1573112625042-e49d6b28c538',
    '1620983941458-0de493240024',
    '1581167679522-78a41a28e8a3',
    '1720751031474-4e8793be9bcb',
    '1774532665451-eff4bcd879e0',
    '1537426436452-fecb62e5c631',
    '1710782914858-9324a4c09c4a',
    '1780516492137-94e4cf3488f7',
    '1572380518565-c172b00aacdf',
    '1582699669911-89db9ff0d67f',
  ]),
  SportCategory(name: 'FOOTBALL', emoji: '⚽', photoIds: [
    '1606925797300-0b35e9d1794e',
    '1668068872931-b2349bb82e86',
    '1511204338744-5d4e9b3ffee0',
    '1625187538367-6a8483a79cc2',
    '1490696809909-71f5f1fd23e5',
    '1668068873075-cf3e9925eae4',
    '1671998804545-5a8a93fe8a28',
    '1617347914136-9274023f8812',
    '1760885984948-c8af6359b7f6',
    '1625923541779-630119dfa15d',
  ]),
  SportCategory(name: 'YOGA', emoji: '🧘', photoIds: [
    '1657584942205-c34fec47404d',
    '1667644232315-990bd233356b',
    '1664890972249-d32303e0502b',
    '1701824429213-97fa38e76467',
    '1724833798548-2b5af67952dd',
    '1544367769-cde535ef322a',
    '1485727749690-d091e8284ef3',
    '1667644232389-73c1c9c0dc9d',
    '1579804234303-30797fe9c837',
    '1535622059989-f0a821a938f7',
  ]),
  SportCategory(name: 'RUNNING', emoji: '👟', photoIds: [
    '1560441546-28bcc9c36ae1',
    '1690961873954-af29ee0cb416',
    '1725658661781-92897d115865',
    '1551747777-8c04191a26e2',
    '1557766671-b21f9097a446',
    '1778937334129-055593449075',
    '1705585851308-1b1080ba0144',
    '1662828359556-e5d28aa95285',
    '1609601241542-f0a4f70b531a',
    '1667594522176-1e2ccf0af199',
  ]),
  SportCategory(name: 'CYCLING', emoji: '🚲', photoIds: [
    '1653843992088-8392fb216459',
    '1696017953177-648da8dcf585',
    '1649247564949-3af100736144',
    '1652870561704-4f3db9874e70',
    '1579057985826-38ecf064cab0',
    '1673890634087-a4fb7f4faf72',
    '1782201666827-1462bcd569e0',
    '1675868014504-9b9da8aa531a',
    '1631211332436-13549bb3f2f5',
    '1679233767426-713ca299cd0a',
  ]),
  SportCategory(name: 'BADMINTON', emoji: '🏸', photoIds: [
    '1723238216932-afa868d31253',
    '1581167679522-78a41a28e8a3',
    '1631362252544-af4a99cf037e',
    '1703533136832-2e91ef1a746f',
    '1710440009286-9aa146421df1',
    '1760085099136-6cbd765ea718',
    '1641757625075-d018760a4fb5',
    '1533124436425-a9c6f384f199',
    '1573112625042-e49d6b28c538',
    '1647686897464-556f132efe4a',
  ]),
  SportCategory(name: 'PADEL', emoji: '🏓', photoIds: [
    '1731345200818-9dd0a5f2c4d2',
    '1700750368493-c8068fe41241',
    '1617348523950-66b425e5c66b',
    '1585674550411-3f7eed56b3e7',
    '1469817805249-72b7df1c3c05',
    '1705258814344-47bd74ce6998',
    '1552210812-bd3126f8870d',
    '1639569457486-7a8a32f29d82',
    '1725655469137-66ab8fac7455',
    '1639863764945-b626220d3d50',
  ]),
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
