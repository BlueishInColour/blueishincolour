import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/store/item/item_caption.dart';
import 'package:blueishincolour/utils/like_button.dart';
import 'package:blueishincolour/utils/repost_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemHeader extends StatefulWidget {
  const ItemHeader(
      {super.key,
      required this.creatorUid,
      required this.ancestorId,
      required this.postId});
  final String creatorUid;
  final String postId;
  final String ancestorId;
  @override
  State<ItemHeader> createState() => ItemHeaderState();
}

class ItemHeaderState extends State<ItemHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.creatorUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        DocumentSnapshot snap = snapshot.data!.docs.first;
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return ProfileScreen(userUid: widget.creatorUid);
            }));
          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.blue),
            child: Column(
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    SizedBox(width: 5),
                    CircleAvatar(
                        radius: 17,
                        backgroundImage:
                            CachedNetworkImageProvider(snap['profilePicture'])),
                    SizedBox(width: 5),
                    SizedBox(
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snap['displayName'],
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            '@' '${snap['userName']}',
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 11,
                                color: Colors.white60),
                          )
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    RepostButton(
                      ancestorId: widget.ancestorId,
                      postId: widget.postId,
                    ),
                    LikeButton(
                        typeOfShowlist: '',
                        idType: 'postId',
                        postId: widget.postId,
                        collection: 'posts'),
                    SizedBox(width: 5),
                  ],
                ),
                ItemCaption(
                  caption: snap['caption'],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
