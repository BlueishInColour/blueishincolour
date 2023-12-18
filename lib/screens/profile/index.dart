import 'dart:convert';

import 'package:blueishincolour/screens/profile/edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../models/goods.dart';
import 'item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  List<Good> listOfGood = [];
  int cartCount = 3;
  String? displayName = FirebaseAuth.instance.currentUser == null
      ? 'no name'
      : FirebaseAuth.instance.currentUser?.displayName;
  String userName = FirebaseAuth.instance.currentUser!.uid;

  @override
  initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
      print(FirebaseAuth.instance.currentUser?.email);
      print(FirebaseAuth.instance.currentUser?.displayName);
    }
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(5),
      child: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          floating: true,
          elevation: 0,
          toolbarHeight: 60,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (context, _, __) {
                  return EditProfile();
                }));
              },
              child: Text('edit'),
            )
          ],
          title: Row(
            children: [
              SizedBox(height: 10),
              //profile
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black,
                backgroundImage: CachedNetworkImageProvider(
                    FirebaseAuth.instance.currentUser!.photoURL!),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('oluwapelumi',
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black)),
                  SizedBox(height: 10),
                  Text(userName,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45)),
                  SizedBox(height: 10),
                ],
              ),
              Expanded(
                child: SizedBox(),
              ),
              Column(children: [Text('posts'), Text('34')])
            ],
          ),
        ),
        //wordrope],

        SliverToBoxAdapter(
          child: Divider(),
        ),

        SliverToBoxAdapter(
          child: Container(
            height: 500,
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('stories')
                  .where('creator',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          ),
        )
      ]),
    ));
  }
}
