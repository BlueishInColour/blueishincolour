import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueishInColourIcon extends StatefulWidget {
  const BlueishInColourIcon({super.key});

  @override
  State<BlueishInColourIcon> createState() => BlueishInColourIconState();
}

class BlueishInColourIconState extends State<BlueishInColourIcon> {
  @override
  Widget build(BuildContext context) {
    return Text('steeze 14/12/2023',
        style: GoogleFonts.pacifico(fontSize: 30, color: Colors.black));
  }
}
