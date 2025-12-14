import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/registration_screen.dart';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoaderOverlay(
        duration: const Duration(milliseconds: 250),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.chat, size: 100.0, color: Colors.lightBlueAccent),
              SizedBox(height: 48.0),
              TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Enter your email',
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  email = value;
                },
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Enter your password',
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              RoundButton(
                color: Colors.black,
                text: 'Login',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                    context.loaderOverlay.show();
                  });
                  await Future.delayed(Duration(seconds: 2));
                  try {
                    final user = _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (user!= true) {
                      Navigator.pushNamed(context, WelcomeScreen.id);
                      await Future.delayed(Duration(seconds: 2));
                    }
                    if (user == false) {
                      await Future.delayed(Duration(seconds: 2));
                      print('Invalid credentials');
                      return;
                    }
                    setState(() {
                      showSpinner = false;
                      context.loaderOverlay.hide();
                    });
                  } catch (e) {
                    print(e);
                  }
                  await Future.delayed(Duration(seconds: 2));
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: Text(
                  'Register here?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
