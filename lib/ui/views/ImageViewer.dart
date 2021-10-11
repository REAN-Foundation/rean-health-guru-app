import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
//ignore: must_be_immutable
class ImageViewer extends StatelessWidget {
  static final GlobalKey _globalKey = GlobalKey();
  String path = '';
  String fileName;

  ImageViewer(this.path, this.fileName);

  ProgressDialog progressDialog;
  File file;

  @override
  Widget build(BuildContext context) {
    file = File(path);
    progressDialog = ProgressDialog(context);
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Reports',
          style: TextStyle(
              fontSize: 16.0, color: primaryColor, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          if (Platform.isAndroid)
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                urlFileShare();
              },
            )
          else
            Container()
        ],
      ),
      body: Container(
          child: PhotoView.customChild(
        child: Image.file(file),
        //imageProvider: NetworkImage(path),
      )),
    );
  }

  urlFileShare() async {
    final RenderBox box = _globalKey.currentContext.findRenderObject();
    if (Platform.isAndroid) {
      /*  var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;
      final File imgFile = File(path);
      /*imgFile.writeAsBytesSync(response.bodyBytes);*/
      debugPrint('File Path ==> ${imgFile.path}');
      final List fileList = List<String>.empty(growable: true);
      fileList.add(imgFile);
      Share.shareFiles(fileList,
          subject: '',
          text: '',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);*/
      Share.shareFiles([file.path],
          subject: 'Hello, check your shared file.',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share(path,
          subject: 'Hello, check your shared file.',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}
