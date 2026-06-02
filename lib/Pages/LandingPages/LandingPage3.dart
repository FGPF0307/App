import 'package:flutter/material.dart';
import 'package:greengymapp/Pages/SignUpandSigninPage/signuppage.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color crownYellow = Color(0xFFF5B82E);
    const Color domeWhite = Color(0xFFFFFFFF);
    const Color creamBg = Color(0xFFE1DCD3);

    return Scaffold(
      backgroundColor: creamBg,
      body: Stack(
        children: [
          Center(
            child: ClipRect(
              child: SizedBox(
                width: 402,
                height: 874,
                child: Image.asset(
                  'assets/images/landingPage3.jpeg',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TRAIN',
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 84,
                        height: 0.8,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 8.0),
                      child: const Text(
                        'TO',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 36,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'STRONG ,',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 84,
                    height: 0.85,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'CLAIM',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 84,
                    height: 0.85,
                    color: crownYellow,
                  ),
                ),
                const Text(
                  'YOUR CROWN',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 84,
                    height: 0.85,
                    color: crownYellow,
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: DomeClipper(),
              child: Container(
                width: double.infinity,
                color: domeWhite,
                padding: const EdgeInsets.fromLTRB(32, 64, 32, 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Every sweat counts. Earn\nXP from real-world check-\nins, level up your\nprofile, and claim your\ncrown as a Local Legend to\nunlock exclusive rewards\nat healthy local\nmerchants.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // GET STARTED → ke Sign Up
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: crownYellow,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'GET STARTED',
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 32,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
