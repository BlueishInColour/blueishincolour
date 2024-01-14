import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:blueishincolour/screens/store/more_item_out.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class SteezeOffButton extends StatefulWidget {
  const SteezeOffButton(
      {super.key, required this.postId, required this.headPostId});
  final String headPostId;
  final String postId;
  @override
  State<SteezeOffButton> createState() => SteezeOffButtonState();
}

class SteezeOffButtonState extends State<SteezeOffButton> {
  int count = 0;
  // int commentCount = 0;

  // getCommentAggregateCount() async {
  //   AggregateQuerySnapshot query = await FirebaseFirestore.instance
  //       .collection('comments')
  //       .where(
  //         'postId',
  //         isEqualTo: widget.postId,
  //       )
  //       .count()
  //       .get();

  //   debugPrint('The number of products: ${query.count}');
  //   setState(() {
  //     count = query.count!;
  //   });
  // }

  getAggregateCount() async {
    AggregateQuerySnapshot query = await FirebaseFirestore.instance
        .collection('goods')
        .where(
          'headPostId',
          isEqualTo: widget.headPostId,
        )
        .count()
        .get();

    debugPrint('The number of products: ${query.count}');
    setState(() {
      count = query.count!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getSteezeOffCount();
    getAggregateCount();
    // getCommentAggregateCount();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
          onPressed: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return SteezeSection(headPostId: widget.headPostId);
            }));
          },
          icon: Badge(
            backgroundColor: Colors.white,
            label: Text(
              count.toString(),
              style: TextStyle(color: Colors.black),
            ),
            child: Icon(
              LineIcons.retweet,
              color: Colors.white60,
              size: 20,
              // weight: 15,
            ),
          )),
      // Text(count.toString(), style: TextStyle(color: Colors.white))
    ]);
  }
}
