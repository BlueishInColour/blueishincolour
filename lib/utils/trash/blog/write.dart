import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:imagekit_io/imagekit_io.dart';
import '../../../models/stories.dart';
import '../../utils_functions.dart';

class Write extends StatefulWidget {
  const Write({super.key});

  @override
  State<Write> createState() => WriteState();
}

class WriteState extends State<Write> {
  TextEditingController titleController = TextEditingController();
  TextEditingController articleController = TextEditingController();
  TextEditingController creatorController = TextEditingController();
  String images = '';
  @override
  Widget build(BuildContext context) {
    textField(context,
        {String hintText = 'write something',
        int maxlines = 2,
        int minlines = 1,
        required TextEditingController controller}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          minLines: minlines, maxLines: maxlines,
          controller: controller,
          //
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 6),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue.shade300, width: 6),
            ),
          ),

          //
        ),
      );
    }

    Future<String> addImage() async {
//
      final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      File file = File(xFile!.path);
      //

      String url = await ImageKit.io(
        file.readAsBytesSync(),
        fileName: 'afilename',
        //  folder: "folder_name/nested_folder", (Optional)
        privateKey: privateKey, // (Keep Confidential)
        onUploadProgress: (progressValue) {
          if (true) {
            debugPrint(progressValue.toString());
          }
        },
      ).then((ImagekitResponse data) {
        /// Get your uploaded Image file link from [ImageKit.io]
        /// then save it anywhere you want. For Example- [Firebase, MongoDB] etc.

        debugPrint(data.url!); // (you will get all Response data from ImageKit)
        return data.url!;
      });
      debugPrint(url);

      setState(() {
        images = url;
      });
      return url;
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // toolbarOpacity: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black54)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('write',
            style: GoogleFonts.pacifico(
                fontSize: 30, color: Colors.blue.shade600)),
      ),
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          textField(context,
              controller: titleController, hintText: 'title', maxlines: 3),
          textField(context,
              controller: articleController,
              hintText: 'write body',
              maxlines: 200,
              minlines: 20),
          textField(context,
              controller: creatorController, hintText: 'creator', maxlines: 3),
        ],
      ),
      bottomSheet: Row(children: [
        IconButton(
            onPressed: () async {
              String url = await addImage();
              articleController.text = '${articleController.text}'
                  '''

 $url
              
''';
            },
            icon: Icon(
              Icons.image,
              color: Colors.blue.shade600,
              size: 32,
            )),
        Expanded(
          child: SizedBox(),
        ),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: BorderRadius.circular(25),
          ),
          height: 40,
          child: Center(
              child: TextButton(
            onPressed: () async {
              Stories stories = Stories(
                createdAt: DateTime.now(),
                title: titleController.text,
                body: articleController.text,
                picture: images,
                creator: creatorController.text,
                reactions: 0,
                listOfLikers: [],
                id: Uuid().v1(),
                tags: ['lifestyle', 'tech', 'fashion'],
              );

              if (stories.body.isEmpty &&
                  stories.picture.isEmpty &&
                  stories.title.isEmpty) {
                debugPrint('images is empty , add to it');
              } else {
                final CollectionReference goodCollection =
                    FirebaseFirestore.instance.collection('stories');
                await goodCollection.add(stories.toJson());
                Navigator.pop(context);
                showSnackBar(
                    context,
                    Icon(
                      Icons.done_all_outlined,
                      color: Colors.green,
                    ),
                    'you just put out a story');
              }
            },
            child: Text(
              'publish',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
            ),
          )),
        )
      ]),
    );
  }
}
