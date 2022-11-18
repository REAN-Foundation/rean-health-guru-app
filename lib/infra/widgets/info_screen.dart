
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

//ignore: must_be_immutable
class InfoScreen extends StatefulWidget {
  String? tittle;
  String? description;
  double? height;
  Color? infoIconcolor;

  InfoScreen(
      {required this.tittle,
      required this.description,
      required this.height,
      this.infoIconcolor});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.tittle ?? 'information',
      button: true,
      child: InkWell(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          showMaterialModalBottomSheet(
              isDismissible: true,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              context: context,
              builder: (context) => _showInfo());
        },
        child: Container(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.info_outline,
              color: widget.infoIconcolor ?? primaryColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _showInfo() {
    return Container(
      height: widget.height ?? 300,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.tittle ?? 'Info',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Linkify(
                      onOpen: (link) async {
                        if (await canLaunchUrlString(link.url)) {
                          await launchUrlString(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      options: LinkifyOptions(
                        humanize: true,
                      ),
                      text:widget.description!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: textGrey,
                        ),
                      linkStyle: TextStyle(color: Colors.lightBlueAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    button: true,
                    label: 'Okay',
                    child: ExcludeSemantics(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 48,
                          width: MediaQuery.of(context).size.width - 32,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(color: primaryColor, width: 1),
                              color: primaryColor),
                          child: Center(
                            child: Text(
                              'Okay',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
