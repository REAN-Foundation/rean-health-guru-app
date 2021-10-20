import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

//ignore: must_be_immutable
class PDFScreen extends StatelessWidget {
  String pathPDF = '';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  PDFScreen(this.pathPDF);

  File file;
  static final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    file = File(pathPDF);
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Reports",
            style: TextStyle(
                fontSize: 16.0,
                color: primaryColor,
                fontWeight: FontWeight.w700),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                urlFileShare();
              },
            ),
          ],
        ),
        body: SfPdfViewer.file(
          file,
          key: _pdfViewerKey,
        ));
  }

  urlFileShare() async {
    final RenderBox box = _globalKey.currentContext.findRenderObject();
    final File imgFile = File(pathPDF);
    if (Platform.isAndroid) {
      /*  var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;*/

      /*imgFile.writeAsBytesSync(response.bodyBytes);*/
      /*final List fileList = List<String>.empty(growable: true);
      fileList.add(imgFile);*/
      Share.shareFiles([imgFile.path],
          subject: '',
          text: '',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.shareFiles([imgFile.path],
          subject: '',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}
