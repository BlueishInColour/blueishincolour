import 'dart:html';

import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/comments.dart';
import './item.dart';

class MoreItemOut extends StatefulWidget {
  const MoreItemOut(
      {super.key, required this.headPostid, required this.selectedPage});
  final String headPostid;
  final int selectedPage;

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
          automaticallyImplyLeading: true,
          toolbarHeight: 35,
        ),
        body: SafeArea(
          child: DefaultTabController(
            length: 2,
            initialIndex: 1,
            child: Builder(
              builder: (context) => Column(
                children: [
                  TabBar(
                      // controller: tabController,
                      controller: DefaultTabController.of(context),
                      indicatorColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorPadding: EdgeInsets.only(top: 15),
                      tabs: [
                        Text(
                          'steeze-off',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'comments',
                          style: TextStyle(color: Colors.black),
                        )
                      ]),
                  Expanded(
                    child: TabBarView(
                      // controller: tabController,
                      controller: DefaultTabController.of(context),

                      children: [
                        SteezeSection(headPostId: widget.headPostid),
                        CommentSection(
                          postId: widget.headPostid,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
  var userDetails = {};

  getTheUserDetails() async {
    var details = await getUserDetails(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      userDetails = details;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheUserDetails();
  }

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
          if (snapshot.data!.docs.isEmpty) {
            return (Center(
              child: Text('be the first to comment on this'),
            ));
          }
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
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          documentSnapshot['creatorProfilePicture']),
                    ),
                    title: Text('${documentSnapshot['creatorDisplayName']}'
                        '| @'
                        '${documentSnapshot['creatorUserName']}'),
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
            await FirebaseFirestore.instance.collection('comments').add({
              'commentId': Uuid().v1(),
              text: text,
              'creatorProfilePicture': userDetails['profilePicture'],
              'creatorDisplayName': userDetails['displayName'],
              'creatorUserName': userDetails['userName'],
              'postId': widget.postId
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
      ),
    );
  }
}
