import 'package:blueishincolour/screens/store/more_item_in.dart';
import 'package:flutter/material.dart';

import '../screens/store/more_item_out.dart';

class CommentButton extends StatefulWidget {
  const CommentButton({
    super.key,
    required this.headPostId,
  });

  final String headPostId;

  @override
  State<CommentButton> createState() => CommentButtonState();
}

class CommentButtonState extends State<CommentButton> {
  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text('0'),
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
        icon: Icon(Icons.chat_bubble, color: Colors.white),
      ),
    );
  }
}
