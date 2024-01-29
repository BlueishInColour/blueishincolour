import 'package:blueishincolour/screens/store/item/item_caption.dart';
import 'package:blueishincolour/screens/store/item/item_header.dart';
import 'package:blueishincolour/screens/store/item/item_picture.dart';
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
        decoration: BoxDecoration(
            border: Border.all(color: widget.borderActiveColor, width: 2),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            // header with
            ItemHeader(
                creatorUid: FirebaseAuth.instance.currentUser!.uid,
                ancestorId: '',
                postId: '',
                showButtons: false),

            // caption
            ItemCaption(caption: widget.caption, backgroundColor: Colors.blue),
            //pictures
            ItemPicture(
              picture: widget.picture,
            )
          ],
        ),
      ),
    );
  }
}
