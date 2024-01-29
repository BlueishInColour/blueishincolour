import 'package:blueishincolour/screens/create_post/offline_item.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  int currentEditingItem = 0;
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
      'picture': '',
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
              if (currentEditingItem == index) {
                return OfflineItem(
                  onTap: () {
                    setState(() {
                      currentEditingItem = index;
                    });
                  },
                  borderActiveColor: Colors.blue,
                  picture: post['picture'],
                  caption: post['caption'],
                );
              } else {
                return OfflineItem(
                  onTap: () {
                    setState(() {
                      currentEditingItem = index;
                    });
                  },
                  picture: post['picture'],
                  caption: post['caption'],
                );
              }
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Column(
            children: [
              ListTile(
                  leading: IconButton(
                      onPressed: () {
                        setState(() {
                          listOfCreatingPost.add(onePost);
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white60,
                      )),
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
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.send)),
                  )),
            ],
          ),
        ),
        [
          SizedBox(
            child: MessageBar(
              messageBarColor: Colors.black,
              onTextChanged: (text) {
                setState(() {
                  listOfCreatingPost[currentEditingItem]['caption'] = text;
                });
              },
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    String url = await addSingleImage(ImageSource.camera);
                    setState(() {
                      listOfCreatingPost[currentEditingItem]['picture'] = url;
                    });
                  },
                  icon: Icon(Icons.camera_alt)),
              IconButton(
                  onPressed: () async {
                    String url = await addSingleImage(ImageSource.gallery);
                    setState(() {
                      listOfCreatingPost[currentEditingItem]['picture'] = url;
                    });
                  },
                  icon: Icon(Icons.file_copy))
            ],
          )
        ][currentActiveButton]
      ],
    ));
  }
}
