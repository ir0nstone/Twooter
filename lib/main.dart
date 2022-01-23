import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth/register.dart';
import 'auth/login.dart';

import 'view/account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
  // function to load the user currently logged in
  _loadLoggedInUser() async {
    // User? user = FirebaseAuth.instance.currentUser;
    //
    // if (user != null) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => AccountPage(user.uid),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    // _loadLoggedInUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Center(
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
      )
    );
  }
}
