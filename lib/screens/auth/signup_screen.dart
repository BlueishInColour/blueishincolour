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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final secondPasswordController = TextEditingController();

  //
  final displayNameController = TextEditingController();
  final userNameController = TextEditingController();
  final descriptionController = TextEditingController();
  String profilePicture = '';
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
        descriptionController.text.isNotEmpty) {
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
      await FirebaseFirestore.instance.collection('users').add({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'profilePicture': profilePicture,
        'userName': userNameController.text,
        'description': descriptionController.text,
        'displayName': displayNameController.text,
        'email': emailController.text,
        'listOfLikers': [],
        'listOfLikedPosts': []
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
              return Icon(Icons.error, color: Colors.red);
            } else if (snapshot.data!.docs.isEmpty) {
              return Icon(Icons.check, color: Colors.green);
            } else {
              return SizedBox(
                height: 5,
                width: 5,
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 0.2,
                    child: CircularProgressIndicator(
                      // value: 0.,
                      strokeWidth: 2,
                    )),
              );
            }
          } else {
            return Icon(Icons.edit);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return !setProfile
        ? Scaffold(
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
          )
        :
        //setProfile
        Scaffold(
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
                              prefixIcon: Icon(Icons.alternate_email_outlined),
                              suffixIcon: userNameSuffixIcon(context)),
                        ),

                        SizedBox(height: 15),
                        SizedBox(
                          height: 100,
                          child: TextField(
                            minLines: 3,
                            maxLines: 10,
                            controller: descriptionController,
                            decoration: InputDecoration(
                                hintText: 'describe yourself in 100 letters'),
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
          );
  }
}
