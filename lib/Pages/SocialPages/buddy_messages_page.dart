import 'package:flutter/material.dart';
import 'chat_room_page.dart'; // Navigasi ke personal chatroom

class BuddyMessagesPage extends StatefulWidget {
  const BuddyMessagesPage({super.key});

  @override
  State<BuddyMessagesPage> createState() => _BuddyMessagesPageState();
}

class _BuddyMessagesPageState extends State<BuddyMessagesPage> {
  // Warna latar belakang khas sesuai gambar Figma
  static const Color figmaBg = Color(0xFFE2E1D6); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: figmaBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // HEADER: < BUDDY MESSAGES
              // ==========================================
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'BUDDY MESSAGES',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 34,
                        letterSpacing: 0.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ==========================================
              // SEARCH BAR (KOTAK PUTIH MINIMALIS)
              // ==========================================
              Container(
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.black54, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '', // Kosong sesuai desain Figma
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // SECTION: ADD NEW FRIENDS
              // ==========================================
              const Text(
                'Add new friends',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFriendAvatar('https://images.unsplash.com/photo-1546519638-68e109498ffc?w=150'),
                    _buildFriendAvatar('https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=150'),
                    _buildFriendAvatar('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'),
                    _buildFriendAvatar('https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150'),
                    _buildFriendAvatar('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ==========================================
              // SECTION: CHATS
              // ==========================================
              const Text(
                'Chats',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Daftar Chat Utama
              _buildFigmaChatTile(
                name: 'RAKA ARKADIAN',
                level: 'LVL.15',
                time: '2m ago',
                message: 'Gass, sore ini latihan dilapangan biasa?',
                imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                onTap: () => _navigateToChat(context, 'RAKA ARKADIAN'),
              ),
              _buildFigmaChatTile(
                name: 'OLIVER MARTINEZ',
                level: 'LVL.15',
                time: '2m ago',
                message: 'Halloo.....',
                imageUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
                onTap: () => _navigateToChat(context, 'OLIVER MARTINEZ'),
              ),
              _buildFigmaChatTile(
                name: 'DANENDRA J',
                level: 'LVL.15',
                time: '2m ago',
                message: 'Gass, sore ini latihan dilapangan biasa?',
                imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                onTap: () => _navigateToChat(context, 'DANENDRA J'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi pembantu navigasi estafet tanpa menggunakan `const` pada target class
  void _navigateToChat(BuildContext context, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomPage.personal(name),
      ),
    );
  }

  // Helper: Grid Avatar Kotak untuk "Add new friends"
  Widget _buildFriendAvatar(String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Melengkung sedikit mirip figma
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: Colors.grey, child: const Icon(Icons.person, color: Colors.white)),
        ),
      ),
    );
  }

  // Helper: List Item Chat beserta pembatas garis hitam tipis bawahnya
  Widget _buildFigmaChatTile({
    required String name,
    required String level,
    required String time,
    required String message,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto profil kotak rounded
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey, width: 52, height: 52, child: const Icon(Icons.person)),
                  ),
                ),
                const SizedBox(width: 14),
                
                // Area Informasi Chat
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 20,
                              letterSpacing: 0.5,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            level,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            time,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 9,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
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
          // Garis pemisah hitam tipis di setiap bawah chat tile sesuai gambar figma
          const Divider(
            color: Colors.black87,
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}