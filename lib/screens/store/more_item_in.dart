import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:blueishincolour/screens/store/index.dart';
import '../../main.dart';

import './item.dart';
import 'package:flutter/material.dart';

class MoreItemIn extends StatefulWidget {
  const MoreItemIn({
    super.key,
    required this.goodId,
    required this.listOfLikers,
    required this.title,
    required this.listOfPictures,
    this.creatorDisplayName = 'sampleDisplayName',
    this.creatorUserName = 'sampleUserName',
    this.creatorUid = 'sampleUid',
    this.creatorProfilePicture = 'https://source.unsplash.com/random',
  });
  final String goodId;
  final List listOfPictures;
  final List listOfLikers;
  final String title;
  final String creatorUserName;
  final String creatorDisplayName;
  final String creatorUid;
  final String creatorProfilePicture;

  @override
  State<MoreItemIn> createState() => MoreItemInState();
}

class MoreItemInState extends State<MoreItemIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('steeze-on'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (context, _, __) {
                    return Index();
                  }));
                },
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
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
                    creatorDisplayName: widget.creatorDisplayName,
                    creatorProfilePicture: widget.creatorProfilePicture,
                    creatorUserName: widget.creatorUserName,
                    creatorUid: widget.creatorUid,
                    onTap: () {},
                    showPix: widget.listOfPictures[index],
                    listOfLikers: widget.listOfLikers,
                    title: widget.title,
                    pictures: widget.listOfPictures,
                    postId: widget.goodId,
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
