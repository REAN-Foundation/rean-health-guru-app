import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PDFScreen extends StatelessWidget {
  String pathPDF = "";

  PDFScreen(this.pathPDF);

  static GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container() /*PDFViewerScaffold(
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
        path: pathPDF)*/
        ;
  }

  Future<Null> urlFileShare() async {
    final RenderBox box = _globalKey.currentContext.findRenderObject();
    if (Platform.isAndroid) {
      /*  var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;*/
      File imgFile = new File(pathPDF);
      /*imgFile.writeAsBytesSync(response.bodyBytes);*/
      List fileList = List<String>.empty(growable: true);
      fileList.add(imgFile);
      Share.shareFiles(fileList,
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
