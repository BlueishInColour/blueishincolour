import 'package:flutter/material.dart';
import '../screens/chat/item.dart';

class ChatButton extends StatefulWidget {
  const ChatButton({
    super.key,
    required this.userName,
    required this.postId,
    required this.displayName,
  });
  final String userName;
  final String displayName;
  final String postId;
  @override
  State<ChatButton> createState() => ChatButtonState();
}

class ChatButtonState extends State<ChatButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return Item(
              displayName: widget.displayName,
              userName: widget.userName,
            );
          }));
        },
        icon: Icon(Icons.chat_bubble_rounded, color: Colors.white60, size: 30));
  }
}
