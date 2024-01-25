import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

showInstallBottomSheet(context) {
  return showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            height: 70,
            //

            child: ListTile(
              //t
              title: Text(
                'dress up! and do more on dress`r, install for android ',
                style: TextStyle(fontSize: 10),
              ),
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.all(0),
              minLeadingWidth: 0,
              //
              leading: BackButton(),
              trailing: IconButton(
                  onPressed: () async {
                    debugPrint('installit');
                    // http.get(Uri.parse(widget.installLink));
                    await launchUrl(Uri.parse('https://files.fm/u/7emgbkauvd'),
                        mode: LaunchMode.inAppBrowserView,
                        webOnlyWindowName: 'download dressr');
                  },
                  icon: Icon(Icons.install_mobile)),
            ));
      });
}
