import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:patient/infra/themes/app_colors.dart';

class ConfirmationBottomSheet {
  BuildContext context;
  String tittle;
  String question;
  double height;
  Function onPositiveButtonClickListner;
  Function onNegativeButtonClickListner;

  ConfirmationBottomSheet(
      {required this.context,
      required this.tittle,
      required this.question,
      required this.height,
      required this.onPositiveButtonClickListner,
      required this.onNegativeButtonClickListner}) {
    showMaterialModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (context) => _showInfo());
  }

  Widget _showInfo() {
    return Container(
      height: height,
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
                tittle,
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
                  text: question,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Semantics(
                      button: true,
                      label: 'No',
                      child: ExcludeSemantics(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            onNegativeButtonClickListner();
                          },
                          child: Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width - 32,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border:
                                    Border.all(color: primaryColor, width: 1),
                                color: Colors.white),
                            child: Center(
                              child: Text(
                                'No',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: Semantics(
                      button: true,
                      label: 'Yes',
                      child: ExcludeSemantics(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            onPositiveButtonClickListner();
                          },
                          child: Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width - 32,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border:
                                    Border.all(color: primaryColor, width: 1),
                                color: primaryColor),
                            child: Center(
                              child: Text(
                                'Yes',
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
