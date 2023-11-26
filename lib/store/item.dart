import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  const Item({super.key});

  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '',
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: ElevatedButton(onPressed: () {}, child: Text('buy')),
        )
      ],
    );
  }
}
