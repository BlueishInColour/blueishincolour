import 'package:flutter/material.dart';

class ItemCaption extends StatefulWidget {
  const ItemCaption(
      {super.key,
      required this.caption,
      this.backgroundColor = Colors.blue,
      required this.isPictureAvailable});
  final String caption;
  final bool isPictureAvailable;
  final Color backgroundColor;
  @override
  State<ItemCaption> createState() => ItemCaptionState();
}

class ItemCaptionState extends State<ItemCaption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.isPictureAvailable
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))
              : null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(widget.caption, style: TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }
}
