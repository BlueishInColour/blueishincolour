import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/store/item/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: FirestorePagination(
          isLive: true,
          limit: 15,
          onEmpty: Center(
              child: Text('no search result for "${widget.searchText}"')),
          query: FirebaseFirestore.instance
              .collection('posts')
              .where('tags', arrayContainsAny: widget.searchText.split(' ')),
          itemBuilder: (context, document, snapshot) {
            return Item(
              postId: document['postId'],
            );
          },
        ));
  }
}

// import 'package:flutter/material.dart';
