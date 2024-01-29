import 'package:blueishincolour/screens/store/item/item_caption.dart';
import 'package:blueishincolour/screens/store/item/item_header.dart';
import 'package:blueishincolour/screens/store/item/item_picture.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OfflineItem extends StatefulWidget {
  const OfflineItem(
      {super.key,
      required this.caption,
      required this.picture,
      required this.onTap,
      this.borderActiveColor = Colors.transparent});
  final String caption;
  final String picture;
  final Color borderActiveColor;
  final Function()? onTap;
  @override
  State<OfflineItem> createState() => OfflineItemState();
}

class OfflineItemState extends State<OfflineItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: widget.borderActiveColor, width: 0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.blue),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.caption,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Divider(),
            Container(
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.picture,
                  placeholder: (context, string) {
                    return Container();
                  },
                  errorWidget: (context, _, __) {
                    return Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
