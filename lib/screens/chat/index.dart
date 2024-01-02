import 'package:blueishincolour/utils/shared_pref.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './item.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  getDetailsFromFirebase() async {
    print('trying to get data from firbase');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    print(documentSnapshot.data);
    print(documentSnapshot['userName']);
    print(documentSnapshot['displayName']);

    String userName = documentSnapshot['userName'];
    String displayName = documentSnapshot['displayName'];

    //
    //

    SharedPrefs().displayname = displayName;
    SharedPrefs().username = userName;
  }

  @override
  initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
      print(FirebaseAuth.instance.currentUser?.photoURL);
    }

    getDetailsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('listOfLikers', arrayContains: 'blueish')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                ),
                title: Text(
                  documentSnapshot['displayName'],
                  style: TextStyle(fontSize: 15),
                ),
                subtitle: Text(
                    '@${documentSnapshot['userName']} | ${documentSnapshot['typeOfUser']}',
                    style: TextStyle(fontSize: 11)),
                onTap: () => Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (context, _, __) {
                  return Item(
                      userName: documentSnapshot['userName'],
                      displayName: documentSnapshot['displayName']);
                })),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}
