import 'dart:io'; // Digunakan untuk memuat berkas lokal via File()
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'socialpage4.dart';
import 'community_store.dart';

class Socialpage2 extends StatefulWidget {
  const Socialpage2({Key? key}) : super(key: key);

  @override
  State<Socialpage2> createState() => _Socialpage2State();
}

class _Socialpage2State extends State<Socialpage2> {
  static const Color creamBg = Color(0xFFE2E1D6);
  static const Color darkGreen = Color(0xFF043927);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  // Komunitas yang BELUM di-join (saran untuk ditemukan). Komunitas yang
  // sudah di-join diambil dari CommunityStore (termasuk hasil join sesi).
  final List<Map<String, String>> _discoverSquads = [
    {
      'title': 'BADMINTON SMASH',
      'members': '15 Members',
      'location': 'Hall Mark Alam Sutera',
      'image':
          'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=200',
    },
    {
      'title': 'TENNIS ACE SOCIETY',
      'members': '8 Members',
      'location': 'Alam Sutera Tennis Court',
      'image':
          'https://images.unsplash.com/photo-1622279457486-62dce4a4ef53?w=200',
    },
    {
      'title': 'GO GO GO RUNNER',
      'members': '20 Members',
      'location': 'Alam Sutera',
      'image':
          'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=200',
    },
  ];

  Future<void> _pickImage(StateSetter dialogState) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        dialogState(() => _selectedImagePath = pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error saat memilih gambar: $e");
    }
  }

  void _showCreateGroupDialog() {
    _selectedImagePath = null;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, dialogState) {
            return AlertDialog(
              backgroundColor: creamBg,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              title: const Text(
                'CREATE NEW SQUAD',
                style: TextStyle(
                    fontFamily: 'BebasNeue', fontSize: 24, letterSpacing: 1.0),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'SQUAD NAME',
                        labelStyle:
                            TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'LOCATION',
                        labelStyle:
                            TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'SQUAD PHOTO',
                        style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickImage(dialogState),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                        ),
                        child: _selectedImagePath != null
                            ? Image.file(File(_selectedImagePath!),
                                fit: BoxFit.cover)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_a_photo_outlined,
                                      color: Colors.grey, size: 32),
                                  SizedBox(height: 6),
                                  Text(
                                    'Click to choose from Gallery',
                                    style: TextStyle(
                                        fontFamily: 'JetBrainsMono',
                                        fontSize: 11,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _titleController.clear();
                    _locationController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('CANCEL',
                      style:
                          TextStyle(fontFamily: 'BebasNeue', color: Colors.red)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () {
                    if (_titleController.text.trim().isNotEmpty &&
                        _locationController.text.trim().isNotEmpty) {
                      CommunityStore.instance.add(
                        CommunityData(
                          title: _titleController.text.toUpperCase(),
                          members: '1 Member',
                          location: _locationController.text,
                          lastMessage: '“Squad created! 🎉”',
                          imageUrl: _selectedImagePath ??
                              'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=200',
                        ),
                      );
                      _titleController.clear();
                      _locationController.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Squad successfully created!')),
                      );
                    }
                  },
                  child: const Text('CREATE',
                      style: TextStyle(
                          fontFamily: 'BebasNeue', color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkGreen,
        shape: const CircleBorder(),
        onPressed: _showCreateGroupDialog,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: CommunityStore.instance,
          builder: (context, _) {
            final joined = CommunityStore.instance.communities;
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          '< ',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 32,
                              color: Colors.black),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'SPORT COMMUNITIES',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 34,
                              letterSpacing: 0.5,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // YOUR JOINED SQUADS (dari CommunityStore)
                  const Text(
                    'YOUR JOINED SQUADS',
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 18,
                        color: Colors.black,
                        letterSpacing: 0.8),
                  ),
                  const Text(
                    'Tap to open community chatroom',
                    style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  if (joined.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("You haven't joined any squads yet.",
                          style: TextStyle(
                              fontFamily: 'JetBrainsMono', fontSize: 12)),
                    )
                  else
                    ...joined.map((c) => _buildCommunityCard(
                          title: c.title,
                          members: c.members,
                          location: c.location,
                          imageSource: c.imageUrl,
                          isJoined: true,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Socialpage4(),
                              settings: RouteSettings(arguments: c),
                            ),
                          ),
                        )),

                  const SizedBox(height: 24),
                  const Divider(color: Colors.black26, thickness: 1),
                  const SizedBox(height: 14),

                  // DISCOVER NEW SQUADS (lokal)
                  const Text(
                    'DISCOVER NEW SQUADS',
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 18,
                        color: Colors.black,
                        letterSpacing: 0.8),
                  ),
                  const Text(
                    'Click JOIN to add them to your community list',
                    style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  if (_discoverSquads.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('All available squads joined!',
                          style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 12,
                              color: darkGreen)),
                    )
                  else
                    ..._discoverSquads.map((squad) => _buildCommunityCard(
                          title: squad['title']!,
                          members: squad['members']!,
                          location: squad['location']!,
                          imageSource: squad['image']!,
                          isJoined: false,
                          onTap: () {
                            CommunityStore.instance.add(
                              CommunityData(
                                title: squad['title']!,
                                members: squad['members']!,
                                location: squad['location']!,
                                lastMessage: '“Welcome to the squad!”',
                                imageUrl: squad['image']!,
                              ),
                            );
                            setState(() => _discoverSquads.remove(squad));
                          },
                        )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommunityCard({
    required String title,
    required String members,
    required String location,
    required String imageSource,
    required bool isJoined,
    required VoidCallback onTap,
  }) {
    final bool isNetworkImage =
        imageSource.startsWith('http://') || imageSource.startsWith('https://');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isNetworkImage
                ? Image.network(
                    imageSource,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.group,
                          size: 30, color: Colors.grey),
                    ),
                  )
                : Image.file(
                    File(imageSource),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image,
                          size: 30, color: Colors.grey),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 18,
                            letterSpacing: 0.5),
                      ),
                    ),
                    Text(
                      members,
                      style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 11,
                            color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: isJoined
                      ? GestureDetector(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: darkGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'JOINED',
                              style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  color: darkGreen,
                                  fontSize: 12),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 26,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side:
                                  const BorderSide(color: Colors.black, width: 1),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            onPressed: onTap,
                            child: const Text(
                              'JOIN',
                              style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  color: Colors.black,
                                  fontSize: 12),
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
}
