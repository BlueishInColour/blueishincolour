import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/store/item_header.dart';
import 'package:blueishincolour/screens/store/more_item_in.dart';
import 'package:blueishincolour/screens/store/more_item_out.dart';
import 'package:blueishincolour/utils/repost_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../utils/chat_button.dart';
import '../../utils/comment_button.dart';
import '../../utils/like_button.dart';
import '../../main.dart';

class Item extends StatefulWidget {
  const Item(
      {super.key,
      this.title = 'fake title',
      this.index = 1,
      this.pictures = const [],
      this.creatorDisplayName = 'sampleDisplayName',
      this.creatorUserName = 'sampleUserName',
      this.creatorUid = 'sampleUid',
      this.creatorProfilePicture = 'https://sample',
      required this.showPix,
      this.postId = '',
      this.headPostId = '',
      required this.swipeBack,
      required this.onTap,
      this.typeOfShowlist = 'for later',
      //
      this.showCreatorDetails = true,
      this.showDressUpButton = true,
      this.showLikeButton = true,
      this.showMessageButton = true});
  final int index;
  final String title;
  final Function() onTap;
  final String postId;
  final String headPostId;
  final String creatorUserName;
  final String creatorDisplayName;
  final String creatorUid;
  final String creatorProfilePicture;
  final List<dynamic> pictures;
  final String showPix;
  final bool swipeBack;

  //
  final bool showMessageButton;
  final bool showDressUpButton;
  final bool showLikeButton;
  final bool showCreatorDetails;

  //config
  final String typeOfShowlist;

  @override
  State<Item> createState() => ItemState();
}

class ItemState extends State<Item> {
  bool showDetail = false;
  final controller = ScrollController();
  Widget button(context, {required Function() onTap}) {
    return IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.favorite_rounded,
          color: Colors.white,
        ));
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
          return MoreItemIn(
            creatorDisplayName: widget.creatorDisplayName,
            creatorProfilePicture: widget.creatorProfilePicture,
            creatorUserName: widget.creatorUserName,
            creatorUid: widget.creatorUid,
            title: widget.title,
            postId: widget.postId,
            headPostId: widget.headPostId,
            listOfPictures: widget.pictures,
          );
        }));
      },
      // onScrollRi: () {
      //   Navigator.pop(context);
      // },
      // onPanUpdate: (details) {
      //   if (details.delta.dx < 20) {
      //     Navigator.push(
      //       context,
      //       PageRouteBuilder(pageBuilder: (context, _, __) {
      //         return SteezeSection(headPostId: widget.headPostId);
      //       }),
      //     );
      //   } else {
      //     switch (widget.swipeBack) {
      //       case false:
      //         ScaffoldMessenger.of(context).showSnackBar(
      //             SnackBar(content: Text('you are at the start')));
      //         debugPrint('done');

      //         break;
      //       default:
      //         Navigator.pop(context);
      //     }
      //   }
      // },
      child: Container(
        margin: EdgeInsets.all(5),
        // height: 300,
        child: Column(
          children: [
            //headder`
            ItemHeader(
                creatorUid: widget.creatorUid,
                headPostId: widget.headPostId,
                postId: widget.postId),

            //body and image
            Stack(
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: widget.showPix, fit: BoxFit.fill,
                      errorWidget: (context, _, __) =>
                          Container(color: Colors.red),
                      placeholder: (context, _) =>
                          Container(color: Colors.black26, height: 500),

                      // images[index],
                    ),
                  ),
                ),
                Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15)),
                      height: 25,
                      width: 40,
                      child: Center(
                          child: Text(
                              '${widget.index.toString()}/${widget.pictures.length.toString()}')),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
