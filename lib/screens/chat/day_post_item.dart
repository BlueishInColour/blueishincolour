import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/screens/profile/index.dart';
import 'package:dressr/screens/store/more_item_in.dart';
import 'package:flutter/material.dart';

class DayPostItem extends StatefulWidget {
  const DayPostItem({super.key, required this.data});
  final DocumentSnapshot<Object?> data;
  @override
  State<DayPostItem> createState() => DayPostItemState();
}

class DayPostItemState extends State<DayPostItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //

          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return MoreItemIn(
                postId: widget.data['postId'],
                ancestorId: widget.data['ancestorId'],
                creatorUid: widget.data['creatorUid']);
          }));
        },
        child: Stack(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          CachedNetworkImageProvider(widget.data['picture']))),
            ),

            //profilePictureOFCreator
            Positioned(
              top: 5,
              right: 5,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.data['creatorUid'])
                      .get(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircleAvatar();
                    }
                    if (snapshot.hasData) {
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              PageRouteBuilder(pageBuilder: (context, _, __) {
                            return ProfileScreen(
                                userUid: widget.data['creatorUid']);
                          }));
                        },
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              snapshot.data?['picture']),
                        ),
                      );
                    }
                    return CircleAvatar();
                  })),
            ),
          ],
        ));
  }
}

// import 'package:flutter/material.dart';

