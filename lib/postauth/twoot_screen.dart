import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TwootScreen extends StatelessWidget {
  final User user;

  const TwootScreen(this.user, {Key? key}) : super(key: key);

  void sendTwoot(String title, String text) async {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = FirebaseFirestore.instance.collection('posts');

      await reference.add(
          {
            "title": title,
            "text": text,
            "createdOn": FieldValue.serverTimestamp(),
            "userID": user.uid
          }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();


    final titleController = TextEditingController();
    final textController = TextEditingController();

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
                  sendTwoot(titleController.text, textController.text);
                  titleController.text = '';
                  textController.text = '';
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
