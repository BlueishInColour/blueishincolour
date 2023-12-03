import 'dart:convert';

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

class ProfileScreenState extends State<ProfileScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Column(
          children: [
            SizedBox(height: 10),
            //profile
            CircleAvatar(
              radius: 50,
            ),
            Text('Oluwapelumi Eyelade'),

            SizedBox(height: 10),

            Text('@BlueishInColour'),

            SizedBox(height: 10),
          ],
        ),
      ),
      //wordrope],)
      SliverAppBar(
        title: Text('wardrope',
            style: GoogleFonts.pacifico(
                fontSize: 30, color: Colors.blue.shade600)),
        backgroundColor: Colors.transparent,
        pinned: true,
      ),
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
              onTap: () {
                setState(() {
                  cartCount = ++cartCount;
                });
              },
            );
          }),
    ]));
  }
}
