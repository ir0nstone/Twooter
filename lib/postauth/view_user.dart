import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewUserScreen extends StatelessWidget {
  final String userID;

  const ViewUserScreen(this.userID, {Key? key}) : super(key: key);

  Future<String> getUsername(String userID) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    return userDoc.get("username");
  }

  Future<Widget> getFinalWidget(String userID) async {
    String username = await getUsername(userID);

    TextStyle textStyle = const TextStyle(fontSize: 16);

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
                columnWidths: const {0: FlexColumnWidth(0.4)},
                children: [
                  TableRow(
                      children: [
                        Text('Username', style: textStyle),
                        Text(username, style: textStyle)
                      ]
                  )
                ]
            )
        )
      ],
    );

    return onLoadBody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: FutureBuilder(
            future: getFinalWidget(userID),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data as Widget;
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        ),
    );
  }
}
