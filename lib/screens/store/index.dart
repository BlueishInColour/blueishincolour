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

  //
  Future<bool> fetch20Data() async {
    debugPrint('getting data');
    var res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {}

    List body = json.decode(res.body);
    // List product = body['products'];
    // print(product.toString());
    // print(product);
    List<Good> goods = body.map((e) => Good.fromJson(e)).toList();
    setState(() {
      listOfGood.addAll(goods);
    });
    return true;
  }

  Widget loadMoreWidget(context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: CircularProgressIndicator(),
    );
  }

  initState() {
    super.initState();
    fetch20Data();
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
      appBar: AppBar(
          // toolbarOpacity: 0,

          elevation: 0,
          backgroundColor: Colors.transparent,
          title: BlueishInColourIcon()),
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
      body: StreamBuilder(
        stream: db.collection('goods').snapshots(),
        builder: (context, snapshot) {
//if we have data, get all dic
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  //get indicidual doc
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];

                  return Item(
                    onTap: () {},
                    title: documentSnapshot['title'],
                    pictures: documentSnapshot['images'],
                    id: documentSnapshot['goodId'],
                  );
                }));
          }

          return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade600));
        },
      ),
    );
  }
}
