import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twooter/postauth/view_user.dart';

@immutable
class Post {
  final String documentId;
  final String title;
  final String text;
  final Timestamp createdOn;
  final String username;

  const Post({
    required this.documentId,
    required this.title,
    required this.text,
    required this.createdOn,
    required this.username
  });

  static Future<Post> fromSnapshot(QueryDocumentSnapshot<Object?> doc) async {
    final _documentId = doc.id;
    final _title = doc.get('title');
    final _text = doc.get('text');
    final _createdOn = doc.get('createdOn');
    final _userID = doc.get('userID');


    final userDoc = await FirebaseFirestore.instance.collection('users').doc(_userID).get();
    final username = userDoc.get("username");

    print(username);

    return Post(documentId: _documentId, title: _title, text: _text, createdOn: _createdOn, username: username);
  }
}

class FeedScreen extends StatelessWidget {
  final User user;

  FeedScreen(this.user, {Key? key}) : super(key: key);

  Future<List<Post>> getPosts() async {
    QuerySnapshot posts = await FirebaseFirestore.instance.collection('posts').get();

    final allData = posts.docs.map(
            (doc) async => await Post.fromSnapshot(doc)
    ).toList();

    print(allData);                             // [Instance of 'Future<Post>', Instance of 'Future<Post>', Instance of 'Future<Post>']

    final futurePosts = Future.wait(allData);
    print(futurePosts);                         // Instance of 'Future<List<Post>>'

    // why does this always return null???
    return futurePosts;
  }

  Column postToColumn(BuildContext context, Post post) {
    Column postColumn = Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, top: 30, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                post.title,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700
                ),
              ),
            ),

            Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 30, right: 10, top: 30, bottom: 10),
                  alignment: Alignment.centerRight,
                  child:
                  InkWell(
                    child: Text(
                      post.username,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          // again, the issue here is that `user` is the current user, not the post's user
                          MaterialPageRoute(builder: (context) => ViewUserScreen(user))
                      );
                    }
                  )
                ),
            )
          ],
        ),

        Container(
          padding: const EdgeInsets.only(left: 30, bottom: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            DateFormat('dd/MM/yyyy').format(post.createdOn.toDate()),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200
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

  ListView postsToColumn(BuildContext context, List<Post> postList) {
    List<Widget> postWidgets = postList.map((p) => postToColumn(context, p)).toList();
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
            if (snapshot.hasError) {
              print(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data);
              return postsToColumn(context, snapshot.data as List<Post>);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }
}