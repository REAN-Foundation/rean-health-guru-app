import 'package:flutter/material.dart';
import 'package:paitent/core/models/StartAssesmentResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:progress_dialog/progress_dialog.dart';
//ignore: must_be_immutable
class BiomatricAssignmentTask extends StatefulWidget {
  Assessmment assessmment;

  BiomatricAssignmentTask(Assessmment assessmment) {
    assessmment = assessmment;
  }

  @override
  _BiomatricAssignmentTaskViewState createState() =>
      _BiomatricAssignmentTaskViewState();
}

class _BiomatricAssignmentTaskViewState extends State<BiomatricAssignmentTask> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _Controller = TextEditingController();

  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    return BaseWidget<PatientCarePlanViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Biometrics',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.black),
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  questionText(),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: primaryColor, width: 1),
                          color: Colors.white),
                      child: TextFormField(
                          controller: _Controller,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {},
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_Controller.text.isNotEmpty) {
                            Navigator.pop(context, _Controller.text);
                          } else {
                            showToast('Please enter measures', context);
                          }
                          //Navigator.of(context).pop();
                          //Navigator.pushNamed(context, RoutePaths.Home);
                        },
                        child: Container(
                            height: 40,
                            width: 120,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(color: primaryColor, width: 1),
                              color: primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget questionText() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: primaryLightColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'Enter ' + widget.assessmment.biometricName,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
