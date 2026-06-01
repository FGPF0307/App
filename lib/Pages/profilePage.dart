import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E6DF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              const Icon(Icons.chevron_left, size: 24, color: Colors.black),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'HELLO,',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'JOHN GREENJIM!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/images/image 106.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
