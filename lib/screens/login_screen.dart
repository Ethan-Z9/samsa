import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frc_scout_app/auth/auth_service.dart';

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
      final isValid = await _authService.validateScout(_emailController.text.trim());
      if (isValid) {
        Navigator.pushReplacementNamed(context, '/dashboard');
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

                  /*
                  // Filled in box
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                  //
                  */

                  // Transparent box
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white30),
                    ),  
                  //

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
                                //
                                filled: true,
                                fillColor: Colors.white70,
                                //
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
                                    : const Text('LOGIN', style: TextStyle(fontSize: 16),),
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
          // ), // Filled in Box
        ]
      ),
    );
  }
}