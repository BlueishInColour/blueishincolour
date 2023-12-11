import 'dart:async';

import 'package:blueishincolour/screens/auth/auth_gate.dart';
import 'package:blueishincolour/screens/blog/index.dart';
import 'package:blueishincolour/screens/cart/index.dart';
import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/store/index.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

import 'utils/blueishincolour_icon.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Index(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BlueishInColourIcon(),
            SizedBox(height: 10),
            Text('find your fashion',
                style: GoogleFonts.pacifico(
                    fontSize: 0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black))
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => IndexState();
}

class IndexState extends State<Index> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        StoreScreen(),
        CartScreen(),
        BlogScreen(),
        ProfileScreen(),
      ][currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (v) {
            setState(() {
              currentIndex = v;
            });
          },
          showSelectedLabels: false,
          items: <BottomNavigationBarItem>[
//
// featured
            BottomNavigationBarItem(
                label: 'shop',
                icon: Icon(Icons.shopping_bag, color: Colors.black26),
                activeIcon: Icon(
                  Icons.shopping_bag,
                  color: Colors.black,
                  size: 30,
                )),

//mine
            BottomNavigationBarItem(
              label: 'saved',
              icon: Icon(
                Icons.favorite_rounded,
                color: Colors.black26,
              ),
              activeIcon: Icon(Icons.favorite_rounded, color: Colors.black),
            ),

// blog
            BottomNavigationBarItem(
              label: 'blogs',
              icon: Icon(Icons.table_rows_rounded, color: Colors.black26),
              activeIcon: Icon(Icons.table_rows_rounded, color: Colors.black),
            ), // upload
            BottomNavigationBarItem(
              label: 'profile',
              icon: Icon(
                Icons.person,
                color: Colors.black26,
              ),
              activeIcon: Icon(Icons.person, color: Colors.black),
            ),
          ]),
    );
  }
}
