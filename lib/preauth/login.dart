import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:twooter/postauth/authenticated.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
          children: const [
            LoginForm()
          ],
        )
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMsg = '';

  updateErrorMsg(String error) {
    setState(() {
      errorMsg = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Email
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: emailController,
          ),

          // Password
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: passwordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),

          Container(
            constraints: const BoxConstraints(minHeight: 40),
            alignment: Alignment.center,
            child: Text(
              errorMsg,
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16
              ),
            ),
          ),

          // Submit Button
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              try {
                UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text
                );

                await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AuthenticatedPage(userCredential.user!),
                  ),
                  (route) => false
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  updateErrorMsg('User Not Found');
                } else if (e.code == 'wrong-password') {
                  print('Incorrect Password');
                }
              }
            },
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }
}