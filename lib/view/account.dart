import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final String uid;

  const AccountPage(this.uid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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