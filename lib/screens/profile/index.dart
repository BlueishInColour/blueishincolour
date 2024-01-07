import 'package:blueishincolour/screens/profile/edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  String userName = 'oluwa';
  String displayName = '@blue';
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

    setState(() {
      uid = snap['uid'];
      userName = snap['userName'];
      displayName = snap['displayName'];
      // userPix = snap['userPix'];
    });
    return {'userName': userName};
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
          actions: [
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(context,
            //         PageRouteBuilder(pageBuilder: (context, _, __) {
            //       return EditProfile();
            //     }));
            //   },
            //   child: Text('edit'),
            // )
          ],
          title: Row(
            children: [
              SizedBox(height: 10),
              //profile
              CircleAvatar(),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(displayName,
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  SizedBox(height: 10),
                  Text(userName,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white60)),
                  SizedBox(height: 10),
                ],
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
                    .where('uid', isEqualTo: uid)
                    .get(),
                builder: (context, snapshot) {
                  //if we have data, get all dic

                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(' no content yet'),
                      );
                    }
                    return GridView.builder(
                      itemCount: snapshot.data?.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2),
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Item(
                          picture: documentSnapshot['picture'],
                        );
                      },
                    );
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
