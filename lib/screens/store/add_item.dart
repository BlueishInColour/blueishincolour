import 'dart:convert';
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
  const AddItem({super.key});

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
  @override
  Widget build(BuildContext context) {
    textField(context,
        {String hintText = 'write something',
        int maxlines = 1,
        required TextEditingController controller}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
      );
    }

    String privateKey = 'private_A9tBBPhf/8CSEYPp+CR986xpRzE=';
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

          debugPrint(
              data.url!); // (you will get all Response data from ImageKit)
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

    return Scaffold(
      appBar: AppBar(title: Text('add items')),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          width: 500,
          child: ListView(
            children: [
              //images
              images.isNotEmpty
                  ? SizedBox(
                      height: 400,
                      child: PageView.builder(
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(imageUrl: images[index]);
                          }),
                    )
                  : SizedBox(),
              Container(
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
              //
              textField(context,
                  hintText: 'brand ', controller: brandController),

              textField(context,
                  hintText: 'category ...', controller: categoryController),

              textField(context,
                  hintText: 'title ...', controller: titleController),
              textField(context,
                  hintText: 'descriptions ...',
                  controller: descriptionsController,
                  maxlines: 10),

              textField(context,
                  hintText: 'price NGN', controller: priceController),
              textField(context,
                  hintText: 'discounted price NGN',
                  controller: discountedPriceController),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      bottomSheet: Row(children: [
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
              Good good = Good(
                  goodId: Uuid.NAMESPACE_DNS,
                  brand: brandController.text,
                  category: categoryController.text,
                  description: descriptionsController.text,
                  images: [
                    'https://source.unsplash.com/random',
                    'https://source.unsplash.com/random',
                    'https://source.unsplash.com/random'
                  ],
                  listOfLikers: [],
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
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
            ),
          )),
        )
      ]),
    );
  }
}
