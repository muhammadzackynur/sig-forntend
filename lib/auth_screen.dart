import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';

// PASTIKAN BARIS INI ADA AGAR TIDAK ERROR
import 'main_layout.dart';
import 'app_colors.dart';
import 'custom_widgets.dart';

class AuthScreen extends StatefulWidget {
  final bool isLoginMode;
  const AuthScreen({Key? key, this.isLoginMode = true}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isLogin;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '229118112939-419kmv6oeek5hicmrcpjvr135nh33tu6.apps.googleusercontent.com',
  );

  final String _baseUrl = 'http://192.168.1.40:8000/api';

  @override
  void initState() {
    super.initState();
    isLogin = widget.isLoginMode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitAuth() async {
    // LOGIN STATIS: Melewati semua validasi data dan HTTP Request.
    // Langsung arahkan ke MainLayout.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainLayout()),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    // LOGIN STATIS GOOGLE: Melewati HTTP request ke backend.
    // Langsung arahkan ke MainLayout.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna utama sesuai desain: coklat gelap olive
    const Color primaryColor = Color(0xFF5C5240);
    const Color bgColor = Color(0xFFF5F0EA);
    const Color textDark = Color(0xFF3B3025);
    const Color textLight = Color(0xFF9E8E78);
    const Color primaryLight = Color(0xFFD6C9B6);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── HEADER dengan wavy clipper ──
            ClipPath(
              clipper: _WavyBottomClipper(),
              child: Container(
                height: 260,
                width: double.infinity,
                color: primaryColor,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Ikon lokasi: lingkaran luar + lingkaran dalam
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: bgColor,
                        ),
                        child: Center(
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'FindUs',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // ── KONTEN FORM ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Toggle Log In / Sign Up
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: primaryLight.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isLogin = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isLogin
                                    ? primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isLogin ? Colors.white : textLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isLogin = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: !isLogin
                                    ? primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !isLogin ? Colors.white : textLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── SIGN UP FIELDS ──
                  if (!isLogin) ...[
                    const Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Join Circlee and start connecting.',
                      style: TextStyle(color: textLight),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _nameController,
                      hint: 'Full Name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                  ],

                  CustomTextField(
                    controller: _emailController,
                    hint: 'Email address',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  if (!isLogin) ...[
                    CustomTextField(
                      controller: _phoneController,
                      hint: 'Phone Number',
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 16),
                  ],

                  CustomTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  if (isLogin) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Color(0xFFB89D7A)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ] else ...[
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hint: 'Confirm Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Use 8+ characters with a mix of letters, numbers & symbols.',
                      style: TextStyle(fontSize: 12, color: textLight),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Tombol utama
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _submitAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              isLogin ? 'Log In' : 'Create Account',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Expanded(child: Divider(color: primaryLight)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          isLogin ? 'or' : 'or continue with',
                          style: const TextStyle(color: textLight),
                        ),
                      ),
                      const Expanded(child: Divider(color: primaryLight)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Social login buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: primaryLight),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.g_mobiledata,
                            color: textDark,
                            size: 28,
                          ),
                          label: const Text(
                            'Google',
                            style: TextStyle(
                              color: textDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: primaryLight),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          icon: const Icon(
                            Icons.apple,
                            color: textDark,
                            size: 28,
                          ),
                          label: const Text(
                            'Apple',
                            style: TextStyle(
                              color: textDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: isLogin
                            ? 'By signing up you agree to our '
                            : 'By creating an account you agree to our\n',
                        style: const TextStyle(fontSize: 12, color: textLight),
                        children: const [
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: textLight,
                            ),
                          ),
                          TextSpan(text: ' & '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: textLight,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  if (!isLogin) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: const TextStyle(color: textLight),
                          children: const [
                            TextSpan(
                              text: 'Log In',
                              style: TextStyle(
                                color: textDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wavy clipper
class _WavyBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 70);
    path.cubicTo(
      size.width * 0.30,
      size.height + 10,
      size.width * 0.65,
      size.height - 90,
      size.width,
      size.height - 55,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
