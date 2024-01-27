import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        height: 50,
        child: ListTile(
            title:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              CircleAvatar(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.abc)),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                child:
                    IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
              ),
            ]),
            trailing: CircleAvatar(
              child: IconButton(onPressed: () {}, icon: Icon(Icons.send)),
            )),
      ),
    );
  }
}
