import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';

import '../../models/goods.dart';
import '../../utils/blueishincolour_icon.dart';
import './item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin {
  String url = 'http://localhost:8080/cart';
  List<Good> listOfGood = [];
  int cartCount = 3;
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

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    fetch20Data();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // toolbarOpacity: 0,

        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Cart',
            style: GoogleFonts.pacifico(
                fontSize: 30, color: Colors.blue.shade600)),
        actions: [
          IconButton(
              onPressed: () {
                listOfGood.clear();
                fetch20Data();
              },
              icon: Icon(
                Icons.refresh_sharp,
                color: Colors.blue.shade600,
              ))
        ],
      ),
      body: listOfGood.isEmpty
          ? Container(
              margin: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue.shade600),
              ),
            )
          : Center(
              child: SizedBox(
                  width: 500,
                  child: CustomScrollView(
                    slivers: [
                      SliverList.separated(
                          //is there more data to load
                          separatorBuilder: (context, _) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                color: Colors.black45,
                              ),
                            );
                          },
                          //ListView
                          itemCount: listOfGood.length,
                          itemBuilder: (context, index) {
                            return Item(
                              goods: listOfGood[index],
                              index: index,
                              onTap: () {},
                            );
                          }),
                    ],
                  ))),

      //
      bottomSheet: Container(
        padding: EdgeInsets.all(10),
        color: Colors.blue.shade600,
        height: 80,
        child: Row(children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'checkout',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 30),
                ),
                Text(
                  'total 30,000   |  7 items',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 15),
                )
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded)
        ]),
      ),
    );
  }
}
