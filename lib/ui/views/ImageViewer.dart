import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';

class ImageViewer extends StatelessWidget {
  static GlobalKey _globalKey = GlobalKey();
  String path = "";
  String fileName;

  ImageViewer(this.path, this.fileName);

  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    File file = new File(path);
    progressDialog = new ProgressDialog(context);
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: new IconThemeData(color: Colors.black),
        title: Text(
          "Reports",
          style: TextStyle(
              fontSize: 16.0, color: primaryColor, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          Platform.isAndroid
              ? IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    urlFileShare();
                  },
                )
              : Container()
        ],
      ),
      body: Container(
          child: PhotoView.customChild(
        child: Image.file(file),
        //imageProvider: NetworkImage(path),
      )),
    );
  }

  Future<Null> urlFileShare() async {
    final RenderBox box = _globalKey.currentContext.findRenderObject();
    if (Platform.isAndroid) {
      /*  var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;*/
      File imgFile = new File(path);
      /*imgFile.writeAsBytesSync(response.bodyBytes);*/
      debugPrint('File Path ==> ${imgFile.path}');
      List fileList = List<String>.empty(growable: true);
      fileList.add(imgFile);
      Share.shareFiles(fileList,
          subject: '',
          text: '',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share('Hello, check your share files!',
          subject: 'URL File Share',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}
