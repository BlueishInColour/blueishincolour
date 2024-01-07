import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import '../../models/user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController displaynameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(hintText: 'new diplay name'),
          ),
          TextField(
            controller: displaynameController,
            decoration: InputDecoration(hintText: 'new username'),
          ),
          SizedBox(height: 20),
          TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').add(User(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    userName: usernameController.text,
                    displayName: displaynameController.text,
                    listOfLikers: []).toJson());
              },
              child: Text('save'))
        ],
      ),
    );
  }
}
