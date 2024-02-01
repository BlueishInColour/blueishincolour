import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/store/item/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/blueishincolour_icon.dart';

class PostSearch extends StatefulWidget {
  const PostSearch({super.key, this.searchText = ''});
  final String searchText;

  @override
  State<PostSearch> createState() => PostSearchState();
}

class PostSearchState extends State<PostSearch> {
  String searchText = '';
  // String searchText = widget.searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: searchText.isEmpty
          ? Center(
              child: Text('search anything'),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('tags', arrayContainsAny: searchText.split(' '))
                  .snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      bool isAvailable = snapshot.data!.docs.isEmpty;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        QueryDocumentSnapshot document =
                            snapshot.data!.docs[index];

                        if (!snapshot.hasData) {
                          return Center(
                              child: Text(
                            'no result',
                            style: TextStyle(color: Colors.red),
                          ));
                        }
                        return Item(
                          postId: document['postId'],
                        );
                      } else {
                        return Center(
                            child: Text('search anything',
                                style: TextStyle(color: Colors.black)));
                      }
                    }));
              }),
      bottomSheet: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        height: 45,
        child: SearchBar(
          backgroundColor: MaterialStatePropertyAll(Colors.white38),
          onChanged: (v) {
            setState(() {
              searchText = v;
            });
          },
          hintText: 'search trending styles',
          trailing: [Icon(Icons.search)],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
