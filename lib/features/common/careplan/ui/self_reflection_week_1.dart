import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient/features/common/careplan/models/get_task_of_aha_careplan_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

//ignore: must_be_immutable
class SelfReflactionWeek_1_View extends StatefulWidget {
  Task? task;

  SelfReflactionWeek_1_View(task) {
    this.task = task;
  }

  @override
  _SelfReflactionWeek_1_ViewState createState() =>
      _SelfReflactionWeek_1_ViewState();
}

class _SelfReflactionWeek_1_ViewState extends State<SelfReflactionWeek_1_View> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ProgressDialog progressDialog;
  String answer1 = '';
  String answer7 = '';

  var question2TextControler = TextEditingController();
  var question3TextControler = TextEditingController();
  var question4TextControler = TextEditingController();
  var question5TextControler = TextEditingController();
  var question6TextControler = TextEditingController();

  var focus2Node = FocusNode();
  var focus3Node = FocusNode();
  var focus4Node = FocusNode();
  var focus5Node = FocusNode();
  var focus6Node = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientCarePlanViewModel?>(
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
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
                          fontWeight: FontWeight.w600,
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
                      color: primaryColor,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                primaryLightColor),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: BorderSide(color: primaryColor)))),
                        onPressed: () {
                          answer1 = 'Good';
                          setState(() {});
                        },
                        child: Text('Good', style: TextStyle(fontSize: 14)),
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
                      color: primaryColor,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                primaryLightColor),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: BorderSide(color: primaryColor)))),
                        onPressed: () {
                          answer1 = 'Not so good';
                          setState(() {});
                        },
                        child:
                            Text('Not so good', style: TextStyle(fontSize: 14)),
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
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
                          fontWeight: FontWeight.w600,
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
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
                          fontWeight: FontWeight.w600,
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
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
                          fontWeight: FontWeight.w600,
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
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
                          fontWeight: FontWeight.w600,
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
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
                          fontWeight: FontWeight.w600,
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
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
                          fontWeight: FontWeight.w600,
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
                      child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                primaryLightColor),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: BorderSide(color: primaryColor)))),
                        onPressed: () {
                          answer7 = 'Yes';
                          setState(() {});
                        },
                        child: Text('Yes', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                primaryLightColor),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: BorderSide(color: primaryColor)))),
                        onPressed: () {
                          answer7 = 'No';
                          setState(() {});
                        },
                        child: Text('No', style: TextStyle(fontSize: 14)),
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: BoxDecoration(
                color: colorF6F6FF,
                borderRadius: BorderRadius.only(
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
                          fontWeight: FontWeight.w600,
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
                              color: primaryColor,
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
                              color: primaryColor,
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
                              color: primaryColor,
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
                              color: primaryColor,
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
                              color: primaryColor,
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
                              color: primaryColor,
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
                color: primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Done',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
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
      progressDialog.show(max: 100, msg: 'Loading...');
      progressDialog.show(max: 100, msg: 'Loading...');
      final map = <String, dynamic>{};
      map['AreYouFeelingGood'] = answer1 == 'Good';
      map['HowIsYourProgress_Text'] = question2TextControler.text;
      map['WhatsWorkingForYou_Text'] = question3TextControler.text;
      map['Takeaways_Text'] = question4TextControler.text;
      map['CourseCorrection_Text'] = question5TextControler.text;
      map['QuestionsAndConcerns_Text'] = question6TextControler.text;
      map['ReadyToProceedFurther'] = answer7 == 'Yes';

      final BaseResponse baseResponse = await model.statusCheck(
          carePlanEnrollmentForPatientGlobe!.data!.patientEnrollments!
              .elementAt(0)
              .enrollmentId
              .toString(),
          widget.task!.details!.id!,
          map);

      if (baseResponse.status == 'success') {
        progressDialog.close();
        Navigator.pop(context);
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
