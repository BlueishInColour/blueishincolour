import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../utils/utils_functions.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController displaynameController = TextEditingController();

  TextEditingController typeOfUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(hintText: 'new diplay name'),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: displaynameController,
            decoration: InputDecoration(hintText: 'new username'),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: typeOfUserController,
            decoration: InputDecoration(hintText: 'short description'),
          ),
          SizedBox(height: 20),
          TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').add({
                  'uid': FirebaseAuth.instance.currentUser!.uid,
                  'userName': usernameController.text,
                  'typeOfUser': typeOfUserController.text,
                  'displayName': displaynameController.text,
                  'listOfLikers': [],
                  'listOfLikedPosts': []
                });
                Navigator.pop(context);
              },
              child: Text('save')),
          SizedBox(
            height: 100,
          ),
          Text('do this before signing up')
        ],
      ),
    );
  }
}
