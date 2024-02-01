import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/auth/auth_service.dart';
import 'package:blueishincolour/screens/profile/edit_profile.dart';
import 'package:blueishincolour/utils/chat_button.dart';
import 'package:blueishincolour/utils/follow-button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../models/posts.g..dart';
import 'item.dart';

// final String uid =cc FirebaseAuth.instance.currentUser!.uid;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userUid});
  final String userUid;

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  String uid = '';
  String userName = '';
  String displayName = '';
  String profilePicture = '';
  String userPix = '';
  getUserDetails(String uid) async {
    QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    // DocumentSnapshot snapshot = documentSnapshot.
    QueryDocumentSnapshot snap = documentSnapshot.docs[0];
    debugPrint(snap['uid']);
    debugPrint(snap['userName']);

    debugPrint(snap['displayName']);
    debugPrint(snap['profilePicture']);

    setState(() {
      uid = snap['uid'];
      userName = snap['userName'];
      displayName = snap['displayName'];
      profilePicture = snap['profilePicture'];
      // userPix = snap['userPix'];
    });
    return {
      'userName': snap['userName'],
      'displayName': snap['displayName'],
      'profilePicture': snap['profilePicture'],
      'uid': snap['uid']
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserDetails(widget.userUid);
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Middle(
      child: Scaffold(
        //wordrope],

        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .where('creatorUid', isEqualTo: widget.userUid)
              .get(),
          builder: (context, snapshot) {
            //if we have data, get all dic

            if (snapshot.hasData) {
              if (userName.isEmpty) {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(' no content yet'),
                );
              }
              return MasonryView(
                  itemPadding: 3,
                  listOfItem: snapshot.data!.docs,
                  numberOfColumn: 4,
                  itemBuilder: (item) {
                    return Item(
                      caption: item['caption'],
                      picture: item['picture'],
                      ancestorId: item['ancestorId'],
                      postId: item['postId'],
                      creatorUid: item['creatorUid'],
                    );
                  });
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
        bottomSheet: GestureDetector(
            // onTap: showBottomSheet,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                height: 70,
                child: ListTile(
                  leading: BackButton(
                    color: Colors.white60,
                  ),
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.all(0),
                  minLeadingWidth: 0,
                  title: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(profilePicture),
                    ),
                    title: Text(
                      displayName,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white70),
                    ),
                    subtitle: Text(
                      uid == FirebaseAuth.instance.currentUser!.uid
                          ? '@${userName}' ' | ' 'my profile'
                          : '@${userName}',
                      maxLines: 1,
                      style: TextStyle(color: Colors.white60),
                    ),
                    trailing: FollowButton(
                        userUid: widget.userUid,
                        displayName: displayName,
                        profilePicture: profilePicture,
                        userName: userName),
                  ),
                ))),
      ),
    );
  }
}
