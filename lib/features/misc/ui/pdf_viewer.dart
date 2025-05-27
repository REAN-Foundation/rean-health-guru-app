import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

//ignore: must_be_immutable
class PDFScreen extends StatelessWidget {
  String pathPDF = '';
  String screenTittle = 'Reports';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  PDFScreen(this.pathPDF, this.screenTittle);

  late File file;
  static final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    file = File(pathPDF);
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            screenTittle,
            style: TextStyle(
                fontSize: 16.0,
                color: primaryColor,
                fontWeight: FontWeight.w600),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share, semanticLabel: 'Share',),
              onPressed: () {
                urlFileShare();
              },
            ),
          ],
        ),
        body: ExcludeSemantics(
          child: SfPdfViewer.file(
            file,
            key: _pdfViewerKey,
          ),
        ));
  }

  urlFileShare() async {
    final RenderBox? box =
        _globalKey.currentContext!.findRenderObject() as RenderBox?;
    final File imgFile = File(pathPDF);
    if (Platform.isAndroid) {
      /*  var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;*/

      /*imgFile.writeAsBytesSync(response.bodyBytes);*/
      /*final List fileList = List<String>.empty(growable: true);
      fileList.add(imgFile);*/
      final xFile = XFile(imgFile.path);
      await SharePlus.instance.share(
          ShareParams( files: [xFile],
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          )
      );
      /*Share.shareFiles([imgFile.path],
          subject: '',
          text: '',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);*/
    } else {
      final xFile = XFile(imgFile.path);
      await SharePlus.instance.share(
          ShareParams( files: [xFile],
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          )
      );
      /*Share.shareFiles([imgFile.path],
          subject: '',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);*/
    }
  }
}
