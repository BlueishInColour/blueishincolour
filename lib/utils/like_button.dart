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
  like() async {
    await FirebaseFirestore.instance
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('posts')
        .doc(widget.postId)
        .set({
      //likedById
      'likedBy': FirebaseAuth.instance.currentUser!.uid,
      //post id
      'postId': widget.postId,
      //timeStamp
      'timestamp': Timestamp.now()
      //
    });
  }

  dislike() async {
    await FirebaseFirestore.instance
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('posts')
        .doc(widget.postId)
        .delete();

    debugPrint('deleted');
  }

  action() async {
    var res = await FirebaseFirestore.instance
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('posts')
        .doc(widget.postId)
        .get();
    res.exists ? dislike() : like();
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('likes')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('posts')
            .doc(widget.postId)
            .snapshots(),
        builder: (context, snapshot) {
          bool haveLiked = snapshot.data!.exists;


          if(snapshot.connectionState==ConnectionState.active ||snapshot.connectionState == ConnectionState.waiting){return
        IconButton(
              onPressed: action,
              icon: Icon(
                LineIcons.heart,
                color: Colors.white60,
                size: 20,
              ),
            ); }
            else if(snapshot.connectionState == ConnectionState.done){  if (!snapshot.hasData) {
            return IconButton(
              onPressed: action,
              icon: Icon(
                LineIcons.heart,
                color: Colors.white60,
                size: 20,
              ),
            );
          }
          return haveLiked
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
                );}
        else{return CircularProgressIndicator();}
        });
  }
}
