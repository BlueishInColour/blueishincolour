import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import '../store/item.dart';

// import 'package:flutter/material.dart';

//
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('saved',
            style: GoogleFonts.montserratAlternates(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            )),
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: db
            .collection('goods')
            .where('listOfLikers',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          //if we have data, get all dic

          if (snapshot.data?.docs.length == 0) {
            return Center(
              child: Text(
                "any style you like will appear here",
                style: TextStyle(color: Colors.black54),
              ),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
//

                  //get indicidual doc
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  return Item(
                    swipeBack: true,
                    listOfLikers: documentSnapshot['listOfLikers'],
                    showPix: documentSnapshot['images'][0],
                    onTap: () {},
                    title: documentSnapshot['title'],
                    pictures: documentSnapshot['images'],
                    postId: documentSnapshot['goodId'],
                    creatorDisplayName: documentSnapshot['creatorDisplayName'],
                    creatorUserName: documentSnapshot['creatorUserName'],
                    creatorProfilePicture:
                        documentSnapshot['creatorProfilePicture'],
                    creatorUid: documentSnapshot['creatorUid'],
                  );
                }));
          }

          return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade600));
        },
      ),
    );
  }
}



// class SavedScreen extends StatefulWidget {
//   const SavedScreen({super.key});

//   @override
//   State<SavedScreen> createState() => SavedScreenState();
// }

// class SavedScreenState extends State<SavedScreen>
//     with TickerProviderStateMixin {
//   late TabController controller;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     controller = TabController(length: 2, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: TabBar(
//         controller: controller,
//         indicatorColor: Colors.white,
//         indicatorSize: TabBarIndicatorSize.label,
//         indicatorPadding: EdgeInsets.only(top: 15),
//         tabs: [
//           Text('all', style: TextStyle(color: Colors.white)),
//           Text('mine', style: TextStyle(color: Colors.white))
//         ],
//       )),
//       body: TabBarView(controller: controller, children: [
//         CartScreen(),
//         // PostSection(),
//       ]),
//     );
//   }
// }

//sevices
// SliverToBoxAdapter(
//   child: SizedBox(
//     height: 250,
//     child: GridView.count(
//       crossAxisCount: 4,
//       crossAxisSpacing: 5,
//       mainAxisSpacing: 5,
//       children: [
//         //services such as fabrics, loundry, cloth makers, agents , designers, logistics,
//         GridTile(
//           child: Container(child: LineIcon.store()),
//           footer: Center(child: Text('fabric')),
//         ),
//         GridTile(
//           child: Container(child: Icon(Icons.cut_rounded)),
//           footer: Center(child: Text('designers')),
//         ),
//         GridTile(
//           child: Container(child: LineIcon.tape()),
//           footer: Center(child: Text('dressmakers')),
//         ),
//         GridTile(
//           child: Container(child: Icon(Icons.electric_bike)),
//           footer: Center(child: Text('logitics')),
//         ),
//         GridTile(
//           child: Container(child: Icon(Icons.iron)),
//           footer: Center(child: Text('loundry')),
//         ),
//         GridTile(
//           child: Container(child: Icon(Icons.shopping_bag)),
//           footer: Center(child: Text('boutque')),
//         ),
//         GridTile(
//           child: Container(child: Icon(Icons.watch)),
//           footer: Center(child: Text('accessories')),
//         ),
//         GridTile(
//           child: Container(child: Icon(Icons.bug_report_rounded)),
//           footer: Center(child: Text('report')),
//         ),
//       ],
//     ),
//   ),
// ),

//

// SliverAppBar(
//   backgroundColor: Colors.transparent,
//   elevation: 0,
//   title: Row(
//     children: [
//       Icon(Icons.favorite_rounded, color: Colors.black, size: 30),
//       SizedBox(width: 10),
//       Text('picks',
//           style: GoogleFonts.montserrat(
//               color: Colors.black,
//               fontWeight: FontWeight.w900,
//               fontSize: 30)),
//     ],
//   ),
//   actions: [
//     IconButton(
//         onPressed: () {},
//         icon: Icon(Icons.search, color: Colors.black))
//   ],
// ),

// class PostSection extends StatefulWidget {
//   const PostSection({super.key});

//   @override
//   State<PostSection> createState() => PostSectionState();
// }

// class PostSectionState extends State<PostSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('stories')
//             .where('listOfLikers',
//                 arrayContains: FirebaseAuth.instance.currentUser!.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           //if we have data, get all dic
//           if (snapshot.hasData) {
//             return ListView.builder(
//                 itemCount: snapshot.data?.docs.length,
//                 itemBuilder: ((context, index) {
//                   //get indicidual doc
//                   DocumentSnapshot documentSnapshot =
//                       snapshot.data!.docs[index];

//                   return ItemTwo(
//                     onTap: () {},
//                     title: documentSnapshot['title'],
//                     creator: documentSnapshot['creator'],
//                     picture: documentSnapshot['picture'],
//                     index: index,
//                   );
//                 }));
//           }

//           return Center(
//               child: CircularProgressIndicator(color: Colors.blue.shade600));
//         },
//       ),
//     );
//   }
// }
