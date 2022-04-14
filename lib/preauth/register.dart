import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:twooter/postauth/authenticated.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Column(
          children: const [
            RegisterForm()
          ],
        )
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Username
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: usernameController,
          ),

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

          // Submit Button
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              try {
                UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text
                );

                User user = userCredential.user!;
                CollectionReference reference = FirebaseFirestore.instance.collection('users');

                DocumentReference doc = reference.doc(user.uid);
                await doc.set({"username": usernameController.text});

                await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AuthenticatedPage(userCredential.user!),
                  ),
                  (route) => false
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('Weak Password!');
                } else if (e.code == 'email-already-in-use') {
                  print('Email in Use!');
                }
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}