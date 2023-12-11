import 'dart:convert';

import 'package:blueishincolour/screens/blog/write.dart';
import 'package:blueishincolour/screens/cart/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_load_more/easy_load_more.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loadmore_listview/loadmore_listview.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import '../../models/stories.dart';
import '../../utils/blueishincolour_icon.dart';
import 'item.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => BlogScreenState();
}

class BlogScreenState extends State<BlogScreen> {
  String url = 'http://localhost:8080/blog';

  List<Stories> listOfStories = [];
  int cartCount = 3;
  Future<bool> fetch20Data() async {
    debugPrint('getting data');
    var res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {}

    List body = json.decode(res.body);
    // List product = body['products'];
    // print(product.toString());
    // print(product);
    List<Stories> goods = body.map((e) => Stories.fromJson(e)).toList();
    setState(() {
      listOfStories.addAll(goods);
    });
    return true;
  }

  initState() {
    super.initState();
    fetch20Data();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          // toolbarOpacity: 0,

          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Blog',
              style: GoogleFonts.pacifico(
                  fontSize: 30, color: Colors.blue.shade600)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return Write();
            }));
          },
          child: Icon(
            Icons.edit,
            color: Colors.black54,
          ),
        ),
        body: Center(
            child: SizedBox(
                width: 500,
                child: StreamBuilder(
                  stream: db
                      .collection('stories')
                      .orderBy('createdAt', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
//if we have data, get all dic
                    if (snapshot.hasData) {
                      return ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            //get indicidual doc
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];

                            return Item(
                              title: documentSnapshot['title'],
                              creator: documentSnapshot['creator'],
                              reaction: documentSnapshot['reactions'],
                              stories: Stories(createdAt: DateTime.now()),
                              onTap: () {},
                            );
                          }));
                    }

                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.blue.shade600));
                  },
                ))));
  }
}
