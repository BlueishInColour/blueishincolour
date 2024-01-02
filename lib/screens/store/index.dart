import 'dart:convert';

import 'package:blueishincolour/screens/cart/index.dart';
import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_load_more/easy_load_more.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loadmore_listview/loadmore_listview.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import '../../models/goods.dart';
import '../../utils/blueishincolour_icon.dart';
import 'item.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen>
    with AutomaticKeepAliveClientMixin {
  bool click = false;
  String url = 'http://localhost:8080/shop';
  List<Good> listOfGood = [];
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
    return Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return AddItem();
            }));
          },
          child: Icon(Icons.add, color: Colors.white60),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
                forceMaterialTransparency: true,
                toolbarHeight: 50,
                floating: true,
                // pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: SizedBox(height: 45, child: BlueishInColourIcon())),
            SliverToBoxAdapter(
              child: StreamBuilder(
                stream: db.collection('goods').snapshots(),
                builder: (context, snapshot) {
//if we have data, get all dic
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 500,
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: ((context, index) {
                            //get indicidual doc
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];

                            return Item(
                              showPix: documentSnapshot['images'][0],
                              onTap: () {},
                              listOfLikers: documentSnapshot['listOfLikers'],
                              title: documentSnapshot['title'],
                              pictures: documentSnapshot['images'],
                              id: documentSnapshot['goodId'],
                            );
                          })),
                    );
                  }

                  return Center(
                      child: CircularProgressIndicator(
                          color: Colors.blue.shade600));
                },
              ),
            )
          ],
        ));
  }
}
