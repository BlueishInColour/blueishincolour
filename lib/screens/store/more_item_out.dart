import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './item.dart';

class MoreItemOut extends StatefulWidget {
  const MoreItemOut({super.key, required this.headPostid});
  final String headPostid;

  @override
  State<MoreItemOut> createState() => MoreItemOutState();
}

class MoreItemOutState extends State<MoreItemOut>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: true,
          title: TabBar(
              controller: tabController,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.only(top: 15),
              tabs: [
                Text(
                  'steezes',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'comments',
                  style: TextStyle(color: Colors.white),
                )
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return AddItem(headPostId: widget.headPostid);
            }));
          },
          child: Icon(Icons.add, color: Colors.white60),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            SteezeSection(headPostId: widget.headPostid),
            CommentSection(),
          ],
        ));
  }
}

// import 'package:flutter/material.dart';

class SteezeSection extends StatefulWidget {
  const SteezeSection({super.key, required this.headPostId});
  final String headPostId;

  @override
  State<SteezeSection> createState() => SteezeSectionState();
}

class SteezeSectionState extends State<SteezeSection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('goods')
            .where('headPostId', isEqualTo: widget.headPostId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('be the first to steeze-on this'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                //get indicidual doc
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                return Item(
                  onTap: () {},
                  showPix: documentSnapshot['images'][0],
                  listOfLikers: documentSnapshot['listOfLikers'],
                  title: documentSnapshot['title'],
                  pictures: documentSnapshot['images'],
                  id: documentSnapshot['goodId'],
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

// import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key});

  @override
  State<CommentSection> createState() => CommentSectionState();
}

class CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Icon(Icons.construction_sharp, size: 100));
  }
}
