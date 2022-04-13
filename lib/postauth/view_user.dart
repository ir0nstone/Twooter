import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewUserScreen extends StatelessWidget {
  final User user;

  const ViewUserScreen(this.user, {Key? key}) : super(key: key);

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
