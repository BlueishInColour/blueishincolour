import 'package:blueishincolour/utils/add_showlist_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.goodId,
    required this.collection,
    required this.typeOfShowlist,
    required this.idType,
  });

  final String collection;
  final String typeOfShowlist;
  final String goodId;
  final String idType; //canbe goodsid or style id

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

    await checkLike();
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
    listOfShowlist.map((e) async {
      var res = FirebaseFirestore.instance
          .collection('showlist')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(e)
          .snapshots();

      bool re = await res.isEmpty;
      if (re) {
        setState(() {
          haveLiked = true;
        });
      } else {
        setState(() {
          haveLiked = false;
        });
      }
    });
  }

  onTap() async {
    showModalBottomSheet(
        context: context,
        builder: ((context) {
          String dropDownValue = listOfShowlist.first;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: listOfShowlist.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          if (!haveLiked) {
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
                          } else {
                            await dislike(widget.typeOfShowlist);
                          }
                        },
                        title: Text(listOfShowlist[index]),
                        trailing: !haveLiked
                            ? Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.black,
                              )
                            : Icon(Icons.favorite, color: Colors.red),
                      );
                    }),
              ),
              Row(
                children: [AddShowlistButton()],
              )
            ],
          );
        }));
  }

  onLongPress() async {
    like;
    await FirebaseFirestore.instance
        .collection('showlist')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('for later')
        .add({
      'postId': widget.goodId,
      'timestamp': Timestamp.now(),
    }).whenComplete(() => setState(() {
              haveLiked = true;
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
            .update({'noOfLikes': FieldValue.increment(1)}).whenComplete(
                () => setState(() {
                      haveLiked = true;
                    }));

        debugPrint('done');
      } else {}
    }
  }

  dislike(String typeOfShowlist) async {
    debugPrint('clicked');
    QuerySnapshot<Map<String, dynamic>> docs = await FirebaseFirestore.instance
        .collection(widget.collection)
        .where(widget.idType, isEqualTo: widget.goodId)
        .get();
    print(docs);
    for (var snapshot in docs.docs) {
      print('started to find love');
      print(snapshot.id);

      await FirebaseFirestore.instance
          .collection(widget.collection)
          .doc(snapshot.id)
          .update({'noOfLikes': FieldValue.increment(-1)}).whenComplete(
              () => setState(() {
                    haveLiked = false;
                  }));

      //db
      var res = await FirebaseFirestore.instance
          .collection('showlist')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(typeOfShowlist)
          .where('postId', isEqualTo: widget.goodId)
          .get();

      String id = res.docs.first.id;

      await FirebaseFirestore.instance
          .collection('collection')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(typeOfShowlist)
          .doc(id)
          .delete();
    }
  }

  @override
  initState() {
    super.initState();

    getListOfShowlist();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Badge(
        backgroundColor: Colors.white,
        label: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('goods')
                .where('goodId', isEqualTo: widget.goodId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var counts = snapshot.data!.docs[0]['noOfLikes'].toString();
                return Text(counts, style: TextStyle(color: Colors.black));
              } else {
                return Text('0');
              }
            }),
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
