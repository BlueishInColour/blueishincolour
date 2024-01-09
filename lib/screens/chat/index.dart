import 'package:blueishincolour/utils/shared_pref.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './item.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
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
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: SizedBox(
              height: 40,
              child: TextField(
                // onTapOutside: (event) {
                //   print('event after tapedoutside');
                // },
                controller: controller,
                cursorHeight: 10,
                showCursor: false,
                style: TextStyle(fontSize: 10),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search, size: 19, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.black, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                  ),
                  hintText: 'find designers, dressmakers or friends',
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.black),
                ),
              ),
            )),
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                // .where('listOfLikers', arrayContains: 'blueish')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    if (documentSnapshot['uid'] ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: CachedNetworkImageProvider(
                              documentSnapshot['profilePicture']),
                        ),
                        title: Text(
                          documentSnapshot['displayName'],
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Text('chat myself up',
                            style: TextStyle(fontSize: 11)),
                        onTap: () => Navigator.push(context,
                            PageRouteBuilder(pageBuilder: (context, _, __) {
                          return Item(
                              profilePicture:
                                  documentSnapshot['profilePicture'],
                              uid: documentSnapshot['uid'],
                              userName: documentSnapshot['userName'],
                              displayName: documentSnapshot['displayName']);
                        })),
                      );
                    } else {
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
                              profilePicture:
                                  documentSnapshot['profilePicture'],
                              uid: documentSnapshot['uid'],
                              userName: documentSnapshot['userName'],
                              displayName: documentSnapshot['displayName']);
                        })),
                      );
                    }
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
