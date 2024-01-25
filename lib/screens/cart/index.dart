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
      child: Scaffold(
          body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('likes')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('posts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot snap = snapshot.data!.docs.first;
            return SavedStyle(postId: snap['postId'], typeOfShowlist: '');
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }
}
