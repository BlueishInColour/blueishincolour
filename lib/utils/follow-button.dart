import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({super.key, required this.uid});
  final String uid;

  @override
  State<FollowButton> createState() => FollowButtonState();
}

class FollowButtonState extends State<FollowButton> {
  bool haveFollowed = false;
  likeAction() async {
    var res = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    var snap = res.docs.first;
    await FirebaseFirestore.instance.collection('users').doc(snap.id).update({
      'listOfLikers': FieldValue.arrayUnion([widget.uid])
    }).whenComplete(() => setState(() {
          haveFollowed = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: likeAction,
      icon: Icon(
        LineIcons.thumbsUp,
        color: Colors.white60,
      ),
    );
  }
}
