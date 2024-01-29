import 'package:flutter/material.dart';

class ItemCaption extends StatefulWidget {
  const ItemCaption({super.key, required this.caption});
  final String caption;
  @override
  State<ItemCaption> createState() => ItemCaptionState();
}

class ItemCaptionState extends State<ItemCaption> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Divider(), Text(widget.caption)],
    );
  }
}
