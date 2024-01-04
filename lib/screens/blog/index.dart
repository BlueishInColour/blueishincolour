import 'dart:convert';

import 'package:blueishincolour/screens/blog/item2.dart';
import 'package:blueishincolour/screens/blog/write.dart';
import 'package:blueishincolour/screens/cart/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_load_more/easy_load_more.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loadmore_listview/loadmore_listview.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import '../../models/stories.dart';
import 'item.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => BlogScreenState();
}

class BlogScreenState extends State<BlogScreen>
    with AutomaticKeepAliveClientMixin {
  String url = 'http://localhost:8080/blog';

  List<Stories> listOfStories = [];
  int cartCount = 3;

  initState() {
    super.initState();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: Colors.grey[100],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return Write();
            }));
          },
          child: Icon(
            Icons.edit,
            color: Colors.white60,
          ),
        ),
        body: Center(
            child: SizedBox(
                width: 500,
                child: FutureBuilder(
                  future:
                      FirebaseFirestore.instance.collection('stories').get(),
                  builder: (context, snapshot) {
//if we have data, get all dic
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            //get indicidual doc
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];

                            if ((index / 5).ceil().isOdd) {
                              return Item(
                                picture: documentSnapshot['picture'],
                                title: documentSnapshot['title'],
                                creator: documentSnapshot['creator'],
                                onTap: () {},
                              );
                            } else {
                              return ItemTwo(
                                picture: documentSnapshot['picture'],
                                title: documentSnapshot['title'],
                                creator: documentSnapshot['creator'],
                                onTap: () {},
                              );
                            }
                          }));
                    }

                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.blue.shade600));
                  },
                ))));
  }
}
