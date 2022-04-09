import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'preauth/register.dart';
import 'preauth/login.dart';
import 'postauth/authenticated.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  loadLoggedInUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {   // https://fluttercorner.com/error-thrown-on-navigator-pop-until-debuglocked-is-not-true/
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthenticatedPage(user),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Center buttons = Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage())
                  );
                },
                child: const Text('Log In'),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage())
                  );
                },
                child: const Text('Register'),
              ),
            ),
          ],
        )
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: FutureBuilder(
        future: loadLoggedInUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return buttons;
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }
}

// https://firebase.flutter.dev/docs/auth/usage/
// https://blog.logrocket.com/implementing-firebase-authentication-in-a-flutter-app/#register-a-new-user
