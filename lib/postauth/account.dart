import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class AccountPage extends StatelessWidget {
  final User user;

  const AccountPage(this.user, {Key? key}) : super(key: key);

  Future<List> getPosts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot posts = await firestore.collection('posts').get();
    // Get data from docs and convert map to List
    final allData = posts.docs.map((doc) => doc.data()).toList();

    print(allData);
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final titleController = TextEditingController();
    final textController = TextEditingController();

    String uid = user.uid;

    Column onLoadBody = Column(
      children: [
        Text('Uid: $uid'),

        ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // send back navigator
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            child: const Text('Sign Out')
        ),

        Form(
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
        )
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: FutureBuilder(
            future: getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return onLoadBody;
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        )
    );
  }
}