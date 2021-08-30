import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetActionOfGoalPlan.dart';
import 'package:paitent/core/models/assortedViewConfigs.dart';
import 'package:paitent/core/models/startTaskOfAHACarePlanResponse.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/ui/views/home_view.dart';
import 'package:paitent/ui/views/my_medication_history.dart';
import 'package:paitent/ui/views/my_medication_prescription.dart';
import 'package:paitent/ui/views/my_medication_refill.dart';
import 'package:paitent/ui/views/my_medication_remainder.dart';
import 'package:paitent/ui/views/summary_of_my_care_plan.dart';
import 'package:paitent/ui/views/team_of_my_care_plan.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DeterminActionPlansForCarePlanView extends StatefulWidget {
  @override
  _DeterminActionPlansForCarePlanViewState createState() =>
      _DeterminActionPlansForCarePlanViewState();
}

class _DeterminActionPlansForCarePlanViewState
    extends State<DeterminActionPlansForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = TextEditingController();
  var _textEditingFocus = FocusNode();
  int id = 0;
  String radioButtonItem = 'ONE';
  GetActionOfGoalPlan getActionOfGoalPlan;
  List<int> action = new List<int>();
  ProgressDialog progressDialog;

  @override
  void initState() {
    model.setBusy(true);
    getActionOfGoalPlanApi();
    super.initState();
  }

  getActionOfGoalPlanApi() async {
    try {
      getActionOfGoalPlan = await model.getActionOfGoalPlan(startCarePlanResponseGlob.data.carePlan.id.toString());

      if (getActionOfGoalPlan.status == 'success') {
        debugPrint("AHA Care Plan ==> ${getActionOfGoalPlan.toJson()}");


      } else {
        showToast(getActionOfGoalPlan.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint(CustomException.toString());
    }
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
              'Set Care Plan Goals',
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
                  currentScreenCount(),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "It's time to act now! Please select or add the actions you will take to achieve your goals.",
                    style: TextStyle(
                        color: textBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  chooseActionPlans(),
                  const SizedBox(
                    height: 16,
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

  Widget chooseActionPlans(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            "Select your action for goal plan",
            style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 16,
          ),
          model.busy
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Expanded(
            child: ListView.builder(
                //physics: const NeverScrollableScrollPhysics(),
                itemCount: getActionOfGoalPlan.data.goals.length,
                itemBuilder: (BuildContext context, int index){
                  return new CheckboxListTile(
                      value: getActionOfGoalPlan.data.goals.elementAt(index).isChecked,
                      title: new Text(getActionOfGoalPlan.data.goals.elementAt(index).assetName),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged:(bool val){itemChange( val, index);}
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  void itemChange(bool val, int index) {
    setState(() {
      getActionOfGoalPlan.data.goals.elementAt(index).isChecked = val;
    });
  }

  Widget currentScreenCount() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                border: Border.all(
                    width: 0, color: primaryColor, style: BorderStyle.solid)),
            child: Center(
              child: Text(
                "3",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Determine Your Action Plan",
            style: TextStyle(
                color: primaryColor, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }



  Widget submitButton() {
    return InkWell(
            onTap: () {
              action.clear();
              for( int i = 0 ; i < getActionOfGoalPlan.data.goals.length ; i++ ){
                if(getActionOfGoalPlan.data.goals.elementAt(i).isChecked) {
                  action.add(getActionOfGoalPlan.data.goals.elementAt(i).id);
                }
              }
              setGoals();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.deepPurple,
                    size: 16,
                  ),
                  Text(
                    'Next',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          );
  }

  setGoals() async {
    try {
      progressDialog.show();
      var body = new Map<String, dynamic>();
      body['Actions'] = action;

      BaseResponse baseResponse  = await model.addGoalsTask(startCarePlanResponseGlob.data.carePlan.id.toString(), 'goal-actions' ,  body);

      if (baseResponse.status == 'success') {
        progressDialog.hide();
        showDialog(
            context: context,
            builder: (_) {
              return _dialog(context);
            });
      } else {
        progressDialog.hide();
        if(baseResponse.error.contains('goal already exists for this care plan')){
          showDialog(
              context: context,
              builder: (_) {
                return _dialog(context);
              });
        }else {
          showToast(baseResponse.message);
        }
      }
    } catch (e) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(e.toString());
      debugPrint('Error ==> '+e.toString());
    }
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
                        'Done!',
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
              SizedBox(height: 24,),
              Icon(
                Icons.thumb_up,
                size: 48,
                color:  Colors.deepPurple,
              ),
              SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'You are all set to Go!',
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
                  onTap: (){
                    Navigator.of(context, rootNavigator: true).pop();
                   completeMessageTaskOfAHACarePlan();
                  },
                  child: Container(
                      height: 40,
                      width: 120,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: primaryColor, width: 1),
                        color: Colors.deepPurple,),
                      child: Center(
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),




        )
    );
  }

  completeMessageTaskOfAHACarePlan() async {
    try {
      progressDialog.show();
      StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse = await model.stopTaskOfAHACarePlan(startCarePlanResponseGlob.data.carePlan.id.toString(), getTask().details.id);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        progressDialog.hide();
        assrotedUICount = 0;
        //Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return HomeView( 1 );
            }), (Route<dynamic> route) => false);
        debugPrint("AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}");
      } else {
        progressDialog.hide();
        showToast(_startTaskOfAHACarePlanResponse.message);
      }
    } catch (CustomException) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint(CustomException.toString());
    }
  }
}