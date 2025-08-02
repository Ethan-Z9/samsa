import 'dart:io'; // For exit(0)
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemNavigator.pop()
import 'package:frc_scout_app/auth/auth_service.dart';
import 'package:frc_scout_app/data/user_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim().toLowerCase();
      final isValid = await _authService.validateScout(email);

      if (isValid) {
        final user = await _authService.getScoutData(email);

        if (user != null) {
          final session = UserSession();
          session.firstName = user['firstName'] ?? '';
          session.lastName = user['lastName'] ?? '';
          await _authService.login(email);
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          _showError('User info not found');
        }
      } else {
        _showError('Email not found in roster');
      }
    } catch (e) {
      _showError('Login error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _exitApp() {
    // ======== EXIT OPTIONS BELOW ========

    exit(0); // <-- ✅ Windows: Leave this uncommented

    // SystemNavigator.pop(); // <-- ✅ Android: Uncomment this and comment out exit(0)

    // =====================================
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Image.asset(
              'assets/images/login_screen_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: 300,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white30),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/app_logo.png',
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@') || !value.contains('.')) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 73, 69, 79),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('LOGIN', style: TextStyle(fontSize: 16)),
                            ),
                          ),

                          // Exit App Button
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                              label: const Text(
                                'Exit App',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              onPressed: _exitApp,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.redAccent),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "By logging in, you agree to data use as outlined in Settings.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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
