import 'dart:ui';
import 'package:flutter/material.dart';
import 'LandingPage3.dart';

// =========================================================================
// 1. SIGN IN PAGE (Sesuai Desain Kanan di Screenshot 2026-05-31 214317.png)
// =========================================================================
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image Full Screen
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1544698310-74ea9d1c8258?w=800',
                ), // Ganti asset lokal jika ada
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Konten Utama dengan Card Transparan (Frosted Glass) di Tengah
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo Ikon Daun Hijau di Atas Teks
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFD4EC32,
                                  ), // Lime/Yellow Green dari Figma
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.spa_rounded,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Title Welcome Back
                            const Text(
                              "WELCOME BACK",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Impact',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Log in to continue your urban fitness community.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Label & Field Email
                            _buildFieldLabel("Email"),
                            _buildInputField(
                              controller: _emailController,
                              validator: (val) => val == null || val.isEmpty
                                  ? "Email cannot be empty"
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            // Label & Field Password
                            _buildFieldLabel("Password"),
                            _buildInputField(
                              controller: _passwordController,
                              isPassword: true,
                              validator: (val) => val == null || val.isEmpty
                                  ? "Password cannot be empty"
                                  : null,
                            ),
                            const SizedBox(height: 24),

                            // Tombol SIGN IN (Lime Green Melengkung Sempurna)
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4EC32),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Handle Sign In Action
                                  }
                                },
                                child: const Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Garis Pembatas Or Sign In with Email
                            _buildDivider("Or Sign In with Email"),
                            const SizedBox(height: 20),

                            // Tombol Google & Facebook Berdampingan Kotak Putih
                            _buildSocialButtonsRow(),
                            const SizedBox(height: 24),

                            // Footer Link ke Sign Up Page
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Tambahkan Navigasi ke SignUpPage di sini jika memakai Router
                                  },
                                  child: const Text(
                                    "Register Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 2. SIGN UP PAGE (Sesuai Desain Kiri di Screenshot 2026-05-31 214317.png)
// =========================================================================
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Elemen Latar Belakang Lengkungan Hijau/Lime di Bagian Bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(color: const Color(0xFFD4EC32)),
            ),
          ),

          // Struktur Form Utama Atas Putih - Bawah Hijau
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Ikon Daun Hijau atas
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4EC32),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.spa_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Judul Utama CREATE NEW ACCOUNT
                      const Text(
                        "CREATE NEW ACCOUNT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Impact',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Be part of a community that\npushes your limits.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tombol Sosial Media Kotak Atas
                      _buildSocialButtonsRow(),
                      const SizedBox(height: 24),

                      // Pembatas Garis
                      _buildDivider(
                        "Or Sign Up with Email",
                        isDarkTheme: false,
                      ),
                      const SizedBox(height: 20),

                      // Input Form
                      _buildFieldLabel("Full Name", isDarkTheme: false),
                      _buildInputField(
                        controller: _nameController,
                        isDarkTheme: false,
                        validator: (val) => val == null || val.isEmpty
                            ? "Name cannot be empty"
                            : null,
                      ),
                      const SizedBox(height: 14),

                      _buildFieldLabel("Email", isDarkTheme: false),
                      _buildInputField(
                        controller: _emailController,
                        isDarkTheme: false,
                        validator: (val) => val == null || val.isEmpty
                            ? "Email cannot be empty"
                            : null,
                      ),
                      const SizedBox(height: 14),

                      _buildFieldLabel("Password", isDarkTheme: false),
                      _buildInputField(
                        controller: _passwordController,
                        isPassword: true,
                        isDarkTheme: false,
                        validator: (val) => val == null || val.isEmpty
                            ? "Password cannot be empty"
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Checkbox Persetujuan Syarat
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _isChecked,
                              activeColor: Colors.black,
                              onChanged: (val) {
                                setState(() {
                                  _isChecked = val ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "I agree to the Terms & Conditions and Privacy Policy of GreenGym.",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Tombol CREATE ACCOUNT Hitam Panjang Berisi Teks Hijau
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: const Color(0xFFD4EC32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _isChecked) {
                              // Handle Sign Up Action
                            }
                          },
                          child: const Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Impact',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Footer Balik ke Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigasi balik ke SignInPage
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 3. KOMPONEN PEMBANTU (WIDGET HELPERS)
// =========================================================================

// Label Input Field kecil diatas kotak isi
Widget _buildFieldLabel(String label, {bool isDarkTheme = true}) {
  return Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 6),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDarkTheme ? Colors.white70 : Colors.black87,
      ),
    ),
  );
}

// Desain Input Field Putih Polos Melengkung Sesuai Gambar
Widget _buildInputField({
  required TextEditingController controller,
  bool isPassword = false,
  bool isDarkTheme = true,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    validator: validator,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDarkTheme ? Colors.transparent : Colors.grey.shade400,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    ),
  );
}

// Garis Tengah Pembatas Or Sign In/Up
Widget _buildDivider(String text, {bool isDarkTheme = true}) {
  Color color = isDarkTheme ? Colors.white38 : Colors.black38;
  return Row(
    children: [
      Expanded(child: Divider(color: color, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(text, style: TextStyle(color: color, fontSize: 13)),
      ),
      Expanded(child: Divider(color: color, thickness: 1)),
    ],
  );
}

// Baris berisi 2 tombol Sosial Media (Google & Facebook) berbentuk rounded rectangle putih
Widget _buildSocialButtonsRow() {
  return Row(
    children: [
      Expanded(
        child: _socialSquareButton(
          Icons.g_mobiledata_rounded,
          Colors.red,
          () {},
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _socialSquareButton(Icons.facebook, Colors.blueAccent, () {}),
      ),
    ],
  );
}

Widget _socialSquareButton(IconData icon, Color iconColor, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Center(child: Icon(icon, size: 32, color: iconColor)),
    ),
  );
}

// Clipper Khusus untuk lengkungan bagian bawah Halaman Sign Up
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 60);
    path.quadraticBezierTo(size.width * 0.45, -20, size.width, 80);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
