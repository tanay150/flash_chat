
import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoaderOverlay(
        duration: const Duration(milliseconds: 200),

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.chat, size: 100.0, color: Colors.lightBlueAccent),
              SizedBox(height: 48.0),
              TextField(
                keyboardType: TextInputType.emailAddress,

                textAlign: TextAlign.center,
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
                autofocus: true,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
              ),
              SizedBox(height: 10.0),
              TextField(
                textAlign: TextAlign.center,
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
                autofocus: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                  if (password.length < 6)
                  {
                    print('Password must be at least 6 characters');
                    return;
                  }
                  print(password);
                },
                obscureText: true,
                ),

              SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.emailAddress,

                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Confirm your password',
                  fillColor: Colors.white,
                ),
                autofocus: true,
                onChanged: (value) {
                  if (password.length < 6)
                  {
                    print('Password must be at least 6 characters');
                    return;
                  }
                  print(password);
                  //Do something with the user input.
                  email = value;
                },
              ),
              RoundButton(
                color: Colors.black,
                text: 'Register',

                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                    context.loaderOverlay.show();
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (newUser != true) {
                      Navigator.pushNamed(context, WelcomeScreen.id);}
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
            ],
          ),
        ),
      ),
    );
  }
}
