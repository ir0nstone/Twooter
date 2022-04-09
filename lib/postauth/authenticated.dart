import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twooter/postauth/feed_screen.dart';
import 'package:twooter/postauth/twoot_screen.dart';

import 'account_screen.dart';

class AuthenticatedPage extends StatefulWidget {
  final User user;

  const AuthenticatedPage(this.user, {Key? key}) : super(key: key);

  @override
  State<AuthenticatedPage> createState() => AuthenticatedPageState();
}

class AuthenticatedPageState extends State<AuthenticatedPage> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;

    var pages = [
      AccountScreen(user),
      FeedScreen(user),
      TwootScreen(user)
    ];

    return Scaffold(
        body: pages.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Feed'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Twoot'
            )
          ],
          currentIndex: selectedIndex,
          onTap: onItemTapped,
        )
    );
  }
}
