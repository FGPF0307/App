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
  final List<String> photoIds;

  const SportCategory({
    required this.name,
    required this.emoji,
    required this.photoIds,
  });

  /// Dilewatkan via proxy wsrv.nl agar foto (mis. Pinterest) memiliki header
  /// CORS, sehingga tetap tampil di Flutter Web (CanvasKit). Di mobile juga OK.
  List<String> get photos => photoIds
      .map((u) =>
          'https://wsrv.nl/?url=${Uri.encodeComponent(u)}&w=800&q=80&output=jpg')
      .toList();
}

/// 10 foto pilihan per olahraga untuk alur Host Session.
const List<SportCategory> hostCategories = [
  SportCategory(name: 'BASKETBALL', emoji: '🏀', photoIds: [
    'https://i.pinimg.com/1200x/97/fc/89/97fc89e187ba8e2ead3fe45d89675a9f.jpg',
    'https://i.pinimg.com/736x/0a/a5/fa/0aa5fad8870371ab0633b0e16a6d806f.jpg',
    'https://i.pinimg.com/736x/5f/7c/7e/5f7c7e22e632179c022c68a9c128bdaf.jpg',
    'https://i.pinimg.com/736x/48/a4/da/48a4dafadffcb642ad419bc2726ad9f7.jpg',
    'https://i.pinimg.com/736x/a9/ad/1b/a9ad1bef9326fe1fb6b1814cf6a096c3.jpg',
    'https://i.pinimg.com/1200x/f8/31/ef/f831ef59ef279cff674c8f09e51e0d8c.jpg',
    'https://i.pinimg.com/736x/04/f7/f0/04f7f0cef26eebe9042da844a9b5803c.jpg',
    'https://i.pinimg.com/736x/80/85/bb/8085bb59f157bc086c0af841b6d6f1d9.jpg',
    'https://i.pinimg.com/1200x/d0/24/6b/d0246b754f53cac5a024cef859952f0c.jpg',
    'https://i.pinimg.com/736x/b8/74/6a/b8746aebe4ec725fb62bc8e02fe34acd.jpg',
  ]),
  SportCategory(name: 'TENNIS', emoji: '🎾', photoIds: [
    'https://i.pinimg.com/736x/98/f9/ec/98f9ec89fb105b341e4fb020d8f4bac9.jpg',
    'https://i.pinimg.com/736x/ac/cf/ed/accfed58e18d7d62ec0dc8c4202d9056.jpg',
    'https://i.pinimg.com/736x/47/e9/4a/47e94a30bc4633fdfc838348cfc72875.jpg',
    'https://i.pinimg.com/1200x/5b/2f/c9/5b2fc952ad1517536f13c338c7a1d4eb.jpg',
    'https://i.pinimg.com/736x/d1/da/3d/d1da3d458d87a25831441d29aefa873b.jpg',
    'https://i.pinimg.com/1200x/69/b8/c2/69b8c24c23df327c73885bf447deccd9.jpg',
    'https://i.pinimg.com/736x/6a/5b/c1/6a5bc1d3f736291a5f45cc720de0c0d3.jpg',
    'https://i.pinimg.com/736x/8b/e3/e9/8be3e9d0b7ee15f4f34704700c64d7aa.jpg',
    'https://i.pinimg.com/1200x/93/73/47/937347692110650b0681f13c1fc91da7.jpg',
    'https://i.pinimg.com/1200x/77/c9/b3/77c9b3c6bc554e7cf716525e2be0a332.jpg',
  ]),
  SportCategory(name: 'FOOTBALL', emoji: '⚽', photoIds: [
    'https://i.pinimg.com/736x/61/fa/06/61fa06ca6ed8a0a922ab0f3244acf2fc.jpg',
    'https://i.pinimg.com/736x/1e/1e/ad/1e1ead54b83f4388353b7b1f54364b0c.jpg',
    'https://i.pinimg.com/1200x/af/e6/5d/afe65d3adc66fab160ec44cad576da88.jpg',
    'https://i.pinimg.com/1200x/5a/db/38/5adb38b83e5e9830d11a564a1f8133b7.jpg',
    'https://i.pinimg.com/1200x/c2/3e/79/c23e797d0a8afd37ec07ed6b27c32b5a.jpg',
    'https://i.pinimg.com/736x/54/c2/08/54c2082271f10aff93ed3a17cf21d6c1.jpg',
    'https://i.pinimg.com/1200x/d8/5b/d1/d85bd1abf1119051a3d22dd02928ab65.jpg',
    'https://i.pinimg.com/1200x/b8/64/c0/b864c0454651e36a6e4c4e7d67a94e5d.jpg',
    'https://i.pinimg.com/1200x/0f/ac/d6/0facd68ae7efd314f8a2e3ab4f4e870e.jpg',
    'https://i.pinimg.com/1200x/ce/78/26/ce782651a2267c5f8541d69e566a50e7.jpg',
  ]),
  SportCategory(name: 'YOGA', emoji: '🧘', photoIds: [
    'https://i.pinimg.com/736x/9e/12/09/9e120924b06e6fe6593ec73a99b3b9a0.jpg',
    'https://i.pinimg.com/1200x/71/4e/91/714e911aec2c87c035ce5786c1421475.jpg',
    'https://i.pinimg.com/1200x/b1/c9/ac/b1c9ac66a793c0ec38ff842e0564975e.jpg',
    'https://i.pinimg.com/1200x/ba/1f/57/ba1f5734276153bc49dec01c82f27b17.jpg',
    'https://i.pinimg.com/736x/b8/12/69/b81269892ee4c07314eea622588cea8f.jpg',
    'https://i.pinimg.com/736x/12/b2/9e/12b29e6bca6d9ab721d9ef6888772668.jpg',
    'https://i.pinimg.com/736x/dc/7e/12/dc7e12d1744c85bbd9706c6c66d83688.jpg',
    'https://i.pinimg.com/736x/4b/9b/e3/4b9be3fe7bb94f530a1885b15c771cd0.jpg',
    'https://i.pinimg.com/1200x/ff/d1/aa/ffd1aa5cc1dca51e963228bb797acdf2.jpg',
    'https://i.pinimg.com/736x/34/21/cf/3421cfb44d3f675d0e33b87bb2972ddb.jpg',
  ]),
  SportCategory(name: 'RUNNING', emoji: '👟', photoIds: [
    'https://i.pinimg.com/736x/da/d1/d9/dad1d929e37ff1dfb930411ba32d1e1e.jpg',
    'https://i.pinimg.com/1200x/ea/0b/c7/ea0bc7e612df365f5b9c4b7a319c6145.jpg',
    'https://i.pinimg.com/736x/a8/04/14/a8041494b86cfccd60758c15149cfe8d.jpg',
    'https://i.pinimg.com/1200x/ed/b0/1b/edb01bb0c0f932b0a1f6fbbd4c396e7e.jpg',
    'https://i.pinimg.com/1200x/6b/d6/30/6bd630ab18715da582921efd957a7070.jpg',
    'https://i.pinimg.com/1200x/e0/3b/87/e03b876f8fcfe9138d3991b8dc6bfa78.jpg',
    'https://i.pinimg.com/1200x/4e/a9/db/4ea9dbeb502defa91ff3a1bf6ab5299d.jpg',
    'https://i.pinimg.com/1200x/3c/a9/9b/3ca99b24e69a9f0069f121eda8905f2f.jpg',
    'https://i.pinimg.com/736x/f6/18/dc/f618dcd094c752d742e33273477717ac.jpg',
    'https://i.pinimg.com/736x/c2/94/de/c294defdd121deda4daf887a18c17774.jpg',
  ]),
  SportCategory(name: 'CYCLING', emoji: '🚲', photoIds: [
    'https://i.pinimg.com/1200x/c1/73/45/c17345831dd2504dda6552af2f70a6eb.jpg',
    'https://i.pinimg.com/736x/fb/6c/75/fb6c7526950fc0042142b95d04c20418.jpg',
    'https://i.pinimg.com/736x/b7/71/39/b7713993a27d1f85f64fb55b7e7cc3fd.jpg',
    'https://i.pinimg.com/1200x/d4/ef/a4/d4efa47455006339dabb4319b26d9ded.jpg',
    'https://i.pinimg.com/1200x/85/b6/76/85b676c4f94a5ab5d358c22209b621a5.jpg',
    'https://i.pinimg.com/736x/73/33/06/7333069f487d422c427a841d35413001.jpg',
    'https://i.pinimg.com/1200x/12/a0/83/12a0838a946cef6ab015bbe702d1068a.jpg',
    'https://i.pinimg.com/736x/12/05/f1/1205f1a8b7a123a3fa6b785744fa8d0e.jpg',
    'https://i.pinimg.com/736x/11/69/ea/1169ea67a0da9b38a88e6329015435ff.jpg',
    'https://i.pinimg.com/1200x/85/cc/e6/85cce68c8a97909120074a649393f6f9.jpg',
  ]),
  SportCategory(name: 'BADMINTON', emoji: '🏸', photoIds: [
    'https://i.pinimg.com/1200x/08/cb/98/08cb9802687eeea85a61487334fbe652.jpg',
    'https://i.pinimg.com/1200x/bc/e9/f0/bce9f0a26b54ae37478575b3a4b17c2e.jpg',
    'https://i.pinimg.com/736x/66/4c/69/664c693c5edac47754d43a82c45b0560.jpg',
    'https://i.pinimg.com/736x/df/5f/71/df5f71781a9fa1e88e0c2510adf9f5a1.jpg',
    'https://i.pinimg.com/736x/36/94/ea/3694eafad6c0f9a918d015151522d306.jpg',
    'https://i.pinimg.com/736x/92/ad/e9/92ade9fcb1849b9d01f4b4ecf35f632d.jpg',
    'https://i.pinimg.com/736x/a0/50/b4/a050b4dec6b4e23b1a8f17d692eaa61e.jpg',
    'https://i.pinimg.com/1200x/f4/bd/87/f4bd875f8c64b1d4281a4bf0a9ffec93.jpg',
    'https://i.pinimg.com/736x/ec/1f/fd/ec1ffd392848d35d8b703b7cc3634770.jpg',
    'https://i.pinimg.com/736x/86/f3/8c/86f38c6a629eb15404d482addf373fa7.jpg',
  ]),
  SportCategory(name: 'TABLE TENNIS', emoji: '🏓', photoIds: [
    'https://i.pinimg.com/736x/06/13/a7/0613a7bd23898f66c3e4f10ded2b9eb9.jpg',
    'https://i.pinimg.com/736x/ba/71/f9/ba71f94ab5795f2bfc45814b824b0caa.jpg',
    'https://i.pinimg.com/736x/05/5a/44/055a446a713ccf5a4aef3c1430b46ee5.jpg',
    'https://i.pinimg.com/736x/a1/a7/6c/a1a76c9de847ad9907e76562714e0091.jpg',
    'https://i.pinimg.com/736x/90/70/48/907048f88f8c17d62115fae08749b148.jpg',
    'https://i.pinimg.com/736x/ba/a7/87/baa78712f9fd3b73b289843afcd9eb12.jpg',
    'https://i.pinimg.com/736x/71/27/56/712756acc706f3a79fd02ba5e1b519c1.jpg',
    'https://i.pinimg.com/736x/3e/c1/0e/3ec10e5c7b2f0d3d780ea742e7975caf.jpg',
    'https://i.pinimg.com/1200x/65/3d/61/653d619864a4a32543ebee3e23776951.jpg',
    'https://i.pinimg.com/736x/18/75/1d/18751dd7f16c060756ed9f9aae43f7da.jpg',
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
