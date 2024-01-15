import 'package:blueishincolour/screens/auth/auth_service.dart';
import 'package:blueishincolour/screens/profile/edit_profile.dart';
import 'package:blueishincolour/utils/chat_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/goods.dart';
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
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                )),
            elevation: 0,
            toolbarHeight: 60,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                  onPressed: () {
                    AuthService().logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.black,
                  )),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(context,
              //         PageRouteBuilder(pageBuilder: (context, _, __) {
              //       return EditProfile();
              //     }));
              //   },
              //   child: Text('edit', style: TextStyle(color: Colors.black54)),
              // )
            ],
            title: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(profilePicture),
              ),
              title: Text(
                displayName,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                uid == FirebaseAuth.instance.currentUser!.uid
                    ? '@${userName}' ' | ' 'my profile'
                    : '@${userName}',
                style: TextStyle(color: Colors.black),
              ),
              trailing: ChatButton(
                  userName: userName,
                  postId: '',
                  displayName: displayName,
                  profilePicture: displayName,
                  uid: uid),
            ))
        //wordrope],
        ,
        body: Container(
          padding: EdgeInsets.all(5),
          child: ListView(children: [
            Container(
              height: 500,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('goods')
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
                            picture: item['images'][0],
                          );
                        });
                  }

                  return GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    children: [
                      Container(color: Colors.black26),
                      Container(color: Colors.black26),
                      Container(color: Colors.black26),
                      Container(color: Colors.black26),
                    ],
                  );
                },
              ),
            )
          ]),
        ));
  }
}
