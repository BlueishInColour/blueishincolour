import 'package:blueishincolour/middle.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

class InstallApp extends StatefulWidget {
  const InstallApp({super.key});

  @override
  State<InstallApp> createState() => InstallAppState();
}

class InstallAppState extends State<InstallApp> {
  @override
  Widget build(BuildContext context) {
    return Middle(
      child: Scaffold(
        body: Center(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              height: 70,
              //

              child: GridTile(
                //t
                header: Text(
                  'dress up! and do more on spart`r, install for android ',
                  style: TextStyle(fontSize: 10, color: Colors.white60),
                ),

                child: IconButton(
                    onPressed: () async {
                      debugPrint('installit');
                      // http.get(Uri.parse(widget.installLink));
                      await launchUrl(
                          Uri.parse('https://files.fm/u/7emgbkauvd'),
                          mode: LaunchMode.inAppBrowserView,
                          webOnlyWindowName: 'download dressr');
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(
                        Icons.install_mobile,
                        color: Colors.black54,
                        size: 200,
                      ),
                    )),
              )),
        ),
      ),
    );
  }
}
