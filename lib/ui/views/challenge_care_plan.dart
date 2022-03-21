import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/models/startTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';

import 'home_view.dart';

//ignore: must_be_immutable
class ChallengeCarePlanView extends StatefulWidget {
  Task task;

  ChallengeCarePlanView(Task task) {
    this.task = task;
  }

  @override
  _ChallengeCarePlanViewState createState() => _ChallengeCarePlanViewState();
}

class _ChallengeCarePlanViewState extends State<ChallengeCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _textController = TextEditingController();

  @override
  void initState() {
    if (widget.task.details.challengeNotes != null) {
      _textController.text = widget.task.details.challengeNotes.toString();
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }
    super.initState();
  }

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
              'Challenge',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //headerText(),
                questionText(),
                _entryField(),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerText() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorF6F6FF,
      ),
      child: Center(
        child: Text(
          widget.task.details.challengeText,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
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
            widget.task.details.subTitle,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _entryField() {
    return Container(
      margin: EdgeInsets.all(16.0),
      height: 360,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.black54,
            width: 1.0,
          ),
        ),
        child: TextFormField(
            enabled: !widget.task.finished,
            obscureText: false,
            controller: _textController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
              color: Colors.black54,
            ),
            onFieldSubmitted: (term) {},
            decoration: InputDecoration(
                hintText: 'Write down your notes here...',
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true)),
      ),
    );
  }

  Widget _submitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Material(
          //Wrap with Material
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          elevation: 4.0,
          color: primaryColor,
          clipBehavior: Clip.antiAlias,
          // Add This
          child: MaterialButton(
            minWidth: 200,
            child: Text(!widget.task.finished ? 'Save' : 'Done',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              if (!widget.task.finished) {
                if (_textController.text == '') {
                  showToast('Please enter challenge text', context);
                } else {
                  completeChallengeTaskOfAHACarePlan(widget.task);
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }

  completeChallengeTaskOfAHACarePlan(Task task) async {
    try {
      final map = <String, String>{};
      map['ChallengeNotes'] = _textController.text;

      final StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse =
          await model.completeChallengeTask(
              task.details.carePlanId.toString(), task.details.id, map);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        assrotedUICount = 0;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(1);
        }), (Route<dynamic> route) => false);
        debugPrint(
            'AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}');
      } else {
        showToast(_startTaskOfAHACarePlanResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }
}
