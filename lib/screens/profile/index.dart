import 'package:blueishincolour/screens/profile/edit_profile.dart';
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String userName = '';
  String displayName = '';
  String profilePicture = '';
  String userPix = '';
  getUserDetails() async {
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

    getUserDetails();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 60,
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (context, _, __) {
                  return EditProfile();
                }));
              },
              child: Text('edit', style: TextStyle(color: Colors.black54)),
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10),
              //profile
              CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(profilePicture)),
              SizedBox(width: 10),
              SizedBox(
                height: 45,
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(displayName,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    Text(userName,
                        style: TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54)),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              // Column(children: [Text('posts'), Text('34')])
            ],
          ),
        )
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
                    .where('creatorUid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
