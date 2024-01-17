import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:blueishincolour/screens/store/index.dart';
import 'package:blueishincolour/screens/store/more_item_out.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import '../../main.dart';

import './item.dart';
import 'package:flutter/material.dart';

class MoreItemIn extends StatefulWidget {
  const MoreItemIn({
    super.key,
    required this.goodId,
    required this.headPostId,
    required this.title,
    required this.listOfPictures,
    this.creatorDisplayName = 'sampleDisplayName',
    this.creatorUserName = 'sampleUserName',
    this.creatorUid = 'sampleUid',
    this.creatorProfilePicture = 'https://source.unsplash.com/random',
  });
  final String goodId;
  final String headPostId;
  final List listOfPictures;
  final String title;
  final String creatorUserName;
  final String creatorDisplayName;
  final String creatorUid;
  final String creatorProfilePicture;

  @override
  State<MoreItemIn> createState() => MoreItemInState();
}

class MoreItemInState extends State<MoreItemIn> {
  showBottomSheet() {
    debugPrint('clicked');
    showModalBottomSheet(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
        enableDrag: true,
        anchorPoint: Offset(0, 20),
        elevation: 15,
        isDismissible: true,
        showDragHandle: true,
        context: context,
        builder: ((context) {
          return CommentSection(postId: widget.goodId);
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   title: Text('steeze-on'),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           Navigator.push(context,
      //               PageRouteBuilder(pageBuilder: (context, _, __) {
      //             return Index();
      //           }));
      //         },
      //         icon: Icon(
      //           Icons.home,
      //           color: Colors.white,
      //         ))
      //   ],
      // ),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (context, _, __) {
                  return AddItem(
                    headPostId: '',
                  );
                }));
              },
              child: Icon(Icons.add, color: Colors.white60),
            ),
      body: widget.listOfPictures.isNotEmpty
          ? ListView.builder(
              itemCount: widget.listOfPictures.length,
              itemBuilder: (context, index) {
                //get indicidual doc

                return Item(
                  index: index + 1,
                  swipeBack: true,
                  creatorDisplayName: widget.creatorDisplayName,
                  creatorProfilePicture: widget.creatorProfilePicture,
                  creatorUserName: widget.creatorUserName,
                  creatorUid: widget.creatorUid,
                  onTap: () {},
                  showPix: widget.listOfPictures[index],
                  title: widget.title,
                  pictures: widget.listOfPictures,
                  postId: widget.goodId,
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomSheet: GestureDetector(
          onTap: showBottomSheet,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            height: 50,
            child: ListTile(
              leading: BackButton(
                color: Colors.white60,
              ),
              trailing: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  LineIcons.comment,
                ),
              ),
              title: Text(
                'view comments',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ),
          )),
    );
  }
}
