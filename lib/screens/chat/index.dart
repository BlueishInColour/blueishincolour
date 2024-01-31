// import 'dart:html';

import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/utils/shared_pref.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './item.dart';
import '../../models/chat_user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black54,
        title: Text('chats'),
      ),
      body: FirestorePagination(
          isLive: true,
          onEmpty: Center(child: Text('any user you like will appear here')),
          query: FirebaseFirestore.instance
              .collection('chat')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('active').orderBy('lastMessageTimeStamp'),
          itemBuilder: (context, document, snapshot) {
            String userUid = document['userUid'];
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                  String lastMessage = snapshot.data!['lastMessage'];
                    if (snapshot.hasData) {
                      var snap = snapshot.data!;
                      return ListTile(
                        onTap: () {
                          Navigator.push(context,
                              PageRouteBuilder(pageBuilder: (context, _, __) {
                            return Item(
                              uid: userUid,
                              displayName: snap['displayName'],
                              profilePicture: snap['profilePicture'],
                              userName: snap['userName'],
                            );
                          }));
                        },
                        leading: CircleAvatar(),
                        title: Text(
                          '${snap["displayName"]}'
                          '|'
                          '@${snap['userName']}',
                          maxLines: 1,
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        subtitle: Row(
                          children: [Expanded(child: Text(lastMessage.isNotEmpty?lastMessage:'start chat'))],
                        ),
                      );
                    } else {
                      return Text('user not found');
                    }
                  } else {
                    return Text('something wrong');
                  }
                });
          }),
    );
  }
}
