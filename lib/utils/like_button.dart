import 'package:blueishincolour/utils/add_showlist_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.postId,
    required this.collection,
    required this.typeOfShowlist,
    required this.idType,
  });

  final String collection;
  final String typeOfShowlist;
  final String postId;
  final String idType; //canbe postsid or style id

  @override
  State<LikeButton> createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> {
  bool haveLiked = false;
  checkLike() async {
    var res = FirebaseFirestore.instance
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('posts')
        .where('postId', isEqualTo: widget.postId)
        .snapshots();
    if (await res.isEmpty) {
      setState(() {
        haveLiked = false;
      });
    } else {
      haveLiked = true;
    }
  }

  like() async {
    await FirebaseFirestore.instance
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('posts')
        .add({
      //likedById
      'likedBy': FirebaseAuth.instance.currentUser!.uid,
      //post id
      'postId': widget.postId,
      //timeStamp
      'timestamp': Timestamp.now()
      //
    }).whenComplete(() => setState(() {
              haveLiked = true;
            }));
  }

  dislike() async {
    var res = await FirebaseFirestore.instance
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('posts')
        .where('postId', isEqualTo: widget.postId)
        .get();
    String id = res.docs.first.id;
    await FirebaseFirestore.instance
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('posts')
        .doc(id)
        .delete()
        .whenComplete(() => setState(() {
              haveLiked = false;
            }));

    debugPrint('deleted');
  }

  action() {
    !haveLiked ? dislike() : like();
  }

  @override
  initState() {
    super.initState();

    checkLike();
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      backgroundColor: Colors.white,
      label: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('likes')
              // .doc()
              // .collection('posts')
              .where('postId', isEqualTo: widget.postId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var counts = snapshot.data!.docs.length.toString();
              return Text(counts, style: TextStyle(color: Colors.black));
            } else {
              return Text('0');
            }
          }),
      child: haveLiked
          ? IconButton(
              onPressed: action,
              icon: Icon(
                Icons.favorite,
                color: const Color.fromARGB(255, 255, 17, 0),
                size: 20,
              ),
            )
          : IconButton(
              onPressed: action,
              icon: Icon(
                LineIcons.heart,
                color: Colors.white60,
                size: 20,
              ),
            ),
    );
  }
}
