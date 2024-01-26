import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/store/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/blueishincolour_icon.dart';

class PostSearch extends StatefulWidget {
  const PostSearch({super.key, required this.searchText});
  final String searchText;

  @override
  State<PostSearch> createState() => PostSearchState();
}

class PostSearchState extends State<PostSearch> {
  // String searchText = widget.searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where('tags', arrayContainsAny: widget.searchText.split(' '))
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var documentSnapshot = snapshot.data!.docs[index];

                    return Item(
                      swipeBack: false,
                      creatorProfilePicture:
                          documentSnapshot['creatorProfilePicture'],
                      creatorDisplayName:
                          documentSnapshot['creatorDisplayName'],
                      creatorUserName: documentSnapshot['creatorUserName'],
                      creatorUid: documentSnapshot['creatorUid'],
                      showPix: documentSnapshot['images'][0],
                      onTap: () {},
                      // index: index,
                      title: documentSnapshot['title'],
                      pictures: documentSnapshot['images'],
                      postId: documentSnapshot['postId'],
                      headPostId: documentSnapshot['headPostId'],
                      ancestorId: documentSnapshot['ancestorId'],
                    );
                  },
                );
              }
              return Center(
                child: Text('search for any post'),
              );
            }));
  }
}

// import 'package:flutter/material.dart';
