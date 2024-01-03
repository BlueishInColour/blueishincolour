import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import '../cart/item.dart';

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
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: db
            .collection('goods')
            .where('listOfLikers',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          //if we have data, get all dic
          if (snapshot.hasData) {
            return SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: ((context, index) {
                    //get indicidual doc
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];

                    return Item(
                      onTap: () {},
                      title: documentSnapshot['title'],
                      pictures: documentSnapshot['images'],
                      id: documentSnapshot['goodId'],
                    );
                  })),
            );
          }

          return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade600));
        },
      ),
    );
  }
}
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
