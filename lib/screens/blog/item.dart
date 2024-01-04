import 'package:blueishincolour/screens/blog/read.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Item extends StatefulWidget {
  const Item(
      {super.key,
      this.title = '',
      this.creator = '',
      this.reaction = 0,
      this.picture = '',
      this.index = 0,
      required this.onTap});
  final int index;
  final String title;
  final String creator;
  final int reaction;
  final String picture;

  final Function() onTap;
  @override
  State<Item> createState() => ItemState();
}

//

//

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: widget.picture,
              fit: BoxFit.fill,
              errorWidget: (context, _, __) => Container(color: Colors.red),
              placeholder: (context, _) => Container(color: Colors.black26),
            ),
          ),
          Positioned(
              bottom: 50,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  widget.title,
                  maxLines: 3,
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 27),
                ),
              )),
          Positioned(
            top: 15,
            left: 15,
            child: Row(children: [
              CircleAvatar(radius: 15),
              SizedBox(width: 10),
              Text(
                widget.creator,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14),
              )
            ]),
          ),
          Positioned(
              bottom: 15,
              right: 15,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite_rounded, color: Colors.white)))
        ],
      ),
    );
  }
}
