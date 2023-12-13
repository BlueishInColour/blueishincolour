import 'dart:convert';

import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/goods.dart';

class Item extends StatefulWidget {
  const Item(
      {super.key,
      this.title = 'fake title',
      this.index = 0,
      this.pictures = const [],
      this.id = 0,
      required this.onTap});
  final int index;
  final String title;
  final Function() onTap;
  final int id;
  final List<String> pictures;
  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  bool showDetail = false;

  Widget button(context, {required Function() onTap}) {
    return IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.favorite_rounded,
          color: Colors.black87,
        ));
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Good goods = Good();
    int index = widget.index;
    String brand = goods.brand;
    String category = goods.category;
    List<String> images = goods.images;
    String description = goods.description;
    String rating = goods.rating.toString();

    return Container(
      margin: EdgeInsets.all(15),
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemCount: widget.pictures.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: widget.pictures[index], fit: BoxFit.fill,
                  errorWidget: (context, _, __) => Container(color: Colors.red),
                  placeholder: (context, _) => Container(color: Colors.black26),

                  // images[index],
                ),
              ),
            ),
          ),
          Positioned(
              top: 15,
              left: 15,
              child: Text(' ${widget.title}',
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
                FirebaseFirestore.instance
                    .collection('goods')
                    .where('id', isEqualTo: widget.id)
                    .get()
                    .then((querySnapshot) {
                  querySnapshot.docs.forEach((element) {
                    FirebaseFirestore.instance
                        .collection('goods')
                        .doc(element.id)
                        .update({
                      'listOfLikers': ['blueishincolour']
                    });
                  });
                });
              })),
          Positioned(
              bottom: 3,
              right: 10,
              child: SizedBox(
                height: 10,
                width: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.pictures.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor: index == currentIndex
                              ? Colors.blue.shade600
                              : Colors.white,
                        ),
                      );
                    }),
              ))
        ],
      ),
    );
  }
}
