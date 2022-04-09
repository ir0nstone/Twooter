import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:twooter/main.dart';

class AccountScreen extends StatelessWidget {
  final User user;

  const AccountScreen(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(fontSize: 16);

    String? email = user.email;
    String uid = user.uid;

    Widget onLoadBody = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.fromSize(
          size: const Size.fromRadius(200),
          child: const FittedBox(
            child: Icon(Icons.person),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 50.0),
          child: Table(
            columnWidths: const {0: FlexColumnWidth(0.2)},
            children: [
              TableRow(
                children: [
                  Text('Email', style: textStyle),
                  Text(email!, style: textStyle)
                ]
              ),
              TableRow(
                children: [
                  Text('Uid', style: textStyle),
                  Text(uid, style: textStyle)
                ]
              ),
            ]
          )
        ),

        Container(
          padding: const EdgeInsets.only(top: 200.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(250, 50)
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // send back navigator
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage()
                ),
              );
            },
            child: const Text('Sign Out')
          ),
        )
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: onLoadBody
    );
  }
}
