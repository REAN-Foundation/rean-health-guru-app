import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/careplan/models/assorted_view_configs.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:webfeed/domain/atom_feed.dart';

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

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // This is an open REST API endpoint for testing purposes
      var api = widget.assortedViewConfigs!.task!.action!.url!.toString();
      final response = await get(Uri.parse(api));
      debugPrint('RSS Feed ==> ${response.body.replaceAll('ï»¿', '')}');
      var channel = AtomFeed.parse(response.body.replaceAll('ï»¿', ''));
      setState(() {
        rss = channel;
        isLoading = false;
      });
    } catch (err) {
      debugPrint('Error ==> $err');
      //throw err;
    }
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
                        leading: Image(
                            image: CachedNetworkImageProvider(
                                item.media!.contents![0].url.toString())),
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
