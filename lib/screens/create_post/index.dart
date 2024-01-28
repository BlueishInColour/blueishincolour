import 'package:flutter/material.dart';

import '../store/item.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  List listOfCreatingPost = [];
  Map<String, dynamic> onePost = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: listOfCreatingPost.length,
        itemBuilder: (context, index) {
          var post = listOfCreatingPost[index];
          return Item(
            // typeOfShowlist: '',
            swipeBack: false, creatorUid: post['creatorUid'],
            showPix: post['images'][0],
            onTap: () {},
            title: post['title'],
            pictures: post['images'],

            //
            postId: post['postId'],
            headPostId: post['headPostId'],
            ancestorId: post['ancestorId'],
          );
        },
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        height: 50,
        child: ListTile(
            title:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              CircleAvatar(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.abc)),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                child:
                    IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
              ),
            ]),
            trailing: CircleAvatar(
              child: IconButton(onPressed: () {}, icon: Icon(Icons.send)),
            )),
      ),
    );
  }
}
