import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../models/goods.dart';

class FirestoreServices {
//get collection of goods
  final CollectionReference goods =
      FirebaseFirestore.instance.collection('goods');

  //CREATE
  Future<void> addGoods(Map<String, dynamic> good) async {
    debugPrint('goods adding');

    await goods.add(good);
  }

  // READ
  Stream<QuerySnapshot> getGoodsStream() {
    final goodsStream = goods.limit(20).snapshots();
    print(goodsStream);
    return goodsStream;
  }
}
