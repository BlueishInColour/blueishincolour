import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/stories.dart';

class Read extends StatefulWidget {
  const Read({super.key, required this.stories});
  final Stories stories;
  @override
  State<Read> createState() => ReadState();
}

class ReadState extends State<Read> {
  var links = [];
  convertStringToLink(String textData) {
    //
    final urlRegExp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    final urlMatches = urlRegExp.allMatches(textData);
    List<String> urls = urlMatches
        .map((urlMatch) => textData.substring(urlMatch.start, urlMatch.end))
        .toList();
    List linksString = [];
    urls.forEach((String linkText) {
      linksString.add(linkText);
    });

    return linksString;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    convertStringToLink(widget.stories.body);
  }

  @override
  Widget build(BuildContext context) {
    Stories stories = widget.stories;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black54)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(stories.title,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 70,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              textDirection: TextDirection.rtl,
              children: [
                Icon(Icons.favorite, color: Colors.black54),
                SizedBox(width: 10),
                Text(
                  widget.stories.reactions.toString(),
                  style: TextStyle(color: Colors.black54),
                ),
                Expanded(child: SizedBox()),
                Text(
                  stories.creatorName,
                  style: GoogleFonts.pacifico(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                Text.rich(TextSpan(children: []))
              ],
            ),
            Text(stories.body)
          ],
        ),
      ),
    );
  }
}

// String convertStringToLink(String textData) {
//   //
//   final urlRegExp = new RegExp(
//   r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
//   final urlMatches = urlRegExp.allMatches(textData);
//   List<String> urls = urlMatches.map(
//           (urlMatch) => textData.substring(urlMatch.start, urlMatch.end))
//       .toList();
//   List linksString = [];
//   urls.forEach((String linkText){
//     linksString.add(linkText);
//   });

//   if (linksString.length > 0) {
//     linksString.forEach((linkTextData) {
//       textData = textData.replaceAll(
//           linkTextData,
//           '<a href="' +
//               linkTextData +
//               '" target="_blank">' +
//               linkTextData +
//               '</a>');
//     });
//   }
//   return textData;
// }
