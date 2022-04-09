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
          ),

          // Submit Button
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text
                ).then((userCredential) => {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => AuthenticatedPage(userCredential.user!),
                    ),
                  )
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
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