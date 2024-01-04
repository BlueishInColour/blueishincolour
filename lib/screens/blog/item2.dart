import 'package:blueishincolour/screens/blog/read.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemTwo extends StatefulWidget {
  const ItemTwo(
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
  State<ItemTwo> createState() => ItemTwoState();
}

class ItemTwoState extends State<ItemTwo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: widget.picture,
                    fit: BoxFit.fill,
                    errorWidget: (context, _, __) =>
                        Container(color: Colors.red),
                    placeholder: (context, _) =>
                        Container(color: Colors.black26),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  widget.title,
                  maxLines: 3,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 17),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Row(children: [
                CircleAvatar(radius: 15),
                SizedBox(width: 10),
                Text(
                  widget.creator,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                )
              ]),
              Expanded(child: SizedBox()),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite_rounded, color: Colors.white))
            ],
          ),
        ],
      ),
    );
  }
}
