import 'package:flutter/material.dart';

class Middle extends StatefulWidget {
  const Middle({super.key, required this.child});
  final Widget child;
//keeps the app in the middle of the screen in web
  @override
  State<Middle> createState() => MiddleState();
}

class MiddleState extends State<Middle> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      child: widget.child,
    ));
  }
}
