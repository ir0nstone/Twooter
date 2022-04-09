import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:twooter/main.dart';

class TwootScreen extends StatelessWidget {
  final User user;

  const TwootScreen(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final titleController = TextEditingController();
    final textController = TextEditingController();

    String uid = user.uid;

    Form onLoadBody = Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Email
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: titleController,
              ),

              // Password
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Text',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: textController,
              ),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  print(titleController.text + ' ' + textController.text);
                },
                child: const Text('Twoot!'),
              ),
            ],
          ),
        );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Twoot'),
        ),
        body: onLoadBody
    );
  }
}
