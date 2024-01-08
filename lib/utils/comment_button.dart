import 'package:blueishincolour/screens/store/more_item_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/store/more_item_out.dart';

class CommentButton extends StatefulWidget {
  const CommentButton({
    super.key,
    required this.headPostId,
    required this.postId,
  });
  final String postId;

  final String headPostId;

  @override
  State<CommentButton> createState() => CommentButtonState();
}

class CommentButtonState extends State<CommentButton> {
  int count = 0;

  getAggregateCount() async {
    AggregateQuerySnapshot query = await FirebaseFirestore.instance
        .collection('comments')
        .where(
          'postId',
          isEqualTo: widget.postId,
        )
        .count()
        .get();

    debugPrint('The number of products: ${query.count}');
    setState(() {
      count = query.count;
    });
  }

  @override
  initState() {
    super.initState();
    getAggregateCount();
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text(count.toString()),
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return MoreItemOut(
              selectedPage: 1,
              headPostid: widget.headPostId,
            );
          }));
        },
        icon: Icon(Icons.chat_bubble, size: 25, color: Colors.white),
      ),
    );
  }
}
