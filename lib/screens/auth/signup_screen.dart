import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/auth/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils_functions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.onPressed});
  final void Function()? onPressed;

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  Icon usernameSuffixICon = Icon(Icons.edit);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final secondPasswordController = TextEditingController();

  //
  final List<String> userTags = [];
  final displayNameController = TextEditingController();
  final userNameController = TextEditingController();
  final captionController = TextEditingController();
  // final userTagsController = TextEditingController();
  String profilePicture = 'https://source.unsplash.com/random';
  bool setProfile = false;
  changeSetProfilebool() {
    setState(() {
      setProfile = !setProfile;
    });
  }

  signup() async {
    if (userNameController.text.isNotEmpty &&
        displayNameController.text.isNotEmpty &&
        profilePicture.isNotEmpty &&
        captionController.text.isNotEmpty) {
      if (passwordController.text != secondPasswordController.text) {
        return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('both passwords don`t match')));
      } else {
        try {
          await AuthService()
              .signup(emailController.text, passwordController.text);
        } catch (e) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            showCloseIcon: true,
          ));
        }
      }

      //create tags for user
      userTags.addAll(userNameController.text.split(' '));
      userTags.add(displayNameController.text);
      userTags.addAll(captionController.text.split(' '));
      //
      //
      await FirebaseFirestore.instance.collection('users').add({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'profilePicture': profilePicture,
        'userName': userNameController.text,
        'caption': captionController.text,
        'displayName': displayNameController.text,
        'email': emailController.text,
        'listOfLikers': [],
        'listOfLikedPosts': [],
        'listOfShowlist': ['for later']
      });
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('fill everything to complete set up'),
        showCloseIcon: true,
      ));
    }
  }

  setProfilePicture() async {
    String url = await addSingleImage();
    setState(() {
      profilePicture = url;
    });
  }

  userNameSuffixIcon(context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('userName', isEqualTo: userNameController.text)
            .snapshots(),
        builder: (context, snapshot) {
          if (userNameController.text.length > 3) {
            if (snapshot.data!.docs.isNotEmpty) {
              setState(() {
                usernameSuffixICon = Icon(Icons.error, color: Colors.red);
              });
            } else if (snapshot.data!.docs.isEmpty) {
              setState(() {
                usernameSuffixICon = Icon(Icons.check, color: Colors.green);
              });
            }

            return usernameSuffixICon;
          } else {
            return usernameSuffixICon;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return !setProfile
        ? Middle(
            width: 500,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Center(
                    child: ListView(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.key, size: 100, color: Colors.black),
                          Text('register with us and explore fashion'),
                          SizedBox(height: 15),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(hintText: 'email'),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(hintText: 'password'),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: secondPasswordController,
                            obscureText: true,
                            decoration:
                                InputDecoration(hintText: 'confirm password'),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                              onPressed: changeSetProfilebool,
                              child: Text('next'),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.black))),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text('you have an account?'),
                              TextButton(
                                  onPressed: widget.onPressed,
                                  child: Text('login now'))
                            ],
                          ),
                        ]),
                  ],
                )),
              ),
            ),
          )
        :
        //setProfile
        Middle(
            width: 500,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Center(
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: changeSetProfilebool,
                              child: Icon(Icons.arrow_back),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.black))),

                          SizedBox(height: 15),

                          //profile picture
                          CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                CachedNetworkImageProvider(profilePicture),
                          ),
                          TextButton(
                              onPressed: setProfilePicture,
                              child: Text('set profile picture')),
                          SizedBox(
                            height: 30,
                          ),
                          //set desplay name
                          TextField(
                            controller: displayNameController,
                            decoration: InputDecoration(hintText: 'name'),
                          ),
                          SizedBox(height: 15),
                          //set profile picture
                          TextField(
                            controller: userNameController,
                            decoration: InputDecoration(
                                hintText: 'unique username',
                                prefixIcon:
                                    Icon(Icons.alternate_email_outlined),
                                suffixIcon: userNameSuffixIcon(context)),
                          ),

                          SizedBox(height: 15),
                          SizedBox(
                            height: 100,
                            child: TextField(
                              minLines: 3,
                              maxLines: 10,
                              controller: captionController,
                              decoration: InputDecoration(
                                  hintText:
                                      'describe yourself in 100 letters, helps in searches'),
                            ),
                          ),

                          SizedBox(height: 15),

                          ElevatedButton(
                              onPressed: signup,
                              child: Text('finish sign up'),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.black))),

                          //back
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
