import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

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

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: CustomScrollView(slivers: [
          //sevices
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: [
                  //services such as fabrics, loundry, cloth makers, agents , designers, logistics,
                  GridTile(
                    child: Container(child: LineIcon.store()),
                    footer: Center(child: Text('fabric')),
                  ),
                  GridTile(
                    child: Container(child: Icon(Icons.cut_rounded)),
                    footer: Center(child: Text('designers')),
                  ),
                  GridTile(
                    child: Container(child: LineIcon.tape()),
                    footer: Center(child: Text('dressmakers')),
                  ),
                  GridTile(
                    child: Container(child: Icon(Icons.electric_bike)),
                    footer: Center(child: Text('logitics')),
                  ),
                  GridTile(
                    child: Container(child: Icon(Icons.iron)),
                    footer: Center(child: Text('loundry')),
                  ),
                  GridTile(
                    child: Container(child: Icon(Icons.shopping_bag)),
                    footer: Center(child: Text('boutque')),
                  ),
                  GridTile(
                    child: Container(child: Icon(Icons.watch)),
                    footer: Center(child: Text('accessories')),
                  ),
                  GridTile(
                    child: Container(child: Icon(Icons.bug_report_rounded)),
                    footer: Center(child: Text('report')),
                  ),
                ],
              ),
            ),
          ),

          //
        ]));
  }
}
