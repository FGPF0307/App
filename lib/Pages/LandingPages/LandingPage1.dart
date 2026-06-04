import 'package:flutter/material.dart';
import 'package:greengymapp/Pages/LandingPages/LandingPage2.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkCharcoal = Color(0xFF1E241F); 
    const Color domeWhite = Color(0xFFF9F9F9);    
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
                  'assets/images/landingPage1.jpg', 
                  fit: BoxFit.cover, 
                  alignment: Alignment.centerLeft, 
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
                
                // Tulisan Train dan To
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TRAIN',
                      style: TextStyle(
                        fontFamily: 'BebasNeue', 
                        fontSize: 84, 
                        height: 0.8, 
                        color: darkCharcoal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 6.0), 
                      child: const Text(
                        'TO',
                        style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 40,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Tul;isan FIT dan YOUR CITY
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 72,
                      height: 0.85,
                      letterSpacing: 1.0,
                    ),
                    children: [
                      TextSpan(text: 'FIT ', style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'YOUR ', style: TextStyle(color: darkCharcoal)),
                      TextSpan(text: 'CITY', style: TextStyle(color: Colors.white)),
                    ],
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
                padding: const EdgeInsets.fromLTRB(32, 72, 32, 40), 
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    
                    const Text(
                      'Find every workout spot\nacross the city instantly.\nDiscover open parks,\npublic courts, and premium\ngyms. Check live crowd\ndensity, view available\nbooking slots, and keep\nyour city active.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono', 
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black,
                        height: 1.4, 
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF191919), 
                          shape: const StadiumBorder(), 
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen2(),
                            ),
                          );
                        },
                        child: const Text(
                          'EXPLORE MORE',
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 26,
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