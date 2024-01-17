import 'package:blueishincolour/screens/cart/item.dart';
import 'package:blueishincolour/utils/add_showlist_button.dart';
import 'package:blueishincolour/utils/utils_functions.dart';
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
  List listOfShowlist = ['for later', 'bobby', 'cleanme'];
  String showlistValue = '';
  bool useShowlistValue = false;

  getListOfShowlist() async {
    QuerySnapshot res = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .first;
    setState(() {
      listOfShowlist = res.docs[0]['listOfShowlist'];
    });
  }

  @override
  initState() {
    super.initState();
    getListOfShowlist();
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String dropDownValue = listOfShowlist.first;

    super.build(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [AddShowlistButton()],
          title: StreamBuilder(
              // initialData: ['for later'],
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                QueryDocumentSnapshot<Map<String, dynamic>> data =
                    snapshot.data!.docs.first;
                final List listOfShowlist = data['listOfShowlist'];
                if (snapshot.hasData) {
                  return DropdownButton(
                      value: useShowlistValue ? showlistValue : dropDownValue,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      borderRadius: BorderRadius.circular(15),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                      ),
                      items: listOfShowlist
                          .map(
                            (e) => DropdownMenuItem(
                              onTap: () {},
                              child: Text(
                                e,
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          showlistValue = v.toString();

                          useShowlistValue = true;
                        });
                      });
                } else {
                  return CircleAvatar(
                      radius: 10,
                      backgroundColor: const Color.fromARGB(0, 112, 112, 112),
                      child: CircularProgressIndicator());
                }
              })),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: db
            .collection('showlist')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection(useShowlistValue ? showlistValue : dropDownValue)
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
                  return SavedStyle(
                    postId: documentSnapshot['postId'],
                    typeOfShowlist:
                        useShowlistValue ? showlistValue : dropDownValue,
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
