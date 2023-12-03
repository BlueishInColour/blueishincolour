import 'package:blueishincolour/screens/blog/read.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/stories.dart';

class Item extends StatefulWidget {
  const Item(
      {super.key, required this.stories, this.index = 0, required this.onTap});
  final Stories stories;
  final int index;

  final Function() onTap;
  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    Stories stories = widget.stories;

    return TextButton(
      onPressed: () {
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
          return Read(
            stories: stories,
          );
        }));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stories.title,
            style: GoogleFonts.pacifico(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.black54),
              SizedBox(width: 10),
              Text(
                widget.stories.reactions.toString(),
                style: TextStyle(color: Colors.black54),
              ),
              Expanded(child: SizedBox()),
              Text(
                stories.creatorName,
                style: GoogleFonts.pacifico(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            ],
          )
        ],
      ),
    );
  }
}
