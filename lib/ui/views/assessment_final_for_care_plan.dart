import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';

import 'home_view.dart';

class AssessmentFinalCarePlanView extends StatefulWidget {
  @override
  _AssessmentFinalCarePlanViewState createState() =>
      _AssessmentFinalCarePlanViewState();
}

class _AssessmentFinalCarePlanViewState
    extends State<AssessmentFinalCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final _systolicFocus = FocusNode();
  final _diastolicFocus = FocusNode();
  final _weightFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
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
              'Assessment',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                quizFinalOne(),
                /*  SizedBox(height: 20,),
                    quizFinalTwo(),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget quizFinalOne() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: colorF6F6FF,
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Please enter your\nblood pressure and weight',
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            height: 180,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: colorF6F6FF,
                                border: Border.all(color: primaryLightColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text: 'Systolic',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                color: primaryColor,
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '  mm Hg     ',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: primaryColor,
                                                      fontFamily: 'Montserrat',
                                                      fontStyle:
                                                          FontStyle.italic)),
                                            ]),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: primaryColor,
                                                  width: 1),
                                              color: Colors.white),
                                          child: TextFormField(
                                              controller: _systolicController,
                                              focusNode: _systolicFocus,
                                              maxLines: 1,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.number,
                                              onFieldSubmitted: (term) {
                                                _fieldFocusChange(
                                                    context,
                                                    _systolicFocus,
                                                    _diastolicFocus);
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Colors.white,
                                                  filled: true)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text: 'Diastolic',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                color: primaryColor,
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '  mm Hg  ',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: primaryColor,
                                                      fontFamily: 'Montserrat',
                                                      fontStyle:
                                                          FontStyle.italic)),
                                            ]),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: primaryColor,
                                                  width: 1),
                                              color: Colors.white),
                                          child: TextFormField(
                                              controller: _diastolicController,
                                              focusNode: _diastolicFocus,
                                              maxLines: 1,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.number,
                                              onFieldSubmitted: (term) {
                                                _fieldFocusChange(
                                                    context,
                                                    _diastolicFocus,
                                                    _weightFocus);
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Colors.white,
                                                  filled: true)),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: colorF6F6FF,
                                border: Border.all(color: primaryLightColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text: 'Weight',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                color: primaryColor,
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '  Kg               ',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: primaryColor,
                                                      fontFamily: 'Montserrat',
                                                      fontStyle:
                                                          FontStyle.italic)),
                                            ]),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: primaryColor,
                                                  width: 1),
                                              color: Colors.white),
                                          child: TextFormField(
                                              controller: _weightController,
                                              focusNode: _weightFocus,
                                              maxLines: 1,
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType:
                                                  TextInputType.number,
                                              onFieldSubmitted: (term) {},
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Colors.white,
                                                  filled: true)),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return _dialog(context);
                                  });
                            },
                            child: Container(
                                height: 40,
                                width: 120,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  border:
                                      Border.all(color: primaryColor, width: 1),
                                  color: primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                        ],
                      )))),
        ],
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _dialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: colorF6F6FF,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Thanks!',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              ImageIcon(
                AssetImage('res/images/ic_applause.png'),
                size: 48,
                color: primaryColor,
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Thanks for completing\nassessment!',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    //Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeView(1);
                    }), (Route<dynamic> route) => false);
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
                          'Close',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}
