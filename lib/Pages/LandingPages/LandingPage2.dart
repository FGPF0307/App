import 'package:flutter/material.dart';
import 'package:fitarena/Pages/LandingPages/LandingPage3.dart';
class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    const Color neonGreen = Color(0xFF6AFF00); 
    const Color pitchBlack = Color(0xFF000000); 
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
                  'assets/images/landingPage2.jpeg', 
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
                
                //"TRAIN" & "TO"
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
                          color: neonGreen, 
                        ),
                      ),
                    ),
                  ],
                ),
                
                // "SUCCESS"
                const Text(
                  'SUCCESS',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 84,
                    height: 0.85,
                    color: neonGreen, 
                  ),
                ),

                // BARIS 3: "TOGETHER"
                const Text(
                  'TOGETHER',
                  style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 84,
                    height: 0.85,
                    color: Colors.white, 
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
                color: pitchBlack, 
                padding: const EdgeInsets.fromLTRB(32, 64, 32, 40), 
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    
                    const Text(
                      'Never workout alone. Host\nor join open sports\nsessions nearby, match\nwith fitness buddies of\nthe exact same pace, and\nstay connected through\nlocation-based community\ngroup chats.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono', 
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white, 
                        height: 1.5, 
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: neonGreen, 
                          shape: const StadiumBorder(), 
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen3(),
                            ),
                          );
                        },
                        child: const Text(
                          'NEXT',
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
    
    path.quadraticBezierTo(
      size.width / 2, 0, 
      size.width, 50,    
    );
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}