import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'chat_screen.dart'; // Make sure ChatScreen.id is defined

// Your RoundButton class
class RoundButton extends StatelessWidget {
  RoundButton({
    required this.color,
    required this.onPressed,
    required this.text,
  });
  final Color color;
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _loggedInUser;
  String? _displayEmail;
  bool _justRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentUserAndArgs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If WelcomeScreen is pushed again with new arguments (e.g. after login)
    // this can help refresh the arguments if not handled by replacing the route.
    // However, with pushNamedAndRemoveUntil, initState and addPostFrameCallback are usually sufficient.
    // For this specific flow, relying on initState with addPostFrameCallback is fine.
  }

  void _checkCurrentUserAndArgs() {
    // Check for an already logged-in user (e.g. app restart)
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _loggedInUser = currentUser;
      _displayEmail = currentUser.email;
    }

    // Use addPostFrameCallback to safely access arguments after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if arguments were passed (e.g., from RegistrationScreen)
      final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
      bool argumentsProcessed = false;
      if (args != null) {
        final String? passedEmail = args['userEmail'] as String?;
        final bool passedJustRegistered =
            args['justRegistered'] as bool? ?? false;

        if (passedEmail != null) {
          _loggedInUser =
              _auth.currentUser; // Should be the newly registered user
          _displayEmail = passedEmail;
          _justRegistered = passedJustRegistered;
          argumentsProcessed = true;
        }
      }
      // If no arguments but we have a current user from firebase (e.g. app restart, already logged in)
      // and arguments weren't processed (meaning we didn't just come from registration with args)
      else if (_loggedInUser != null && !argumentsProcessed) {
        // _displayEmail would have been set from currentUser.email already
        _justRegistered = false; // Not a fresh registration in this case
      }

      if (mounted) {
        setState(() {}); // Trigger a rebuild to reflect the state
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text( 'WELCOME!' ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Icon(
                    Icons.chat,
                    size: 50.0,
                    color: Colors.lightBlueAccent,
                  ),
                ),

                ListTile(
                  title: Text('HOME'),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('SETTING'),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ListTile(
              title: Text('LOGOUT'),
              leading: Icon(Icons.logout),

              onTap: () {
                _auth.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Optional: Logo
            SizedBox(height: 30.0),

            if (_loggedInUser != null && _displayEmail != null) ...[
              // ---- UI FOR LOGGED-IN / JUST REGISTERED USER ----
              if (_justRegistered) SizedBox(height: 5.0),
              InkWell(
                // Make the email tappable
                onTap: () {
                  // Navigate to ChatScreen
                  Navigator.pushReplacementNamed(context, ChatScreen.id);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Text(
                    _displayEmail!,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(
                        context,
                      ).primaryColor, // Make it look interactive
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  _justRegistered
                      ? "(Tap email to chat)"
                      : "(Tap email to enter chat)",

                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  textAlign: TextAlign.center,

                ),
              ),
              SizedBox(height: 30.0),
               //You can keep a separate "Go to Chat" button if you prefer
              //RoundButton(
                // text: 'Start Chatting',
                 //color: Colors.deepPurpleAccent,
                // onPressed: () {
                 //Navigator.pushReplacementNamed(context, ChatScreen.id);
                // },
              // ),
            ],
          ],
        ),
      ),
    );
  }
}
