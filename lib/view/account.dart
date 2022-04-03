import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatelessWidget {
  final User user;

  const AccountPage(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = user.uid;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: Column(
          children: [
            Text('Uid: $uid')
          ],
        )
    );
  }
}