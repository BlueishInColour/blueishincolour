import 'package:blueishincolour/screens/create_post/offline_item.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../main.dart';
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
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> onePost = {
      //id
      'postId': '',
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

    setTextToField(int index) {
      setState(() {
        textController.clear();

        currentEditingItem = index;

        textController.text = listOfCreatingPost[currentEditingItem]['caption'];
      });
    }

    uploadPost() async {
    

      listOfCreatingPost.forEach((element) async {
        String postId = Uuid().v1();
        setState(() {
          element['postId'] = postId;
        });

        debugPrint(listOfCreatingPost.length.toString());
        DocumentReference postCollection =
            FirebaseFirestore.instance.collection('posts').doc(postId);
        await postCollection.set(element);
      });

      Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
        debugPrint('posted');

        return MainIndex();
      }));
    }

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: listOfCreatingPost.isEmpty
                ? Center(
                    child: Text('click add to start editing'),
                  )
                : ListView.builder(
                    itemCount: listOfCreatingPost.length,
                    itemBuilder: (context, index) {
                      var post = listOfCreatingPost[index];
                      if (currentEditingItem == index) {
                        return OfflineItem(
                          onTap: () {
                            setState(() {
                              textController.clear();

                              currentEditingItem = index;

                              textController.text =
                                  listOfCreatingPost[currentEditingItem]
                                      ['caption'];
                            });
                          },
                          borderActiveColor: Colors.black,
                          picture: post['picture'],
                          caption: post['caption'],
                        );
                      } else {
                        return OfflineItem(
                          onTap: () {
                            setState(() {
                              textController.clear();

                              currentEditingItem = index;

                              textController.text =
                                  listOfCreatingPost[currentEditingItem]
                                      ['caption'];
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
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
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
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  currentActiveButton = 0;
                                });
                              },
                              icon: Icon(Icons.abc, color: Colors.white60)),
                          SizedBox(width: 10),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  currentActiveButton = 1;
                                });
                              },
                              icon: Icon(Icons.camera_alt,
                                  color: Colors.white60)),
                        ]),
                    trailing: CircleAvatar(
                      child: IconButton(
                          onPressed: uploadPost, icon: Icon(Icons.send)),
                    )),
              ],
            ),
          ),
          [
            Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(autofocus: true,
                      controller: textController,
                      onChanged: (text) {
                        setState(() {
                          listOfCreatingPost[currentEditingItem]['caption'] =
                              text;
                        });
                      },
                      cursorColor: Colors.white60,
                      style: TextStyle(color: Colors.white60),
                      decoration: InputDecoration(
                          fillColor: Colors.white60, focusColor: Colors.white)),
                )),
            Container(
              color: Colors.black,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        String url = await addSingleImage(ImageSource.camera);
                        setState(() {
                          listOfCreatingPost[currentEditingItem]['picture'] =
                              url;
                        });
                      },
                      icon: Icon(
                        Icons.camera,
                        color: Colors.white60,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () async {
                        String url = await addSingleImage(ImageSource.gallery);
                        setState(() {
                          listOfCreatingPost[currentEditingItem]['picture'] =
                              url;
                        });
                      },
                      icon: Icon(Icons.file_copy, color: Colors.white60))
                ],
              ),
            )
          ][currentActiveButton]
        ],
      ),
    ));
  }
}
