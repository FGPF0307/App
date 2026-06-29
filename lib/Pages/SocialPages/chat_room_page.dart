import 'package:flutter/material.dart';
import 'community_store.dart';

/// Satu pesan dalam sebuah chatroom.
class ChatMessage {
  final String sender;
  final String time;
  final String text;
  final bool isMe;

  const ChatMessage({
    required this.sender,
    required this.time,
    required this.text,
    this.isMe = false,
  });
}

/// Halaman chatroom serbaguna yang dipakai untuk dua mode:
/// - [ChatRoomPage.group]   → obrolan komunitas/squad (menampilkan nama pengirim).
/// - [ChatRoomPage.personal]→ obrolan pribadi dengan seorang buddy.
///
/// Sebelumnya logika ini terduplikasi di dua halaman terpisah; kini cukup
/// satu widget reusable dengan konfigurasi lewat constructor.
class ChatRoomPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isGroup;
  final List<ChatMessage> initialMessages;

  const ChatRoomPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isGroup,
    this.initialMessages = const [],
  });

  /// Chatroom grup berdasarkan data komunitas (boleh null → memakai contoh).
  factory ChatRoomPage.group(CommunityData? community) {
    return ChatRoomPage(
      title: community?.title ?? 'BASKET SWEAT CLUB',
      subtitle: community?.members ?? '20 Members',
      imageUrl: community?.imageUrl ??
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=200',
      isGroup: true,
      initialMessages: const [
        ChatMessage(
          sender: 'RAKA ARKADIAN',
          time: '15.00 PM',
          text:
              'Anyone want to run around Alam Sutera tonight??...if you guys want to do it..i’ll host the session!!',
        ),
        ChatMessage(
          sender: 'OLIVER MARTINEZ',
          time: '15.05 PM',
          text: 'of course...why not!!',
        ),
        ChatMessage(sender: 'DANENDRA J.', time: '15.10 PM', text: 'me too!!!'),
        ChatMessage(
          sender: 'ME',
          time: '15.12 PM',
          text: 'I would like too!!',
          isMe: true,
        ),
      ],
    );
  }

  /// Chatroom personal dengan seorang buddy.
  factory ChatRoomPage.personal(String name) {
    return ChatRoomPage(
      title: name.toUpperCase(),
      subtitle: 'Currently training at decathlon alam sutera',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      isGroup: false,
      initialMessages: const [
        ChatMessage(
          sender: '',
          time: '15.10 PM',
          text:
              'Hey! just finished the first set heavy back squats. are you still coming for the run session at 7?',
        ),
        ChatMessage(
          sender: 'ME',
          time: '15.12 PM',
          text: "i'll definitely be there",
          isMe: true,
        ),
      ],
    );
  }

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  static const Color _creamBg = Color(0xFFE1DCD3);
  static const Color _darkGreen = Color(0xFF043927);
  static const Color _brown = Color(0xFF9E6E38);

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final List<ChatMessage> _messages =
      List<ChatMessage>.from(widget.initialMessages);

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(sender: 'ME', time: 'now', text: text, isMe: true),
      );
    });
    _chatController.clear();

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
      backgroundColor: _creamBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    _buildTodayBadge(),
                    const SizedBox(height: 6),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) =>
                          _buildChatBubble(_messages[index]),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0, top: 4.0),
              child: Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 32,
                    letterSpacing: 0.5,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: _darkGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: communityImage(widget.imageUrl, width: 56, height: 56),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayBadge() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }

  Widget _buildChatBubble(ChatMessage chat) {
    final bool isMe = chat.isMe;
    final Color accent = isMe ? _brown : _darkGreen;
    // Tampilkan nama pengirim hanya di chatroom grup.
    final bool showSender = widget.isGroup && chat.sender.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) _accentBar(accent),
          if (!isMe) const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (showSender)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        chat.sender,
                        style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        chat.time,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                if (showSender) const SizedBox(height: 4),
                Text(
                  chat.text,
                  textAlign: isMe ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                if (!showSender) const SizedBox(height: 4),
                if (!showSender)
                  Text(
                    chat.time,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 9,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 10),
          if (isMe) _accentBar(accent),
        ],
      ),
    );
  }

  Widget _accentBar(Color color) =>
      Container(width: 4, height: 42, color: color);

  Widget _buildInputBar() {
    return Container(
      color: _creamBg,
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0, top: 10.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Icon(Icons.add_circle_outline, color: Colors.grey[600], size: 24),
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
              child: const Icon(Icons.send, color: _darkGreen, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
