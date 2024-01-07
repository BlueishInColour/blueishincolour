import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:blueishincolour/screens/store/more_item_out.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SteezeOffButton extends StatefulWidget {
  const SteezeOffButton({super.key, required this.headPostId});
  final String headPostId;
  @override
  State<SteezeOffButton> createState() => SteezeOffButtonState();
}

class SteezeOffButtonState extends State<SteezeOffButton> {
  int count = 0;

  getAggregateCount() async {
    AggregateQuerySnapshot query = await FirebaseFirestore.instance
        .collection('goods')
        .where(
          'headPostId',
          isEqualTo: widget.headPostId,
        )
        .count()
        .get();

    debugPrint('The number of products: ${query.count}');
    setState(() {
      count = query.count;
    });
  }

  getSteezeOffCount() async {
    int counts = await FirebaseFirestore.instance
        .collection('goods')
        .where(
          'goodsId',
          isEqualTo: widget.headPostId,
        )
        .snapshots()
        .length;
    // int number = counts.get();

    setState(() {
      count = counts;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getSteezeOffCount();
    getAggregateCount();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
          onPressed: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return MoreItemOut(
                selectedPage: 1,
                headPostid: widget.headPostId,
              );
            }));
          },
          icon: Badge(
            backgroundColor: Colors.blue,
            label: Text(count.toString()),
            child: Icon(
              Icons.repeat,
              color: Colors.white,
              size: 30,
              // weight: 15,
            ),
          )),
      // Text(count.toString(), style: TextStyle(color: Colors.white))
    ]);
  }
}
