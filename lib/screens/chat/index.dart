import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './item.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
      print(FirebaseAuth.instance.currentUser?.photoURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: CachedNetworkImageProvider(
                FirebaseAuth.instance.currentUser!.photoURL!),
          ),
          title: Text(FirebaseAuth.instance.currentUser!.uid),
          subtitle: Text('creator'),
          onTap: () => Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return Item();
          })),
        );
      },
    ));
  }
}
