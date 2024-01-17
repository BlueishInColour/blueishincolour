import 'package:blueishincolour/screens/profile/index.dart';
import 'package:blueishincolour/screens/store/item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/blueishincolour_icon.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  late TabController tabsController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabsController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // toolbarHeight: 70,
          title: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: TabBar(
                controller: tabsController,
                isScrollable: true,
                indicatorColor: Colors.black54,
                indicatorPadding: EdgeInsets.only(top: 15),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  // Text(
                  //   'general',
                  //   style: TextStyle(color: Colors.black54),
                  // ),
                  Text(
                    'posts',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(
                    'people',
                    style: TextStyle(color: Colors.black54),
                  ),
                ]),
          ),
        ),
//add create show list button

//

        body: TabBarView(controller: tabsController, children: [
          // searchGeneral(),
          searchPosts(searchText: controller.text),
          searchPeople()
        ]));
  }
}

// import 'package:flutter/material.dart';

class searchPosts extends StatefulWidget {
  const searchPosts({super.key, required this.searchText});
  final String searchText;

  @override
  State<searchPosts> createState() => searchPostsState();
}

class searchPostsState extends State<searchPosts> {
  var searchResult = [];
  String searchText = '';

  getPostSearchResult() async {
    var res = await FirebaseFirestore.instance
        .collection('goods')
        .where('tags', arrayContainsAny: searchText.split(' '))
        .get();
    setState(() {
      searchResult = res.docs;
    });
  }

  // String searchText = widget.searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: SizedBox(
            height: 40,
            child: TextField(
              onChanged: (v) {
                setState(() {
                  searchText = v;
                });
              },
              cursorHeight: 10,
              showCursor: false,
              style: TextStyle(fontSize: 10),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                    await getPostSearchResult();
                  },
                  icon: Icon(Icons.search, size: 19, color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.black, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                ),
                hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: Colors.black),
                hintText: 'find styles and posts',
              ),
            ),
          ),
        ),
        body: searchText.isEmpty
            ? Center(child: Text('search for any post'))
            : searchResult.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: searchResult.length,
                    itemBuilder: (context, index) {
                      var documentSnapshot = searchResult[index];

                      return Item(
                        swipeBack: false,
                        creatorProfilePicture:
                            documentSnapshot['creatorProfilePicture'],
                        creatorDisplayName:
                            documentSnapshot['creatorDisplayName'],
                        creatorUserName: documentSnapshot['creatorUserName'],
                        creatorUid: documentSnapshot['creatorUid'],
                        showPix: documentSnapshot['images'][0],
                        onTap: () {},
                        // index: index,
                        title: documentSnapshot['title'],
                        pictures: documentSnapshot['images'],
                        postId: documentSnapshot['goodId'],
                        headPostId: documentSnapshot['headPostId'],
                      );
                    },
                  ));
  }
}

// import 'package:flutter/material.dart';

class searchGeneral extends StatefulWidget {
  const searchGeneral({super.key});

  @override
  State<searchGeneral> createState() => searchGeneralState();
}

class searchGeneralState extends State<searchGeneral> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          //   //treading
          //   SliverToBoxAdapter(
          //     child: Text(
          //       'trending',
          //       style: GoogleFonts.montserrat(
          //           color: Colors.black54,
          //           fontSize: 25,
          //           fontWeight: FontWeight.w800),
          //     ),
          //   ),
          // SliverToBoxAdapter(child: StreamBuilder(stream: FirebaseFirestore.instance
          // .collection('goods').orderBy(field), builder: builder),),
          //   SliverToBoxAdapter(
          //     child: SizedBox(height: 20),
          //   ),
          //raving designers(created showlists by dressapp)
          SliverToBoxAdapter(
            child: Text(
              'raving designers',
              style: GoogleFonts.montserrat(
                  color: Colors.black54,
                  fontSize: 25,
                  fontWeight: FontWeight.w800),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),

          SliverToBoxAdapter(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 160,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          documentSnapshot['profilePicture'])),
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            SizedBox(
                                width: 100,
                                child: Text(
                                  documentSnapshot['displayName'],
                                  style: TextStyle(fontSize: 13),
                                )),
                            SizedBox(
                                width: 100,
                                child: Text(
                                  '@' '${documentSnapshot['userName']}',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black54),
                                ))
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Text('no data');
              }
            },
          )),
          //summer collection(created showlist by dressapp)

          SliverToBoxAdapter(
            child: Text(
              'more collections',
              style: GoogleFonts.montserrat(
                  color: Colors.black54,
                  fontSize: 25,
                  fontWeight: FontWeight.w800),
            ),
          ),

          SliverToBoxAdapter(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 160,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var documentSnapshot = snapshot.data!.docs[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          documentSnapshot['profilePicture'])),
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            SizedBox(
                                width: 100,
                                child: Text(
                                  documentSnapshot['displayName'],
                                  style: TextStyle(fontSize: 13),
                                )),
                            SizedBox(
                                width: 100,
                                child: Text(
                                  '@' '${documentSnapshot['userName']}',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black54),
                                ))
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Text('no data');
              }
            },
          )),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class searchPeople extends StatefulWidget {
  const searchPeople({super.key});

  @override
  State<searchPeople> createState() => searchPeopleState();
}

class searchPeopleState extends State<searchPeople> {
  var searchResult = [];
  String searchText = '';

  getPeopleSearchResult() async {
    var res = await FirebaseFirestore.instance
        .collection('users')
        .where('tags', arrayContainsAny: searchText.split(' '))
        .get();
    setState(() {
      searchResult = res.docs;
    });
  }

  // String searchText = widget.searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: SizedBox(
            height: 40,
            child: TextField(
              onChanged: (v) {
                setState(() {
                  searchText = v;
                });
              },
              cursorHeight: 10,
              showCursor: false,
              style: TextStyle(fontSize: 10),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                    await getPeopleSearchResult();
                  },
                  icon: Icon(Icons.search, size: 19, color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.black, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                ),
                hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: Colors.black),
                hintText: 'find fashioneers, models, logistics',
              ),
            ),
          ),
        ),
        body: searchText.isEmpty
            ? Center(child: Text('search for anybody'))
            : searchResult.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: searchResult.length,
                    itemBuilder: (context, index) {
                      var data = searchResult[index];

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
                    },
                  ));
  }
}
