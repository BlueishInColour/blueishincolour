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
          TextField(
            controller: usernameController,
            decoration: InputDecoration(hintText: 'new diplay name'),
          ),
          TextField(
            controller: displaynameController,
            decoration: InputDecoration(hintText: 'new username'),
          ),
          TextField(
            controller: typeOfUserController,
            decoration: InputDecoration(hintText: 'type of user'),
          ),
          SizedBox(height: 20),
          TextButton(
              onPressed: () async {
                Map userDetails = await getUserDetails(
                    FirebaseAuth.instance.currentUser!.uid);
                if (userDetails.isNotEmpty) {
                  debugPrint('user have been registered before ');
                  Navigator.pop(context);
                } else {
                  await FirebaseFirestore.instance.collection('users').add({
                    'uid': FirebaseAuth.instance.currentUser!.uid,
                    'userName': usernameController.text,
                    'typeOfUser': typeOfUserController.text,
                    'displayName': displaynameController.text,
                    'listOfLikers': []
                  });
                }
              },
              child: Text('save')),
          SizedBox(
            height: 100,
          ),
          Text('editing can only be done once')
        ],
      ),
    );
  }
}
