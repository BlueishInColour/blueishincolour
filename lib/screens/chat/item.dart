import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Item extends StatefulWidget {
  const Item(
      {super.key,
      required this.uid,
      required this.userName,
      required this.profilePicture,
      required this.displayName});

  final String userName;
  final String displayName;
  final String profilePicture;
  final String uid;

  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    List chatKey = [
      '${FirebaseAuth.instance.currentUser!.uid}',
      '${widget.uid}'
    ];
    chatKey.sort();
    String key = chatKey.join();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: true,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(widget.profilePicture),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.displayName,
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    SizedBox(height: 5),
                    Text(
                      widget.uid == FirebaseAuth.instance.currentUser!.uid
                          ? 'messaging myself'
                          : '@${widget.userName}',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    )
                  ],
                ),
              ],
            )),
        body: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(key)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                //if we have data, get all dic
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 500,
                    child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: ((context, index) {
                          //get indicidual doc
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];

                          return BubbleSpecialTwo(
                            text: documentSnapshot['text'],
                            color: documentSnapshot['senderId'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Colors.black
                                : Color(0xFF1B97F3),
                            tail: true,
                            isSender: documentSnapshot['senderId'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? true
                                : false,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 11),
                          );
                        })),
                  );
                }

                return Center(
                    child:
                        CircularProgressIndicator(color: Colors.blue.shade600));
              },
            ),
          ),
          MessageBar(
            onSend: (text) async {
              debugPrint('about to send message');
              await FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(key)
                  .collection('messages')
                  .add({
                'senderId': FirebaseAuth.instance.currentUser!.uid,
                'reciever': 'tinuke',
                'recieverId': widget.uid,
                'text': text,
                'picture': '',
                'voiceNote': '',
                'timestamp': Timestamp.now(),
                'status': 'seen'
              });

              debugPrint('message sent');
            },
            sendButtonColor: Colors.black,
            actions: [
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ]));
  }
}
