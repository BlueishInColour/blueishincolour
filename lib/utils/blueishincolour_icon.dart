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
    return TextField(
      onTapOutside: (event) {
        print('event after tapedoutside');
      },
      controller: steezeSearchController,
      cursorHeight: 10,
      showCursor: false,
      style: TextStyle(fontSize: 10),
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.search, size: 19),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.black, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.black54, width: 1),
        ),
        hintText: 'steeze - find your fashion',
        hintStyle: GoogleFonts.pacifico(
          fontStyle: FontStyle.italic,
          fontSize: 14,
        ),
      ),
    );
  }
}
