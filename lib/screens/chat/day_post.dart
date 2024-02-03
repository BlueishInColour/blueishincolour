import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/screens/chat/day_post_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class DayPost extends StatefulWidget {
  const DayPost({super.key, required this.listOfFreinds});
  final List<String> listOfFreinds;

  @override
  State<DayPost> createState() => DayPostState();
}

class DayPostState extends State<DayPost> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        child: FirestorePagination(
            scrollDirection: Axis.horizontal,
            limit: 20,
            query: FirebaseFirestore.instance
                .collection('posts')
                .where('creatorUid', arrayContainsAny: widget.listOfFreinds)
                .orderBy('timestamp'),
            itemBuilder: (context, data, snapshot) {
              String picture = data['picture'];
              bool isPicture = picture.isEmpty;
              if (isPicture) {
                return SizedBox(
                  width: 5,
                );
              }
              return DayPostItem(data: data);
            }));
  }
}
