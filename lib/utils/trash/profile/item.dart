import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/goods.dart';

class Item extends StatefulWidget {
  const Item({super.key, this.picture = ''});
  final String picture;
  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: widget.picture,
        fit: BoxFit.fill,
        errorWidget: (context, _, __) => Container(color: Colors.red),
        placeholder: (context, _) => Container(color: Colors.black26),
      ),
    ));
  }
}
