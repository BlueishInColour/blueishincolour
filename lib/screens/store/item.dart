import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/store/more_item_in.dart';
import 'package:blueishincolour/screens/store/more_item_out.dart';
import 'package:blueishincolour/utils/steeze_off_button.dart';
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
      this.index = 0,
      this.pictures = const [],
      this.creatorDisplayName = 'sampleDisplayName',
      this.creatorUserName = 'sampleUserName',
      this.creatorUid = 'sampleUid',
      this.creatorProfilePicture = 'https://sample',
      required this.showPix,
      this.postId = '',
      this.headPostId = '',
      required this.swipeBack,
      required this.listOfLikers,
      required this.onTap});
  final int index;
  final String title;
  final Function() onTap;
  final String postId;
  final String headPostId;
  final String creatorUserName;
  final String creatorDisplayName;
  final String creatorUid;
  final String creatorProfilePicture;
  final List listOfLikers;
  final List<dynamic> pictures;
  final String showPix;
  final bool swipeBack;

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
            listOfLikers: widget.listOfLikers,
            title: widget.title,
            goodId: widget.postId,
            listOfPictures: widget.pictures,
          );
        }));
      },
      // onScrollRi: () {
      //   Navigator.pop(context);
      // },
      onPanUpdate: (details) {
        if (details.delta.dx < 8) {
          Navigator.push(
            context,
            PageRouteBuilder(pageBuilder: (context, _, __) {
              return SteezeSection(headPostId: widget.headPostId);
            }),
          );
        } else {
          switch (widget.swipeBack) {
            case false:
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('you are at the start')));
              debugPrint('done');

              break;
            default:
              Navigator.pop(context);
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        // height: 300,
        child: Column(
          children: [
            //headder`
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (context, _, __) {
                  return ProfileScreen(userUid: widget.creatorUid);
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.black),
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    CircleAvatar(
                        radius: 17,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.creatorProfilePicture)),
                    SizedBox(width: 5),
                    SizedBox(
                      width: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.creatorDisplayName,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            widget.creatorUserName,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 11,
                                color: Colors.white60),
                          )
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    ChatButton(
                        profilePicture: widget.creatorProfilePicture,
                        userName: widget.creatorUserName,
                        postId: widget.postId,
                        displayName: widget.creatorDisplayName,
                        uid: widget.creatorUid),
                    SteezeOffButton(
                      postId: widget.postId,
                      headPostId: widget.headPostId,
                    ),
                    Badge(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.calendar_view_month_rounded,
                        color: Colors.white60,
                        size: 20,
                      ),
                      label: Text(widget.pictures.length.toString(),
                          style: TextStyle(color: Colors.black)),
                    ),
                    LikeButton(
                        idType: 'goodId',
                        listOfLikers: widget.listOfLikers,
                        goodId: widget.postId,
                        collection: 'goods'),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),
            //body and image
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: widget.showPix, fit: BoxFit.fill,
                  errorWidget: (context, _, __) => Container(color: Colors.red),
                  placeholder: (context, _) =>
                      Container(color: Colors.black26, height: 500),

                  // images[index],
                ),
              ),
            ),
            // Positioned(
            //     bottom: 40,
            //     child: Container(
            //       margin: EdgeInsets.all(10),
            //       child: Text(
            //         widget.title,
            //         maxLines: 3,
            //         style: GoogleFonts.pacifico(
            //             color: Colors.white,
            //             fontWeight: FontWeight.w800,
            //             fontSize: 27),
            //       ),
            //     )),
          ],
        ),
      ),
    );
  }
}
