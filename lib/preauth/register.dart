import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text
                );

                Navigator.pop(context);
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