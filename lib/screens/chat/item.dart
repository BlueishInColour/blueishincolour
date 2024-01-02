import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  const Item({super.key, required this.userName, required this.displayName});

  final String userName;
  final String displayName;

  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: true,
            title: Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(widget.displayName,
                        style: TextStyle(color: Colors.white60, fontSize: 15)),
                    SizedBox(height: 5),
                    Text(
                      '@${widget.userName}',
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
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  // .where('sender', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

                          return BubbleSpecialThree(
                            text: documentSnapshot['text'],
                            color: documentSnapshot['sender'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Colors.black
                                : Color(0xFF1B97F3),
                            tail: false,
                            isSender: documentSnapshot['sender'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? true
                                : false,
                            delivered: documentSnapshot['status'] == 'delivered'
                                ? true
                                : false,
                            sent: documentSnapshot['status'] == 'sent'
                                ? true
                                : false,
                            seen: documentSnapshot['status'] == 'seen'
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
              await FirebaseFirestore.instance.collection('messages').add({
                'sender': FirebaseAuth.instance.currentUser!.uid,
                'reciever': 'tinuke',
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
