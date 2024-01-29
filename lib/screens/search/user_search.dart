import 'package:blueishincolour/middle.dart';
import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/search/index.dart';
import 'package:blueishincolour/screens/search/post_search.dart';
import 'package:blueishincolour/screens/store/item/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/blueishincolour_icon.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({super.key, required this.searchText});
  final String searchText;

  @override
  State<UserSearch> createState() => UserSearchState();
}

class UserSearchState extends State<UserSearch> {
  // String searchText = widget.searchText;

  @override
  Widget build(BuildContext context) {
    return Middle(
      width: 500,
      child: Scaffold(
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('tags', arrayContainsAny: widget.searchText.split(' '))
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      if (snapshot.hasData) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(context,
                                PageRouteBuilder(pageBuilder: (context, _, __) {
                              return ProfileScreen(
                                userUid: data['uid'],
                              );
                            }));
                          },
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              data['profilePicture'],
                            ),
                          ),
                          title: Text(data['displayName']),
                          subtitle: Text('@' '${data['userName']}'),
                        );
                      }
                    },
                  );
                }

                //

                return Center(
                  child: Text('search for anybodyt'),
                );
              })),
    );
  }
}
