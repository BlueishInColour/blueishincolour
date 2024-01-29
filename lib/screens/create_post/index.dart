import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../store/item/item.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key, this.ancestorId = ''});
  final String ancestorId;

  @override
  State<CreateScreen> createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  String ancestorId = Uuid().v1();
  List<Map<String, dynamic>> listOfCreatingPost = [];
  int currentActiveButton = 0; //0 for text,1 for pictures, 2 for tags

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> onePost = {
      //id
      'postId': Uuid().v1(),
      // 'headPostId': widget.headPostId,
      'ancestorId': widget.ancestorId.isEmpty ? ancestorId : widget.ancestorId,

      //content
      'caption': '',
      'images': [],
      'audio': '',
      'video': '',
      'tags': [],

      //creator
      'creatorUid': FirebaseAuth.instance.currentUser!.uid,

      //metadata

      'timestamp': Timestamp.now()
    };

    createOnePostInstance(Map<String, dynamic> onePost) async {
      listOfCreatingPost.add(onePost);
    }

    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listOfCreatingPost.length,
                itemBuilder: (context, index) {
                  var post = listOfCreatingPost[index];
                  return Item(
                    //
                    postId: post['postId'],
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              height: 50,
              child: Column(
                children: [
                  ListTile(
                      leading: IconButton(
                          onPressed: () {
                            setState(() {
                              listOfCreatingPost.add(onePost);
                            });
                          },
                          icon: Icon(Icons.add)),
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      currentActiveButton = 0;
                                    });
                                  },
                                  icon: Icon(Icons.abc)),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      currentActiveButton = 1;
                                    });
                                  },
                                  icon: Icon(Icons.camera_alt)),
                            ),
                          ]),
                      trailing: CircleAvatar(
                        child: IconButton(
                            onPressed: () {}, icon: Icon(Icons.send)),
                      )),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: [
          MessageBar(
              onTextChanged: (text) {
                setState(() {
                  listOfCreatingPost.last['caption'] = text;
                });
              },
              actions: [
                //change alignment
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.align_horizontal_center)),

                //change color
                IconButton(onPressed: () {}, icon: Icon(Icons.colorize))
              ]),
        ][currentActiveButton]);
  }
}
