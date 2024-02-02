import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressr/screens/chat/day_post_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class DayPost extends StatefulWidget {
  const DayPost({super.key});

  @override
  State<DayPost> createState() => DayPostState();
}

class DayPostState extends State<DayPost> {
  List<QueryDocumentSnapshot> listOfFriends = [];

  getListOfFriends() async {
    var res = await FirebaseFirestore.instance
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('active')
        .get();

    setState(() {
      res.docs.forEach(
        (element) {
          listOfFriends.add(element['userUid']);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 70,
        child: FirestorePagination(
            scrollDirection: Axis.horizontal,
            initialLoader: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: CircularProgressIndicator()),
            ),
            bottomLoader: Container(
                height: 69,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: CircularProgressIndicator())),
            limit: 20,
            onEmpty: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            query: FirebaseFirestore.instance
                .collection('posts')
                .where('creatorUid', arrayContainsAny: listOfFriends)
                .orderBy('timestamp'),
            itemBuilder: (context, data, snapshot) {
              return DayPostItem(data: data);
            }));
  }
}
