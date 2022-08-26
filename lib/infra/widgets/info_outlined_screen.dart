import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:patient/infra/themes/app_colors.dart';

//ignore: must_be_immutable
class InfoOutlinedScreen extends StatefulWidget {
  String? tittle;
  String? description;
  double? height;
  Color? infoIconcolor;

  InfoOutlinedScreen(
      {required this.tittle,
      required this.description,
      required this.height,
      this.infoIconcolor});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoOutlinedScreen> {
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
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.info_outline_rounded,
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
              RichText(
                text: TextSpan(
                  text: widget.description,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: textGrey,
                  ),
                  children: <TextSpan>[],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    button: true,
                    label: 'Alright',
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
                              'Alright',
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
