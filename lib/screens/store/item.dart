import 'package:blueishincolour/screens/store/more_item_in.dart';
import 'package:blueishincolour/screens/store/more_item_out.dart';
import 'package:blueishincolour/utils/steeze_off_button.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../utils/chat_button.dart';
import '../../utils/like_button.dart';

class Item extends StatefulWidget {
  const Item(
      {super.key,
      this.title = 'fake title',
      this.index = 0,
      this.pictures = const [],
      required this.showPix,
      this.id = '',
      required this.listOfLikers,
      required this.onTap});
  final int index;
  final String title;
  final Function() onTap;
  final String id;
  final List listOfLikers;
  final List<dynamic> pictures;
  final String showPix;
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
          return MoreItemIn(
            listOfLikers: widget.listOfLikers,
            title: widget.title,
            goodId: widget.id,
            listOfPictures: widget.pictures,
          );
        }));
      },
      onHorizontalDragEnd: (details) {
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
          return MoreItemOut(
            headPostid: widget.id,
          );
        }));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        // height: 300,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: widget.showPix, fit: BoxFit.fill,
                  errorWidget: (context, _, __) => Container(color: Colors.red),
                  placeholder: (context, _) =>
                      Container(color: Colors.black26, height: 500),

                  // images[index],
                ),
              ),
            ),
            // Positioned(
            //     bottom: 40,
            //     child: Container(
            //       margin: EdgeInsets.all(10),
            //       child: Text(
            //         widget.title,
            //         maxLines: 3,
            //         style: GoogleFonts.pacifico(
            //             color: Colors.white,
            //             fontWeight: FontWeight.w800,
            //             fontSize: 27),
            //       ),
            //     )),

            Positioned(
                right: 100,
                bottom: 15,
                child: SteezeOffButton(
                  headPostId: widget.id,
                )),
            Positioned(
                child: Badge(
              backgroundColor: Colors.black,
              label: Text(widget.pictures.length.toString()),
            )),
            Positioned(
              right: 15,
              bottom: 15,
              child: Row(
                children: [
                  LikeButton(
                      idType: 'goodId',
                      listOfLikers: widget.listOfLikers,
                      itemId: widget.id,
                      collection: 'goods'),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
