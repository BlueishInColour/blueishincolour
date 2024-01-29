import 'package:flutter/material.dart';

class ItemCaption extends StatefulWidget {
  const ItemCaption(
      {super.key, required this.caption, this.backgroundColor = Colors.black});
  final String caption;
  final Color backgroundColor;
  @override
  State<ItemCaption> createState() => ItemCaptionState();
}

class ItemCaptionState extends State<ItemCaption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Column(
        children: [Divider(), Text(widget.caption)],
      ),
    );
  }
}
