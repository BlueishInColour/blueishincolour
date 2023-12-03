import 'dart:convert';

import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/goods.dart';

class Item extends StatefulWidget {
  const Item(
      {super.key, required this.goods, this.index = 0, required this.onTap});
  final Good goods;
  final int index;
  final Function() onTap;
  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  bool showDetail = false;

  Widget button(context, {required Function() onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blue.shade600),
          child: const Center(
            child: Text(
              'add to cart',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ));
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Good goods = widget.goods;
    int index = widget.index;
    String brand = goods.brand;
    String category = goods.category;
    List<String> images = goods.images;
    String description = goods.description;
    String rating = goods.rating.toString();
    if (goods.images.isEmpty) {
      return SizedBox();
    }
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                );
              }),
          Positioned(
              top: 15,
              left: 15,
              child: Text('$brand - $category - rating $rating ',
                  style: TextStyle(
                    backgroundColor: Colors.white54,
                    fontWeight: FontWeight.w800,
                  ))),
          Positioned(
              bottom: 15,
              left: 15,
              child: SizedBox(
                  width: 200,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('tapped');
                      setState(() {
                        showDetail = !showDetail;
                      });
                    },
                    child: showDetail
                        ? Text(description,
                            style: TextStyle(
                              backgroundColor: Colors.white54,
                              // fontWeight: FontWeight.w300,
                            ))
                        : Text('show details >',
                            style: TextStyle(
                              backgroundColor: Colors.white54,
                              // fontWeight: FontWeight.w300,
                            )),
                  ))),
          Positioned(
              right: 15,
              bottom: 15,
              child: button(context, onTap: () async {
                var url = Uri.parse(
                  'http://localhost:8080/cart',
                );
                var res = await http.post(url,
                    body: json.encode(widget.goods.toJson()),
                    headers: {"Content-Type": "application/json"});
                if (res.statusCode == 200) {
                  showSnackBar(
                      context,
                      Icon(
                        Icons.done_all_outlined,
                        color: Colors.green,
                      ),
                      'added to cart');
                } else {
                  showSnackBar(context, Icon(Icons.error, color: Colors.red),
                      'no internet connection');
                }
              })),
          Positioned(
              bottom: 3,
              right: 10,
              child: SizedBox(
                height: 10,
                width: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor: index == currentIndex
                              ? Colors.blue.shade600
                              : Colors.black54,
                        ),
                      );
                    }),
              ))
        ],
      ),
    );
  }
}
