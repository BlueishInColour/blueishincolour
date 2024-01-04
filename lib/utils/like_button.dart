import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  const LikeButton(
      {super.key,
      required this.itemId,
      required this.collection,
      required this.listOfLikers});

  final String collection;
  final String itemId;
  final List listOfLikers;

  @override
  State<LikeButton> createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> {
  bool haveLiked = false;

  checkLike() async {
    if (widget.listOfLikers.contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        haveLiked = true;
      });
    }
  }

  @override
  initState() {
    super.initState();
    checkLike();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        debugPrint('clicked');
        QuerySnapshot<Map<String, dynamic>> docs = await FirebaseFirestore
            .instance
            .collection(widget.collection)
            .where('goodId', isEqualTo: widget.itemId)
            .get();
        print(docs);
        for (var snapshot in docs.docs) {
          print('started to find love');
          print(snapshot.id);

          if (haveLiked == false) {
            await FirebaseFirestore.instance
                .collection(widget.collection)
                .doc(snapshot.id)
                .update({
              'listOfLikers': FieldValue.arrayUnion(
                  [FirebaseAuth.instance.currentUser!.uid])
            }).whenComplete(() => setState(() {
                      haveLiked = true;
                    }));

            debugPrint('done');
          } else {
            await FirebaseFirestore.instance
                .collection(widget.collection)
                .doc(snapshot.id)
                .update({
              'listOfLikers': FieldValue.arrayRemove(
                  [FirebaseAuth.instance.currentUser!.uid])
            }).whenComplete(() => setState(() {
                      haveLiked = false;
                    }));
          }
        }
      },
      icon: Icon(Icons.favorite_rounded,
          color:
              haveLiked ? const Color.fromARGB(255, 255, 17, 0) : Colors.white,
          size: 30),
    );
  }
}
