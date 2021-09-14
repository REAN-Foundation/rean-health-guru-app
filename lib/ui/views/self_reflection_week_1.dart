import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SelfReflactionWeek_1_View extends StatefulWidget {
  Task task;

  SelfReflactionWeek_1_View(@required Task task) {
    this.task = task;
  }

  @override
  _SelfReflactionWeek_1_ViewState createState() =>
      _SelfReflactionWeek_1_ViewState();
}

class _SelfReflactionWeek_1_ViewState extends State<SelfReflactionWeek_1_View> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ProgressDialog progressDialog;
  String answer1 = "";
  String answer7 = "";

  var question2TextControler = new TextEditingController();
  var question3TextControler = new TextEditingController();
  var question4TextControler = new TextEditingController();
  var question5TextControler = new TextEditingController();
  var question6TextControler = new TextEditingController();

  var focus2Node = new FocusNode();
  var focus3Node = new FocusNode();
  var focus4Node = new FocusNode();
  var focus5Node = new FocusNode();
  var focus6Node = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context);
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
              'Time to Reflect on Past Week',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: new IconThemeData(color: Colors.black),
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
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _makeQuestion1(),
                  const SizedBox(
                    height: 16,
                  ),
                  _makeQuestion2(),
                  const SizedBox(
                    height: 16,
                  ),
                  _makeQuestion3(),
                  const SizedBox(
                    height: 16,
                  ),
                  _makeQuestion4(),
                  const SizedBox(
                    height: 16,
                  ),
                  _makeQuestion5(),
                  const SizedBox(
                    height: 16,
                  ),
                  _makeQuestion6(),
                  const SizedBox(
                    height: 16,
                  ),
                  _makeQuestion7(),
                  const SizedBox(
                    height: 16,
                  ),
                  _nextWeetTask(),
                  const SizedBox(
                    height: 32,
                  ),
                  submitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeQuestion1() {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: new BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: new BoxDecoration(
                color: colorF6F6FF,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('How are you feeling?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage('res/images/ic_smile.png'),
                      size: 48,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 150,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: answer1 == 'Good'
                                    ? Colors.deepPurple
                                    : colorF6F6FF)),
                        onPressed: () {
                          answer1 = "Good";
                          setState(() {});
                        },
                        color: colorF6F6FF,
                        textColor: Colors.deepPurple,
                        child: Text("Good", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                )),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage('res/images/ic_sad.png'),
                      size: 48,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 150,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: answer1 == 'Not so good'
                                    ? Colors.deepPurple
                                    : colorF6F6FF)),
                        onPressed: () {
                          answer1 = "Not so good";
                          setState(() {});
                        },
                        color: colorF6F6FF,
                        textColor: Colors.deepPurple,
                        child:
                            Text("Not so good", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeQuestion2() {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: new BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: new BoxDecoration(
                color: colorF6F6FF,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('How is your progress?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor)),
                ],
              ),
            ),
          ),
          Container(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  obscureText: false,
                  controller: question2TextControler,
                  focusNode: focus2Node,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  onFieldSubmitted: (term) {},
                  decoration: InputDecoration(
                      hintText:
                          'Give your view of care plan progress here.\n\nPositives, negatives, frustrations and\ncertainly your accomplishments....',
                      hintMaxLines: 4,
                      hintStyle: TextStyle(fontSize: 12),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeQuestion3() {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: new BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: new BoxDecoration(
                color: colorF6F6FF,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('What\'s working for you?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor)),
                ],
              ),
            ),
          ),
          Container(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  obscureText: false,
                  controller: question3TextControler,
                  focusNode: focus3Node,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  onFieldSubmitted: (term) {},
                  decoration: InputDecoration(
                      hintText:
                          'Mention the things in care plan which are working for you. Add your comments here...',
                      hintMaxLines: 4,
                      hintStyle: TextStyle(fontSize: 12),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeQuestion4() {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: new BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: new BoxDecoration(
                color: colorF6F6FF,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Takeaways?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor)),
                ],
              ),
            ),
          ),
          Container(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  obscureText: false,
                  controller: question4TextControler,
                  focusNode: focus4Node,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  onFieldSubmitted: (term) {},
                  decoration: InputDecoration(
                      hintText:
                          'Any new learnings and experiences for you?\nAdd your comments here...',
                      hintMaxLines: 4,
                      hintStyle: TextStyle(fontSize: 12),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeQuestion5() {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: new BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: new BoxDecoration(
                color: colorF6F6FF,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Course correction',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor)),
                ],
              ),
            ),
          ),
          Container(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  obscureText: false,
                  controller: question5TextControler,
                  focusNode: focus5Node,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  onFieldSubmitted: (term) {},
                  decoration: InputDecoration(
                      hintText:
                          'Do you think you need course correction? \nComment here...',
                      hintMaxLines: 4,
                      hintStyle: TextStyle(fontSize: 12),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeQuestion6() {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: new BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: new BoxDecoration(
                color: colorF6F6FF,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Questions and Concerns',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor)),
                ],
              ),
            ),
          ),
          Container(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  obscureText: false,
                  controller: question6TextControler,
                  focusNode: focus6Node,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                  onFieldSubmitted: (term) {},
                  decoration: InputDecoration(
                      hintText:
                          'Add your concerns, doubts and notes to your doctor here...',
                      hintMaxLines: 4,
                      hintStyle: TextStyle(fontSize: 12),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeQuestion7() {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: new BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: new BoxDecoration(
                color: colorF6F6FF,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Ready to proceed further?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Are you ready and confident to continue with care plan?',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: textBlack)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: answer7 == 'Yes'
                                    ? Colors.deepPurple
                                    : colorF6F6FF)),
                        onPressed: () {
                          answer7 = "Yes";
                          setState(() {});
                        },
                        color: colorF6F6FF,
                        textColor: Colors.deepPurple,
                        child: Text("Yes", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    SizedBox(
                      width: 80,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: answer7 == 'No'
                                    ? Colors.deepPurple
                                    : colorF6F6FF)),
                        onPressed: () {
                          answer7 = "No";
                          setState(() {});
                        },
                        color: colorF6F6FF,
                        textColor: Colors.deepPurple,
                        child: Text("No", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextWeetTask() {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: new BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: new BoxDecoration(
                color: colorF6F6FF,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('What to expect in next week?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryColor)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          //child: Container(color: Colors.white,),),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                            child: Icon(
                              Icons.brightness_1,
                              color: Colors.deepPurple,
                              size: 8,
                            ),
                          ),
                          flex: 1),
                      //SizedBox(width: 8.0,),
                      Expanded(
                        flex: 10,
                        child: Text(
                          'You will learn why \'Heart Failure Management\' is important.',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              color: Colors.deepPurple,
                              fontSize: 14.0),
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ]),
                SizedBox(
                  height: 8,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          //child: Container(color: Colors.white,),),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                            child: Icon(
                              Icons.brightness_1,
                              color: Colors.deepPurple,
                              size: 8,
                            ),
                          ),
                          flex: 1),
                      //SizedBox(width: 8.0,),
                      Expanded(
                        flex: 10,
                        child: Text(
                          'Learn about the risks of heart failure.',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              color: Colors.deepPurple,
                              fontSize: 14.0),
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ]),
                SizedBox(
                  height: 8,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          //child: Container(color: Colors.white,),),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                            child: Icon(
                              Icons.brightness_1,
                              color: Colors.deepPurple,
                              size: 8,
                            ),
                          ),
                          flex: 1),
                      //SizedBox(width: 8.0,),
                      Expanded(
                        flex: 10,
                        child: Text(
                          'Learn about treatments for heart failure',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              color: Colors.deepPurple,
                              fontSize: 14.0),
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ]),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButton() {
    return model.busy
        ? Center(
            child: CircularProgressIndicator(),
          )
        : InkWell(
            onTap: () {
              updateWeeklyReflection();
            },
            child: Container(
              height: 40,
              width: 160,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.deepPurple,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Done',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          );
  }

  updateWeeklyReflection() async {
    try {
      progressDialog.show();
      var map = new Map<String, dynamic>();
      map['AreYouFeelingGood'] = answer1 == 'Good';
      map['HowIsYourProgress_Text'] = question2TextControler.text;
      map['WhatsWorkingForYou_Text'] = question3TextControler.text;
      map['Takeaways_Text'] = question4TextControler.text;
      map['CourseCorrection_Text'] = question5TextControler.text;
      map['QuestionsAndConcerns_Text'] = question6TextControler.text;
      map['ReadyToProceedFurther'] = answer7 == 'Yes';

      BaseResponse baseResponse = await model.statusCheck(
          startCarePlanResponseGlob.data.carePlan.id.toString(),
          widget.task.details.id,
          map);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
        Navigator.pop(context);
      } else {
        showToast(baseResponse.message, context);
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
