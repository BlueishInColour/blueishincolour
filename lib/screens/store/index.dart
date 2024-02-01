import 'dart:convert';

import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/auth/auth_service.dart';
import 'package:blueishincolour/screens/cart/index.dart';
import 'package:blueishincolour/screens/chat/index.dart';
import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_load_more/easy_load_more.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidable/hidable.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loadmore_listview/loadmore_listview.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/posts.dart';
import '../../utils/blueishincolour_icon.dart';
import 'item/item.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<StoreScreen> createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController searchBarController = TextEditingController();
  bool click = false;
  String url = 'http://localhost:8080/shop';
  List<Post> listOfPost = [];
  int cartCount = 3;
  String profilePicture = '';
  Widget loadMoreWidget(context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: CircularProgressIndicator(),
    );
  }

  setProfilePicture() async {
    var data = getUserDetails(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      profilePicture = data['profilePicture'];
    });
  }

  initState() {
    super.initState();
    setProfilePicture();
  }

  button(context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          click = !click;
        });
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          height: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: click ? Colors.blue.shade600 : Colors.black54)),
          child: Center(
            child: Text('price',
                style: TextStyle(fontSize: 11, color: Colors.black54)),
          )),
    );
  }

  PageStorageBucket bucket = PageStorageBucket();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Middle(
        width: 500,
        child: Scaffold(
            appBar: Hidable(
                enableOpacityAnimation: true,
                preferredWidgetSize: Size.fromHeight(90),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Row(
                    children: [
                      Image.asset('assets/icon.png', height: 30),
                      SizedBox(width: 10),
                      Text(
                        "dress`r",
                        style: GoogleFonts.pacifico(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              PageRouteBuilder(pageBuilder: (context, _, __) {
                            return ChatScreen();
                          }));
                        },
                        icon: Icon(
                          LineIcons.facebookMessenger,
                          color: Colors.black,
                        )),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              PageRouteBuilder(pageBuilder: (context, _, __) {
                            return ProfileScreen(
                                userUid:
                                    FirebaseAuth.instance.currentUser!.uid);
                          }));
                        },
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              var pictureUrl = snapshot.data!['profilePicture'];
                              return CircleAvatar(
                                radius: 12,
                                backgroundImage:
                                    CachedNetworkImageProvider(pictureUrl),
                              );
                            }),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    )
                  ],
                ),
                controller: widget.controller),
            backgroundColor: Colors.white,
            body: FirestorePagination(
                isLive: true,
                limit: 20,
                onEmpty: Text('thats all for now'),
                query: db
                    .collection('posts')
                    .orderBy('timestamp', descending: true),
                itemBuilder: (context, document, snapshot) {
                  //if we have data, get all dic

                  return Item(
                    postId: document['postId'],
                  );
                }
                //

                )));
  }
}
