import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/cart/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => LikeScreenState();
}

class LikeScreenState extends State<LikeScreen> {
  @override
  Widget build(BuildContext context) {
    return Middle(
      width: 500,
      child: Scaffold(
          body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('likes')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('posts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = snapshot.data!.docs[index];
                  debugPrint(snapshot.data!.docs.length.toString());

                  if (snapshot.hasData) {
                    return SavedStyle(
                        postId: snap['postId'],);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }
}
