import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/blueishincolour_icon.dart';
import 'item.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen> {
  String url = 'https://jsonplaceholder.typicode.com/photos';

  fetch20Data() async {
    var res = await http.get(Uri.parse(url));
  }

  initState() {
    super.initState();
    fetch20Data();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.grey[100],
          title: BlueishInColourIcon(),
        ),
        SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Item();
            })
      ],
    );
  }
}
