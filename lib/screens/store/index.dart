import 'dart:convert';

import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/auth/auth_service.dart';
import 'package:blueishincolour/screens/cart/index.dart';
import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_load_more/easy_load_more.dart';
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

  Widget loadMoreWidget(context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: CircularProgressIndicator(),
    );
  }

  initState() {
    super.initState();
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
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    "spart`r",
                    style: GoogleFonts.pacifico(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await AuthService().logout();
                        },
                        icon: Icon(Icons.logout, color: Colors.black54))
                  ],
                ),
                controller: widget.controller),
            backgroundColor: Colors.white,
            body: FirestorePagination(
                // controller: widget.controller,  //this is causing a lot of controllerr error anytin=me page is wsitched
                isLive: true,
                limit: 15,
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
