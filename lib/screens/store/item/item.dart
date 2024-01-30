import 'package:blueishincolour/screens/store/item/item.dart';
import 'package:blueishincolour/screens/store/item/item_caption.dart';
import 'package:blueishincolour/screens/store/item/item_header.dart';
import 'package:blueishincolour/screens/store/item/item_picture.dart';
import 'package:blueishincolour/screens/store/more_item_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Item extends StatefulWidget {
  const Item({
    super.key,
    required this.postId,
    // required this.typeOfShowlist,
    // required this.timesamp
  });

  // final Timestamp timesamp;
  final String postId;
  // final String typeOfShowlist;

  getPost(String postId) async {}
  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            // .where('postId', isEqualTo: widget.postId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(color: Colors.black, height: 200);
          }
          if (snapshot.hasData) {
            DocumentSnapshot snap = snapshot.data!;
            String picture = snap['picture'];
            bool isPictureAvailable = picture.isEmpty;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (context, _, __) {
                    return MoreItemIn(
                      ancestorId: snap['ancestorId'],
                      creatorUid: snap['creatorUid'],
                      postId: widget.postId,
                    );
                  }));
                },
                child: Column(
                  children: [
                    ItemHeader(
                      postId: snap['postId'],
                      ancestorId: snap['ancestorId'],
                      creatorUid: snap['creatorUid'],
                    ),
                    ItemCaption(
                      caption: snap['caption'],
                      isPictureAvailable: isPictureAvailable,
                    ),
                    ItemPicture(
                      picture: snap['picture'],
                      postId: snap['postId'],
                    )
                  ],
                ),
              ),
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
