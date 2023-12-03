import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/goods.dart';

class Item extends StatefulWidget {
  const Item(
      {super.key, required this.goods, this.index = 0, required this.onTap});
  final Good goods;
  final int index;

  final Function() onTap;
  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  Widget button(context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blue.shade300),
          child: const Center(
            child: Text(
              'add to cart',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Good goods = widget.goods;
    int index = widget.index;
    String brand = goods.brand;
    String category = goods.category;
    List<String> images = goods.images;
    String description = goods.description;
    String rating = goods.rating.toString();
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                );
              }),
          Positioned(
              top: 15,
              left: 15,
              child: Text('$brand - $category - rating $rating ',
                  style: TextStyle(
                    backgroundColor: Colors.white54,
                    fontWeight: FontWeight.w800,
                  ))),
          Positioned(
              bottom: 15,
              left: 15,
              child: SizedBox(
                  width: 200,
                  child: Text(description,
                      style: TextStyle(
                        backgroundColor: Colors.white54,
                        // fontWeight: FontWeight.w300,
                      )))),
          // Positioned(right: 15, bottom: 15, child: button(context)),
        ],
      ),
    );
  }
}
