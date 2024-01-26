import 'package:blueishincolour/screens/store/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SavedStyle extends StatefulWidget {
  const SavedStyle({
    super.key,
    required this.postId,
    required this.typeOfShowlist,
    // required this.timesamp
  });

  // final Timestamp timesamp;
  final String postId;
  final String typeOfShowlist;

  getPost(String postId) async {}
  @override
  State<SavedStyle> createState() => SavedStyleState();
}

class SavedStyleState extends State<SavedStyle> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('postId', isEqualTo: widget.postId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(color: Colors.black, height: 200);
          }
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data!.docs[0];

            return Item(
              typeOfShowlist: widget.typeOfShowlist,
              swipeBack: false,
              creatorProfilePicture: documentSnapshot['creatorProfilePicture'],
              creatorDisplayName: documentSnapshot['creatorDisplayName'],
              creatorUserName: documentSnapshot['creatorUserName'],
              creatorUid: documentSnapshot['creatorUid'],
              showPix: documentSnapshot['images'][0],
              onTap: () {},
              // index: index,
              title: documentSnapshot['title'],
              pictures: documentSnapshot['images'],
              postId: documentSnapshot['postId'],
              headPostId: documentSnapshot['headPostId'],
              ancestorId: documentSnapshot['ancestorId'],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }
}
