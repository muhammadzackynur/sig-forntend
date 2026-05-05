import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart'; // Tambahkan import Google Sign In
import 'home_screen.dart';
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

  // Controller untuk menangkap input dari text field
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
  // URL API Backend Laravel
  final String _baseUrl = 'http://192.168.1.236:8000/api';

  @override
  void initState() {
    super.initState();
    isLogin = widget.isLoginMode;
  }

  @override
  void dispose() {
    // Bersihkan memory saat screen ditutup
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan pesan (Snackbar)
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Fungsi utama untuk integrasi ke backend (Email & Password)
  Future<void> _submitAuth() async {
    // Validasi dasar
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Email dan Password harus diisi!');
      return;
    }

    if (!isLogin) {
      if (_nameController.text.isEmpty) {
        _showSnackBar('Nama lengkap harus diisi!');
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showSnackBar('Konfirmasi password tidak cocok!');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(isLogin ? '$_baseUrl/login' : '$_baseUrl/register');

    try {
      // Data yang akan dikirim ke Laravel
      final Map<String, String> requestBody = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      if (!isLogin) {
        requestBody['name'] = _nameController.text;
        // Jika backend membutuhkan phone_number, kirimkan
        requestBody['phone_number'] = _phoneController.text;
      }

      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(isLogin ? 'Login Berhasil!' : 'Pendaftaran Berhasil!');
        print('Data Response: $responseData');

        // TODO: Simpan Token (misalnya menggunakan shared_preferences)

        // Navigasi ke halaman utama aplikasi (Home Screen)
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        final errorMessage = responseData['message'] ?? 'Terjadi kesalahan.';
        _showSnackBar('Gagal: $errorMessage');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan koneksi jaringan.');
      print('Network Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi integrasi Google Sign-In
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Tampilkan pop-up Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User membatalkan proses login Google
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 2. Dapatkan token otentikasi
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      // Opsional: Jika ingin mengirim nomor telepon saat Sign Up via Google,
      // kamu bisa mengambilnya dari _phoneController.text jika field tidak disembunyikan.
      final Map<String, String> requestBody = {'id_token': idToken ?? ''};

      // Jika butuh input nomor hp manual dari field saat google signup
      if (!isLogin && _phoneController.text.isNotEmpty) {
        requestBody['phone_number'] = _phoneController.text;
      }

      // 3. Kirim id_token ke backend Laravel
      final url = Uri.parse('$_baseUrl/auth/google');
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: requestBody,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        _showSnackBar('Login Google Berhasil!');
        print('Data Response: $responseData');

        // TODO: Simpan Token (misalnya menggunakan shared_preferences)
        // final String token = responseData['access_token'];

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        final errorMessage =
            responseData['message'] ?? 'Terjadi kesalahan pada backend.';
        _showSnackBar('Gagal: $errorMessage');
        await _googleSignIn
            .signOut(); // Sign out dari sesi google lokal jika backend gagal
      }
    } catch (error) {
      _showSnackBar('Terjadi kesalahan saat login dengan Google.');
      print('Google Sign-In Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: WavyClipper(),
              child: Container(
                height: 250,
                width: double.infinity,
                color: AppColors.primary,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Icon(Icons.location_on, color: AppColors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'FindUs',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isLogin = true),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isLogin
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isLogin
                                      ? AppColors.white
                                      : AppColors.textLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isLogin = false),
                            child: Container(
                              decoration: BoxDecoration(
                                color: !isLogin
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !isLogin
                                      ? AppColors.white
                                      : AppColors.textLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (!isLogin) ...[
                    const Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Join Circlee and start connecting.',
                      style: TextStyle(color: AppColors.textLight),
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
                          style: TextStyle(color: AppColors.textLight),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Tombol Utama (Login / Sign Up Email)
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: isLogin ? 'Log In' : 'Create Account',
                          onPressed: _submitAuth, // Memicu fungsi integrasi API
                        ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.primaryLight)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'or',
                          style: TextStyle(color: AppColors.textLight),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.primaryLight)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Opsi Login Provider Pihak Ketiga
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          // Tambahkan fungsi Google SignIn di sini
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(
                              color: AppColors.primaryLight,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.g_mobiledata,
                            color: AppColors.textDark,
                            size: 28,
                          ),
                          label: const Text(
                            'Google',
                            style: TextStyle(
                              color: AppColors.textDark,
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
                            side: const BorderSide(
                              color: AppColors.primaryLight,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.apple,
                            color: AppColors.textDark,
                            size: 28,
                          ),
                          label: const Text(
                            'Apple',
                            style: TextStyle(
                              color: AppColors.textDark,
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' & '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
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
                          style: const TextStyle(color: AppColors.textLight),
                          children: [
                            TextSpan(
                              text: 'Log In',
                              style: const TextStyle(
                                color: AppColors.textDark,
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
