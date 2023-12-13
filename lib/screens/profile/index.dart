import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  String url = 'http://localhost:8080/shop';
  List<Good> listOfGood = [];
  int cartCount = 3;
  Future<bool> fetch20Data() async {
    debugPrint('getting data');
    var res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {}

    Map<String, dynamic> body = json.decode(res.body);
    List product = body['products'];
    print(product.toString());
    print(product);
    List<Good> goods = product.map((e) => Good.fromJson(e)).toList();
    setState(() {
      listOfGood.addAll(goods);
    });
    return true;
  }

  initState() {
    super.initState();
    fetch20Data();
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
          title: Row(
            children: [
              SizedBox(height: 10),
              //profile
              CircleAvatar(
                radius: 30,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Oluwapelumi Eyelade',
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.black54)),
                  SizedBox(height: 10),
                  Text('@blueishInColour',
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
                  .where('creator', isEqualTo: 'blueishincolour')
                  .get(),
              builder: (context, snapshot) {
                //if we have data, get all dic

                if (snapshot.hasData) {
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
