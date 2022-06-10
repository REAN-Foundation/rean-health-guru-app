import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:patient/features/common/careplan/models/assorted_view_configs.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:webfeed/domain/atom_feed.dart';
import 'package:xml2json/xml2json.dart';

//ignore: must_be_immutable
class RSSFeildDisplayView extends StatefulWidget {
  AssortedViewConfigs? assortedViewConfigs;

  RSSFeildDisplayView(this.assortedViewConfigs);

  @override
  _RSSFeildDisplayViewState createState() => _RSSFeildDisplayViewState();
}

class _RSSFeildDisplayViewState extends State<RSSFeildDisplayView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isAdVisible = true;
  bool isLoading = false;
  late AtomFeed rss = AtomFeed();
  final myTransformer = Xml2Json();

  var discards = [
    '<rss',
    '</rss',
    'channel>',
    '<description>',
    '<copyright>',
    '<lastBuildDate>',
    '<generator',
    '<url>',
    'image>',
    '<guid',
    '<a10'
  ];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    final Directory directory = await getApplicationSupportDirectory();
    final File file = File('${directory.path}/old_xml.xml');

    try {
      setState(() {
        isLoading = true;
      });

      // This is an open REST API endpoint for testing purposes
      var api = widget.assortedViewConfigs!.task!.action!.url!.toString();
      final response = await get(Uri.parse(api));
      //debugPrint('RSS Feed ==> ${response.body.replaceAll('ï»¿', '')}');
      var channel = response.body.replaceAll('ï»¿', '');
      /*myTransformer.parse(channel);
      var json = myTransformer.toGData();
      log('RSS Feed JSON Convert==> ${json.toString()}');*/

      await file.writeAsString(channel);
      cleaningXML(file);
      //Rss rss = Rss.fromJson(parsedJson);

      //debugPrint('RSS Feed Item title ==> ${rss.channel!.item!.length.toString()}');

      /*setState(() {
        rss = channel;
        isLoading = false;
      });*/
    } on FetchDataException catch (e) {
      debugPrint('Error ==> ' + e.toString());
    }
  }

  cleaningXML(File unCleandXmlFile) async {
    final Directory directory = await getApplicationSupportDirectory();
    final File cleanXmlFile = File('${directory.path}/new_xml.xml');

    unCleandXmlFile
        .openRead()
        .map(utf8.decode)
        .transform(LineSplitter())
        .forEach((str) => () async {
              bool skip = false;
              for (int i = 0; i < discards.length; i++) {
                var discard = discards[i];
                if (str.contains(discard)) {
                  skip = true;
                  break;
                }
              }
              if (skip == false) {
                await cleanXmlFile.writeAsString(str, mode: FileMode.append);
              }
            });

    final File readyFile = File('${directory.path}/new_xml.xml');

    String cleanedXML = await readyFile.readAsString();

    log('Clean XML ==> $cleanedXML');
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: primaryColor,
          appBar: AppBar(
            elevation: 0,
                backgroundColor: primaryColor,
                brightness: Brightness.dark,
                title: Text(
                  widget.assortedViewConfigs!.header == ''
                      ? 'News Feed!'
                      : widget.assortedViewConfigs!.header!,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                iconTheme: IconThemeData(color: Colors.white),
                actions: <Widget>[
                  /*IconButton(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 32.0,
                ),
                onPressed: () {
                  debugPrint("Clicked on profile icon");
                },
              )*/
                ],
              ),
              body: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        color: primaryColor,
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: primaryColor,
                        height: 0,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12))),
                          child: body(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget body() {
    return Stack(
      children: [
        isLoading == false
            ? ListView.builder(
                itemCount: rss.items!.length,
                itemBuilder: (BuildContext context, index) {
                  final item = rss.items![index];
                  final feedItems = {
                    'title': item.title,
                    'link': item.links!.elementAt(0),
                    'date': item.updated
                  };
                  print(feedItems);
                  return InkWell(
                      onTap: () {},
                      child: ListTile(
                        title: Text(item.title.toString()),
                        subtitle: Row(
                          children: [
                            Text(DateFormat('MMM dd').format(
                                DateTime.parse(item.updated.toString())))
                          ],
                        ),
                      ));
                })
            : Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }
}
