// import 'dart:html';

import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/utils/shared_pref.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<ChatUser> listOfLikers = <ChatUser>[];
  List listOfLikersUid = [];
  getListOfLikers() async {
    var res = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    QuerySnapshot<Map<String, dynamic>> list = await res.first;
    setState(() {
      listOfLikersUid = list.docs.first['listOfLikers'];
    });
  }

  getUserDetailsFromUid() async {
    listOfLikersUid.map((e) async {
      var res = await getUserDetails(listOfLikersUid[e]);
      ChatUser chatuser = ChatUser(
          displayName: res['displayName'],
          lastMessage: '',
          lastMessageStatus: '',
          profilePicture: res['profilePicture'],
          uid: res['uid'],
          userName: res['userName']);
      setState(() {
        listOfLikers.add(chatuser);
      });
    });
  }

  getTimeStampAndMessages() async {
    listOfLikers.map((e) async {
      List chatRoom = [FirebaseAuth.instance.currentUser!.uid, e.uid];
      chatRoom.sort();
      String chatKey = chatRoom.join();

      var res = await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatKey)
          .collection('messages')
          // .where('listOfChatters', isEqualTo: chatRoom)
          .orderBy('timestamp', descending: false)
          .snapshots();
      QuerySnapshot<Map<String, dynamic>> list = await res.first;
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    getListOfLikers();
    getUserDetailsFromUid();
    getTimeStampAndMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Middle(
      width: 500,
      child: Scaffold(
          body: SafeArea(
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: ((context, index) {
                    if (listOfLikers.isEmpty) {
                      return CircularProgressIndicator(
                        color: Colors.black,
                      );
                    }
                    return ListTile(
                      leading: Text(listOfLikersUid[index]),
                      // subtitle: Text(listOfLikers[index].lastMessage),
                    );
                  })))),
    );
  }
}
