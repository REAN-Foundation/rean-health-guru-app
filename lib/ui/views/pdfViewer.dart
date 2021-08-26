

import 'dart:io';
import 'package:share/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:paitent/ui/shared/app_colors.dart';

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);
  static GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        key: _globalKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          iconTheme: new IconThemeData(color: Colors.black),
          title: Text("Reports", style: TextStyle(
              fontSize: 16.0,
              color: primaryColor,
              fontWeight: FontWeight.w700),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {urlFileShare();},
            ),
          ],
        ),
        path: pathPDF);
  }

  Future<Null> urlFileShare() async {

    final RenderBox box = _globalKey.currentContext.findRenderObject();
    if (Platform.isAndroid) {
    /*  var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;*/
      File imgFile = new File(pathPDF);
      /*imgFile.writeAsBytesSync(response.bodyBytes);*/
      Share.shareFile(imgFile,
          subject: '',
          text: '',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share('',
          subject: '',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

  }
}