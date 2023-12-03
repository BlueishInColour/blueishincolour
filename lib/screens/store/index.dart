import 'dart:convert';

import 'package:blueishincolour/screens/cart/index.dart';
import 'package:blueishincolour/screens/store/add_item.dart';
import 'package:easy_load_more/easy_load_more.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loadmore_listview/loadmore_listview.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import '../../models/goods.dart';
import '../../utils/blueishincolour_icon.dart';
import 'item.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen>
    with AutomaticKeepAliveClientMixin {
  bool click = false;
  String url = 'http://localhost:8080/shop';
  List<Good> listOfGood = [];
  int cartCount = 3;

  //
  Future<bool> fetch20Data() async {
    debugPrint('getting data');
    var res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {}

    List body = json.decode(res.body);
    // List product = body['products'];
    // print(product.toString());
    // print(product);
    List<Good> goods = body.map((e) => Good.fromJson(e)).toList();
    setState(() {
      listOfGood.addAll(goods);
    });
    return true;
  }

  Widget loadMoreWidget(context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: CircularProgressIndicator(),
    );
  }

  initState() {
    super.initState();
    fetch20Data();
  }

  button(context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          click = !click;
        });
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          height: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: click ? Colors.blue.shade600 : Colors.black54)),
          child: Center(
            child: Text('price',
                style: TextStyle(fontSize: 11, color: Colors.black54)),
          )),
    );
  }

  PageStorageBucket bucket = PageStorageBucket();
  @override
  bool get wantKeepAlive => true;

//search types to bring result
  Widget searcher(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.black54,
              size: 16,
            )),
        button(context),
        DropdownMenu(
          hintText: 'country',
          dropdownMenuEntries: [
            DropdownMenuEntry(
                value: 'body', label: 'body', style: ButtonStyle())
          ],
        ),
        DropdownMenu(
          hintText: 'creator',
          dropdownMenuEntries: [
            DropdownMenuEntry(
                value: 'body', label: 'body', style: ButtonStyle())
          ],
        ),
        DropdownMenu(
          hintText: 'sizes',
          dropdownMenuEntries: [
            DropdownMenuEntry(
                value: 'body', label: 'body', style: ButtonStyle())
          ],
        ),
        DropdownMenu(
          hintText: 'oiejoik',
          dropdownMenuEntries: [
            DropdownMenuEntry(
                value: 'body', label: 'body', style: ButtonStyle()),
          ],
        ),
        DropdownMenu(
          hintText: 'nigerian',
          dropdownMenuEntries: [
            DropdownMenuEntry(
                value: 'body', label: 'body', style: ButtonStyle())
          ],
        ),
        DropdownMenu(
          hintText: 'nigerian',
          dropdownMenuEntries: [
            DropdownMenuEntry(
                value: 'body', label: 'body', style: ButtonStyle())
          ],
        ),
        DropdownMenu(
          hintText: 'nigerian',
          dropdownMenuEntries: [
            DropdownMenuEntry(
                value: 'body', label: 'body', style: ButtonStyle())
          ],
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.shade600,
          onPressed: () {
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, _, __) {
              return AddItem();
            }));
          },
          child: Icon(Icons.add),
        ),
        body: CustomScrollView(slivers: [
          SliverAppBar(
              // toolbarOpacity: 0,

              elevation: 0,
              backgroundColor: Colors.transparent,
              title: BlueishInColourIcon(),
              bottom: AppBar(
                  toolbarHeight: 30,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: searcher(context))),
          listOfGood.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue.shade600),
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: 700,
                      child: LoadMoreListView.customScrollView(
                        onLoadMore: () async {
                          await fetch20Data();
                        },
                        onRefresh: () async {
                          listOfGood.clear();

                          await fetch20Data();
                        },
                        refreshBackgroundColor: Colors.white60,
                        refreshColor: Colors.blue.shade600,
                        loadMoreWidget: loadMoreWidget(context),
                        slivers: [
                          SliverList.separated(
                              key: PageStorageKey('store'),
                              //is there more data to load
                              separatorBuilder: (context, _) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: Colors.black45,
                                  ),
                                );
                              },
                              //ListView
                              itemCount: listOfGood.length,
                              itemBuilder: (context, index) {
                                return Item(
                                  goods: listOfGood[index],
                                  index: index,
                                  onTap: () {},
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
        ]));
  }
}
