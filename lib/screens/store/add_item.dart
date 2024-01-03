import 'dart:io';

import 'package:blueishincolour/models/goods.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagekit_io/imagekit_io.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key, required this.headPostId});
  final String headPostId;

  @override
  State<AddItem> createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  TextEditingController brandController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionsController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  List<String> images = [];
  String image = '';

  String privateKey = 'private_A9tBBPhf/8CSEYPp+CR986xpRzE=';

  Future<String> addSingleImage() async {
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
      image = url;
    });
    return url;
  }

  addImage() async {
//
    final xFile = await ImagePicker().pickMultiImage();

    List<File> listOfXfile = [];

    xFile.forEach(
      (element) {
        listOfXfile.add(File(element.path));
      },
    );

    //

    List<String> listOfUrl = [];
    for (var i = 0; i < listOfXfile.length; i++) {
      await ImageKit.io(
        listOfXfile[i].readAsBytesSync(),
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
        listOfUrl.add(data.url!);
      });
    }

    print(listOfUrl);

    //
    setState(() {
      images.addAll(listOfUrl);
    });
    debugPrint('images');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addImage();
  }

  @override
  Widget build(BuildContext context) {
    textField(context,
        {String hintText = 'write something',
        int maxlines = 1,
        double height = 45,
        required TextEditingController controller}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          height: height,
          child: TextField(
            minLines: 1, maxLines: maxlines,
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
        ),
      );
    }

    return images.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: true,
              leading: IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Good good = Good(
                        goodId: Uuid.NAMESPACE_DNS,
                        brand: brandController.text,
                        category: categoryController.text,
                        description: descriptionsController.text,
                        images: images,
                        listOfLikers: [],
                        headPostId: widget.headPostId,
                        title: titleController.text);

                    if (good.title.isEmpty) {
                      debugPrint('images is empty , add to it');
                    } else {
                      final CollectionReference goodCollection =
                          FirebaseFirestore.instance.collection('goods');
                      await goodCollection.add(good.toJson());
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'add to store',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Container(
                margin: EdgeInsets.all(10),
                width: 500,
                child: ListView(
                  children: [
                    //images
                    SizedBox(
                      height: 400,
                      child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(imageUrl: images[index]);
                          }),
                    ),

                    //
                    Text(
                        '${images.length.toString()} images - scroll sideways'),
                    textField(context,
                        hintText: 'title ...', controller: titleController),
                    textField(context,
                        hintText: 'descriptions ...',
                        controller: descriptionsController,
                        height: 300,
                        maxlines: 10),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
            resizeToAvoidBottomInset: true,
          )
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.black,
            ),
            body: Center(
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200, width: 6)),
                height: 50,
                child: Center(
                    child: TextButton(
                  onPressed: () async {
                    await addImage();
                  },
                  child: Text('+  click to add image  +'),
                )),
              ),
            ),
          );
  }
}
