import 'dart:convert';

import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../models/goods.dart';
import '../../utils/chat_button.dart';
import '../../utils/like_button.dart';
import '../chat/item.dart';

class Item extends StatefulWidget {
  const Item(
      {super.key,
      this.title = 'fake title',
      this.index = 0,
      this.pictures = const [],
      this.id = '',
      required this.listOfLikers,
      required this.onTap});
  final int index;
  final String title;
  final Function() onTap;
  final String id;
  final List listOfLikers;
  final List<dynamic> pictures;
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
          color: Colors.white,
        ));
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
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
              bottom: 40,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  widget.title,
                  maxLines: 3,
                  style: GoogleFonts.pacifico(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 27),
                ),
              )),
          Positioned(
            right: 15,
            bottom: 15,
            child: Row(
              children: [
                LikeButton(
                    listOfLikers: widget.listOfLikers,
                    itemId: '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
                    collection: 'goods'),
                ChatButton(
                    displayName: 'oluwapelumi', userName: 'blueishincolour'),
                SizedBox(width: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
