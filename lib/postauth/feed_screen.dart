import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:twooter/main.dart';

@immutable
class Post {
  final String documentId;
  final String title;
  final String text;

  const Post({
    required this.documentId,
    required this.title,
    required this.text
  });

  Post.fromSnapshot(QueryDocumentSnapshot<Object?> doc)
    : documentId = doc.id,
      title = doc.get('title'),
      text = doc.get('text');
}

class FeedScreen extends StatelessWidget {
  final User user;

  const FeedScreen(this.user, {Key? key}) : super(key: key);

  Future<List<Post>> getPosts() async {
    QuerySnapshot posts = await FirebaseFirestore.instance.collection('posts').get();
    // Get data from docs and convert map to List

    final allData = posts.docs.map(
            (doc) => Post.fromSnapshot(doc)
    ).toList();

    return allData;
  }

  Column postToColumn(Post post) {
    Column postColumn = Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 30, top: 30, bottom: 10),
          alignment: Alignment.centerLeft,
          child: Text(
              post.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          child: Text(
            post.text,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400
            ),
          ),
        )
      ],
    );

    return postColumn;
  }

  ListView postsToColumn(List<Post> postList) {
    List<Widget> postWidgets = postList.map((p) => postToColumn(p)).toList();
    ListView posts = ListView(children: postWidgets);

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: FutureBuilder(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return postsToColumn(snapshot.data as List<Post>);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }
}