import 'package:flutter/material.dart';

class MoreItemOut extends StatefulWidget {
  const MoreItemOut({super.key});

  @override
  State<MoreItemOut> createState() => MoreItemOutState();
}

class MoreItemOutState extends State<MoreItemOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true),
        body: const Center(child: Text('more items outt')));
  }
}
