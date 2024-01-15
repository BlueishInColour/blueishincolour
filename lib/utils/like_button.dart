import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class LikeButton extends StatefulWidget {
  const LikeButton(
      {super.key,
      required this.goodId,
      required this.collection,
      required this.idType,
      required this.listOfLikers});

  final String collection;
  final String goodId;
  final String idType; //canbe goodsid or style id
  final List listOfLikers;

  @override
  State<LikeButton> createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> {
  List listOfShowlist = ['for later', 'bobby', 'cleanme'];
  String showlistValue = '';
  bool useShowlistValue = false;

  getListOfShowlist() async {
    QuerySnapshot res = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .first;
    setState(() {
      listOfShowlist = res.docs[0]['listOfShowlist'];
    });
  }

  bool haveLiked = false;

  int count = 0;

  getAggregateCount() async {
    AggregateQuerySnapshot query = await FirebaseFirestore.instance
        .collection('goods')
        .where(
          'goodId',
          isEqualTo: widget.goodId,
        )
        .count()
        .get();

    debugPrint('The number of products: ${query.count}');
    setState(() {
      count = query.count!;
    });
  }

  checkLike() async {
    if (widget.listOfLikers.contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        haveLiked = true;
      });
    }
  }

  onTap() async {
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          String dropDownValue = listOfShowlist.first;
          return Container(
            child: ListView.builder(
                itemCount: listOfShowlist.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      like;
                      await FirebaseFirestore.instance
                          .collection('showlist')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection(listOfShowlist[index])
                          .add({
                        'postId': widget.goodId,
                        'timestamp': Timestamp.now(),
                      }).whenComplete(() => setState(() {
                                haveLiked = true;
                              }));
                      Navigator.pop(context);
                    },
                    title: Text(listOfShowlist[index]),
                  );
                }),
          );
        }));
  }

  like() async {
    debugPrint('clicked');
    QuerySnapshot<Map<String, dynamic>> docs = await FirebaseFirestore.instance
        .collection(widget.collection)
        .where(widget.idType, isEqualTo: widget.goodId)
        .get();
    print(docs);
    for (var snapshot in docs.docs) {
      print('started to find love');
      print(snapshot.id);

      if (haveLiked == false) {
        await FirebaseFirestore.instance
            .collection(widget.collection)
            .doc(snapshot.id)
            .update({
          'listOfLikers':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        }).whenComplete(() => setState(() {
                  haveLiked = true;
                }));

        debugPrint('done');
      } else {
        await FirebaseFirestore.instance
            .collection(widget.collection)
            .doc(snapshot.id)
            .update({
          'listOfLikers':
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        }).whenComplete(() => setState(() {
                  haveLiked = false;
                }));
      }
    }
  }

  @override
  initState() {
    super.initState();
    checkLike();
    getListOfShowlist();
  }

  @override
  Widget build(BuildContext context) {
    String dropDownValue = listOfShowlist.first;

    return GestureDetector(
      onTap: onTap,
      // onLongPress: onLongTap,
      child: Badge(
        backgroundColor: Colors.white,
        label: Text(
          widget.listOfLikers.length.toString(),
          style: TextStyle(color: Colors.black),
        ),
        child: haveLiked
            ? Icon(
                Icons.favorite,
                color: const Color.fromARGB(255, 255, 17, 0),
                size: 20,
              )
            : Icon(
                LineIcons.heart,
                color: Colors.white60,
                size: 20,
              ),
      ),
    );
  }
}
