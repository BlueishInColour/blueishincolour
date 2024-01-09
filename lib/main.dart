import 'package:blueishincolour/screens/cart/index.dart';
import 'package:blueishincolour/screens/chat/index.dart';
import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/store/index.dart';
import 'package:flutter/material.dart';
import './screens/auth/auth_gate.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MaterialApp(debugShowCheckedModeBanner: false, home: const AuthGate()));
}

// import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => IndexState();
}

class IndexState extends State<Index> {
  int currentIndex = 0;
  BottomNavigationBarItem item(IconData icon, String label) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          size: 25,
          color: Colors.grey.shade300,
        ),
        activeIcon: Icon(
          icon,
          size: 25,
          color: Colors.black,
        ),
        label: label,
        backgroundColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: [
          StoreScreen(),
          CartScreen(),
          ChatScreen(),
          ProfileScreen()
        ][currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            currentIndex: currentIndex,
            items: [
              item(Icons.home, 'home'),
              item(Icons.favorite, 'saved'),
              item(Icons.chat_bubble, 'chat'),
              item(Icons.person, 'profile')
            ]));
  }
}
