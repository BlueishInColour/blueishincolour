import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/comments.dart';
import './item.dart';

class MoreItemOut extends StatefulWidget {
  const MoreItemOut({super.key, required this.headPostid});
  final String headPostid;

  @override
  State<MoreItemOut> createState() => MoreItemOutState();
}

class MoreItemOutState extends State<MoreItemOut>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: true,
          title: TabBar(
              controller: tabController,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.only(top: 15),
              tabs: [
                Text(
                  'steeze-off',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'comments',
                  style: TextStyle(color: Colors.white),
                )
              ]),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            SteezeSection(headPostId: widget.headPostid),
            CommentSection(
              postId: widget.headPostid,
            ),
          ],
        ));
  }
}

// import 'package:flutter/material.dart';

class SteezeSection extends StatefulWidget {
  const SteezeSection({super.key, required this.headPostId});
  final String headPostId;

  @override
  State<SteezeSection> createState() => SteezeSectionState();
}

class SteezeSectionState extends State<SteezeSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context,
              PageRouteBuilder(pageBuilder: (context, _, __) {
            return AddItem(headPostId: widget.headPostId);
          }));
        },
        child: Icon(Icons.add, color: Colors.white60),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('goods')
              .where('headPostId', isEqualTo: widget.headPostId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('be the first to steeze-off this'),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  //get indicidual doc
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  return Item(
                    onTap: () {},
                    showPix: documentSnapshot['images'][0],
                    listOfLikers: documentSnapshot['listOfLikers'],
                    title: documentSnapshot['title'],
                    pictures: documentSnapshot['images'],
                    id: documentSnapshot['goodId'],
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

// import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key, required this.postId});
  final String postId;
  @override
  State<CommentSection> createState() => CommentSectionState();
}

class CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('postId', isEqualTo: widget.postId)
            .snapshots(),
        builder: (context, snapshot) {
          //if we have data, get all dic
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  //get indicidual doc
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];

                  return ListTile(
                    titleTextStyle:
                        TextStyle(color: Colors.black, fontSize: 11),
                    subtitleTextStyle: TextStyle(fontSize: 13),
                    leading: CircleAvatar(),
                    title: Text(documentSnapshot['creator']),
                    subtitle: Text(documentSnapshot['text']),
                  );
                }));
          }

          return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade600));
        },
      ),
      bottomSheet: SizedBox(
        height: 70,
        child: MessageBar(
          messageBarHitText: 'write a comment',
          onSend: (text) async {
            debugPrint('about to send message');
            await FirebaseFirestore.instance.collection('comments').add(
                Comments(
                        commentId: Uuid().v1(),
                        text: text,
                        creator: 'blueishincolour',
                        postId: widget.postId)
                    .toJson());

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
      ),
    );
  }
}
