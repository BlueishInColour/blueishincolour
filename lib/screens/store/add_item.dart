import 'dart:io';

import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/models/posts.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  TextEditingController tagsController = TextEditingController();

  List<String> images = [];
  List<String> tags = [];
  List<String> listOfModels = [];
  String image = '';

  var userDetails = {};

  getThoseUserDetails() async {
    var details = await getUserDetails(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      userDetails = details;
    });
  }

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

  uploadPic() async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    //Get the file from the image picker and store it
    XFile? imagei = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    var reference = _storage.ref().child("images/");

    //Upload the file to firebase
    reference.putFile(File(imagei!.path));

    // Waits till the file is uploaded then stores the download url
    String url = await _storage.ref().getDownloadURL();
    debugPrint(url);
    //returns the download url
    setState(() {
      image = url;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addImage();
    getThoseUserDetails();
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

    return image.isNotEmpty
        ? Middle(
            child: Scaffold(
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
                      String postId = Uuid().v1();
                      var post = {
                        //id
                        'postId': postId,
                        'headPostId': widget.headPostId,

                        //titles and content
                        'title': titleController.text,
                        'description': descriptionsController.text,

                        'images': images,
                        'tags': tags,

                        //creator
                        'creatorUserName': userDetails['userName'],
                        'creatorDisplayName': userDetails['displayName'],
                        'creatorUid': FirebaseAuth.instance.currentUser!.uid,
                        'creatorProfilePicture': userDetails['profilePicture'],

                        //metadata
                        'noOfLikes': 0,
                        'listOfModels': listOfModels,

                        'timestamp': Timestamp.now()
                      };

                      if (post['title'].isEmpty && post['images'].isEmpty) {
                        debugPrint('title is empty , add to it');
                      } else {
                        final DocumentReference postCollection =
                            FirebaseFirestore.instance
                                .collection('posts')
                                .doc(postId);
                        await postCollection.set(post);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'add to dressApp',
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
                              return CachedNetworkImage(
                                  imageUrl: images[index]);
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
                          height: 100,
                          maxlines: 10),
                      SizedBox(
                        height: 20,
                        width: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: tags.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black12),
                                      child: Center(
                                        child: Text(
                                          tags[index],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          tags.removeAt(index);
                                        });
                                      },
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Center(
                                          child: Icon(
                                            Icons.cancel,
                                            size: 15,
                                          ),
                                        ),
                                      ))
                                ],
                              );
                            }),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: tagsController,
                        decoration: InputDecoration(
                            hintText: 'add tags',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    tags.add(tagsController.text);
                                  });

                                  tagsController.clear();
                                },
                                icon: Icon(Icons.add))),
                      ),

                      //for models
                      SizedBox(
                        height: 20,
                        width: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: tags.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black12),
                                      child: Center(
                                        child: Text(
                                          listOfModels[index],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          tags.removeAt(index);
                                        });
                                      },
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Center(
                                          child: Icon(
                                            Icons.cancel,
                                            size: 15,
                                          ),
                                        ),
                                      ))
                                ],
                              );
                            }),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: tagsController,
                        decoration: InputDecoration(
                            hintText: 'mention models',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    tags.add(tagsController.text);
                                  });

                                  tagsController.clear();
                                },
                                icon: Icon(Icons.add))),
                      ),

                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              resizeToAvoidBottomInset: true,
            ),
          )
        : Middle(
            child: Scaffold(
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
                      border:
                          Border.all(color: Colors.grey.shade200, width: 6)),
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
            ),
          );
  }
}
