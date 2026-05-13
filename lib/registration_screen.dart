import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String confirmPassword;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordStrong(String password) {
    return password.length >= 6;
  }

  void _validateAndRegister() {
    if (email.trim().isEmpty) {
      _showError('Please enter an email');
      return;
    }

    if (!_isValidEmail(email.trim())) {
      _showError('Please enter a valid email');
      return;
    }

    if (password.isEmpty) {
      _showError('Please enter a password');
      return;
    }

    if (!_isPasswordStrong(password)) {
      _showError('Password must be at least 6 characters');
      return;
    }

    if (confirmPassword.isEmpty) {
      _showError('Please confirm your password');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    _performRegistration();
  }

  void _performRegistration() async {
    context.loaderOverlay.show();
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (mounted) {
        context.loaderOverlay.hide();
        Navigator.pushNamedAndRemoveUntil(
          context,
          ChatScreen.id,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        context.loaderOverlay.hide();
        _showError(e.message ?? 'Registration failed');
      }
    } catch (e) {
      if (mounted) {
        context.loaderOverlay.hide();
        _showError('An error occurred during registration');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoaderOverlay(
        duration: const Duration(milliseconds: 200),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 48.0),
                const Icon(Icons.chat, size: 100.0, color: Colors.lightBlueAccent),
                const SizedBox(height: 48.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintStyle: const TextStyle(color: Colors.black54),
                    hintText: 'Enter your email',
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.email, color: Colors.lightBlueAccent),
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 12.0),
                TextField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintStyle: const TextStyle(color: Colors.black54),
                    hintText: 'Enter your password (6+ characters)',
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock, color: Colors.lightBlueAccent),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.lightBlueAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintStyle: const TextStyle(color: Colors.black54),
                    hintText: 'Confirm your password',
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock, color: Colors.lightBlueAccent),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.lightBlueAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  obscureText: _obscureConfirmPassword,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _validateAndRegister,
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
