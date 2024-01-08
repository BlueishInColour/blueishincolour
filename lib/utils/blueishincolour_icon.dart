import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueishInColourIcon extends StatefulWidget {
  const BlueishInColourIcon({super.key});

  @override
  State<BlueishInColourIcon> createState() => BlueishInColourIconState();
}

class BlueishInColourIconState extends State<BlueishInColourIcon> {
  TextEditingController steezeSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: steezeSearchController,
        cursorHeight: 10,
        showCursor: false,
        style: TextStyle(fontSize: 10),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search, size: 19, color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.blue, width: 1),
          ),
          hintStyle: TextStyle(
              fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black),
          hintText: 'steeze - find your fashionnnn',
        ),
      ),
    );
  }
}
