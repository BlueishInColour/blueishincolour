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
             
              height: 70,
              //

              child: GridTile(
                //t
                header: Text(
                  'dress up! and do more on spart`r, click to install for android ',
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
                    icon: CircleAvatar(radius: 50,
                      backgroundColor: Colors.amber,
                      child: Icon(
                        Icons.install_mobile,
                        color: Colors.black54,
                        size:80,
                      ),
                    )),
              )),
        ),
      ),
    );
  }
}
