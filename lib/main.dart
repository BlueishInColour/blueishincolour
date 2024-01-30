import 'dart:async';

// import 'package:blueishincolour/screens/auth/auth_gate.dart';
import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/auth/auth_gate_two.dart';
import 'package:blueishincolour/screens/auth/login_or_signup.dart';
import 'package:blueishincolour/screens/auth/signup_screen.dart';
import 'package:blueishincolour/screens/cart/index.dart';
import 'package:blueishincolour/screens/chat/index.dart';
import 'package:blueishincolour/screens/create_post/index.dart';
import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/search/index.dart';
import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:blueishincolour/screens/store/index.dart';
import 'package:blueishincolour/utils/install_app_function.dart';
import 'package:blueishincolour/utils/shared_pref.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';
// blueishincolour@gmail.com
// Oluwapelumide631$
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // androidProvider: AndroidProvider.playIntegrity,
    webProvider:
        ReCaptchaV3Provider('6LfPKFIpAAAAAGPzlYpoSWP6keZI1ikn8aSLXj0H'),
  );

  // olami@gmail.com

  await SharedPrefs().init();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
            shape: MaterialStatePropertyAll(
                StadiumBorder(side: BorderSide(color: Colors.blue.shade600))),
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(StadiumBorder()))),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 6),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue.shade300, width: 6),
            ),
          ),
          dropdownMenuTheme: DropdownMenuThemeData(
              textStyle: TextStyle(color: Colors.white60),
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: TextStyle(fontSize: 11),
                constraints: BoxConstraints(maxHeight: 30, maxWidth: 100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.black),
                ),
                outlineBorder: BorderSide(color: Colors.black),
              ),
              menuStyle: MenuStyle(
                  maximumSize: MaterialStatePropertyAll(Size(300, 300)),
                  elevation: MaterialStatePropertyAll(0),
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.transparent)))),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  int currentMainIndex = 3;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthGateTwo(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_rounded, color: Colors.white, size: 200),
            SizedBox(height: 100),
            Text('steeze')
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
class MainIndex extends StatefulWidget {
  const MainIndex({super.key});

  @override
  State<MainIndex> createState() => MainIndexState();
}

class MainIndexState extends State<MainIndex> {
  int currentMainIndex = 0;

  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Middle(
      width: 500,
      child: Scaffold(
        body: [
          // LoginScreen(),
          // SignupScreen(),
          // LoginOrSignupScreen(),
          // AuthGateTwo(),
          StoreScreen(controller: controller),
          // BlogScre
          SearchScreen(),
          LikeScreen(),
          // kIsWeb ? showInstallBottomSheet(context) :
          CreateScreen()
          // AddItem(headPostId: ''),
          // ProfileScreen(userUid: FirebaseAuth.instance.currentUser!.uid),
          // EditProfile()
        ][currentMainIndex],
        bottomNavigationBar: Hidable(
          controller: controller,
          enableOpacityAnimation: true,
          child: BottomNavigationBar(
              currentIndex: currentMainIndex,
              onTap: (v) {
                setState(() {
                  currentMainIndex = v;
                });
              },
              showSelectedLabels: false,
              items: <BottomNavigationBarItem>[
                //
                // featured
                BottomNavigationBarItem(
                    label: 'home',
                    icon: Icon(
                      Icons.home_outlined,
                      color: Colors.black26,
                      size: 26,
                    ),
                    activeIcon: Icon(
                      Icons.home_filled,
                      color: Colors.black,
                    )),

                // blog

                BottomNavigationBarItem(
                  label: 'search',
                  icon: Icon(
                    Icons.search,
                    color: Colors.black26,
                    weight: 10,
                  ),
                  activeIcon: Icon(Icons.search, color: Colors.black),
                ),

                BottomNavigationBarItem(
                  label: 'saved',
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.black26,
                  ),
                  activeIcon: Icon(Icons.favorite_rounded, color: Colors.black),
                ),
                //chat
                BottomNavigationBarItem(
                  label: 'chat',
                  icon: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.black54,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                  activeIcon: Icon(Icons.add, color: Colors.black),
                ),
                //   BottomNavigationBarItem(
                //     label: 'profile',
                //     icon: Icon(
                //       Icons.person,
                //       color: Colors.black26,
                //     ),
                //     activeIcon: Icon(Icons.person, color: Colors.black),
                //   ),
                // ]),
                // BottomNavigationBarItem(
                //   label: 'profile',
                //   icon: Icon(Icons.person, color: Colors.black26),
                //   activeIcon: Icon(Icons.person, color: Colors.black),
                // ), // upload
                //mine
              ]),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
