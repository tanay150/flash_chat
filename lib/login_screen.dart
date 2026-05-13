import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'welcome_screen.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoaderOverlay(
        duration: const Duration(milliseconds: 250),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Icon(Icons.chat, size: 100.0, color: Colors.lightBlueAccent),
              const SizedBox(height: 48.0),
              TextField(
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
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
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              TextField(
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
                  hintText: 'Enter your password',
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
                textAlign: TextAlign.center,
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
                onPressed: () async {
                  context.loaderOverlay.show();
                  try {
                    await _auth.signInWithEmailAndPassword(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.message ?? 'Login failed'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      context.loaderOverlay.hide();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('An error occurred'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: const Text(
                  "Don't have an account? Register here",
                  style: TextStyle(color: Colors.lightBlueAccent, fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
