
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/careplan/models/assorted_view_configs.dart';
import 'package:patient/features/common/careplan/models/get_user_task_details.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/utils/WebViewBrowser.dart';

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
  bool isLoading = true;
  List<Newsfeed>? _newsfeed;

  @override
  void initState() {
    viewJsonData();
    super.initState();
  }

  viewJsonData() {
    debugPrint(
        'RAW Content Length ==> ${widget.assortedViewConfigs!.task!.action!.rawContent!.newsfeed!.length}');

    _newsfeed = widget.assortedViewConfigs!.task!.action!.rawContent!.newsfeed;

    isLoading = false;

    setState(() {});
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
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
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
            itemCount: _newsfeed!.length,
                itemBuilder: (BuildContext context, index) {
                  return InkWell(
                      onTap: () {
                        /*_launchURL(_newsfeed!
                            .elementAt(index)
                            .link!
                            .replaceAll(' ', '%20'));*/
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return WebViewBrowser(
                              tittle: 'News Feed',
                              url: _newsfeed!
                                  .elementAt(index)
                                  .link!
                                  .replaceAll(' ', '%20'));
                        }));
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 1,
                        semanticContainer: false,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  _newsfeed!.elementAt(index).title.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 32,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ));
                })
            : Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }

/*  _launchURL(String url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(Uri.parse(url))
    } else {
      showToast('Could not launch $url', context);
      //throw 'Could not launch $url';
    }
  }*/
}
