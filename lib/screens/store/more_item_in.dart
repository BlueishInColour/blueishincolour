import 'package:blueishincolour/screens/store/add_item.dart';

import './item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MoreItemIn extends StatefulWidget {
  const MoreItemIn(
      {super.key, required this.goodId, required this.listOfPictures});
  final String goodId;
  final List listOfPictures;

  @override
  State<MoreItemIn> createState() => MoreItemInState();
}

class MoreItemInState extends State<MoreItemIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true),
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
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('goods')
                .where('goodId', isEqualTo: widget.goodId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: widget.listOfPictures.length,
                  itemBuilder: (context, index) {
                    //get indicidual doc
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return Item(
                      onTap: () {},
                      showPix: widget.listOfPictures[index],
                      listOfLikers: documentSnapshot['listOfLikers'],
                      title: documentSnapshot['title'],
                      pictures: widget.listOfPictures,
                      id: documentSnapshot['goodId'],
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
