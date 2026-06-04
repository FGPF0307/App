import 'package:flutter/material.dart';

class Socialpage4 extends StatefulWidget {
  const Socialpage4({Key? key}) : super(key: key);

  @override
  State<Socialpage4> createState() => _Socialpage4State();
}

class _Socialpage4State extends State<Socialpage4> {
  static const Color creamBg = Color(0xFFE1DCD3);
  static const Color darkGreen = Color(0xFF043927);
  static const Color customBrown = Color(0xFF9E6E38); // Warna garis untuk pesan "ME"

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State awal daftar pesan sesuai gambar Figma
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'RAKA ARKADIAN',
      'time': '15.00 PM',
      'message': 'Anyone want to run around Alam Sutera tonight??...if you guys want to do it..i’ll host the session!!',
      'isMe': false,
    },
    {
      'sender': 'OLIVER MARTINEZ',
      'time': '15.05 PM',
      'message': 'of course...why not!!',
      'isMe': false,
    },
    {
      'sender': 'DANENDRA J.',
      'time': '15.10 PM',
      'message': 'me too!!!',
      'isMe': false,
    },
    {
      'sender': 'ME',
      'time': '15.12 PM',
      'message': 'I would like too!!',
      'isMe': true,
    },
  ];

  // PERBAIKAN: Fungsi kirim pesan menggunakan addPostFrameCallback standar Flutter
  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'ME',
        'time': '15.15 PM', 
        'message': _chatController.text.trim(),
        'isMe': true,
      });
    });

    _chatController.clear();

    // Auto-scroll berjalan aman setelah frame selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBg,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // 1. CUSTOM HEADER CHAT
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.only(right: 12.0, top: 4.0),
                            child: Text(
                              '<',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'BASKET SWEAT CLUB',
                                style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 32,
                                  letterSpacing: 0.5,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '20 Members',
                                    style: TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=100',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(width: 56, height: 56, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. AREA DAFTAR CHAT (SCROLLABLE)
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'TODAY',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final chat = _messages[index];
                        return _buildChatBubble(
                          sender: chat['sender'],
                          time: chat['time'],
                          message: chat['message'],
                          isMe: chat['isMe'],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // 3. BAR INPUT CHAT (WRITE TRANSCRIPT)
            // ==========================================
            Container(
              color: creamBg,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0, top: 10.0),
              child: Container(
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.add_circle_outline, color: Colors.grey[600], size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Write Transcript',
                          hintStyle: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Icon(Icons.send, color: Colors.grey[600], size: 22),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble({
    required String sender,
    required String time,
    required String message,
    required bool isMe,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              width: 4,
              height: 42, 
              color: darkGreen,
            ),
          if (!isMe) const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      sender,
                      style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 18,
                        letterSpacing: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 9,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  textAlign: isMe ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          if (isMe) const SizedBox(width: 10),
          if (isMe)
            Container(
              width: 4,
              height: 32,
              color: customBrown,
            ),
        ],
      ),
    );
  }
}