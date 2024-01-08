import 'package:blueishincolour/main.dart';
import 'package:blueishincolour/screens/profile/edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(
                        'https://source.unsplash.com/random',
                      ))),
              child: Dialog(
                backgroundColor: Colors.white24,
                child: SignInScreen(
                  providers: [
                    EmailAuthProvider(),
                  ],
                  subtitleBuilder: (context, action) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: action == AuthAction.signIn
                          ? const Text(
                              'Welcome to BlueishInColour, please sign in!')
                          : EditProfile(),
                    );
                  },
                  footerBuilder: (context, action) {
                    return Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'By signing in, you agree to our terms and conditions.',
                          style: TextStyle(color: Colors.grey),
                        ));
                  },
                ),
              ),
            );
          }

          return const Index();
        },
      ),
    );
  }
}
