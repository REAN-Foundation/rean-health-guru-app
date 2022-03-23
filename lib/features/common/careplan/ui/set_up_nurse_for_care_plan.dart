import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/features/common/careplan/models/AddTeamMemberResponse.dart';
import 'package:paitent/features/common/careplan/models/StartCarePlanResponse.dart';
import 'package:paitent/features/common/careplan/view_models/patients_care_plan.dart';
import 'package:paitent/features/common/emergency/ui/addNurseDialog.dart';
import 'package:paitent/features/misc/ui/base_widget.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/SharedPrefUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SetUpNurseForCarePlanView extends StatefulWidget {
  @override
  _SetUpNurseForCarePlanViewState createState() =>
      _SetUpNurseForCarePlanViewState();
}

class _SetUpNurseForCarePlanViewState extends State<SetUpNurseForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  StartCarePlanResponse startCarePlanResponse;

  //var nurseMemberList = new List<TeamMember>();
  ProgressDialog progressDialog;

  loadSharedPrefrance() async {
    try {
      startCarePlanResponse = StartCarePlanResponse.fromJson(
          await _sharedPrefUtils.read('CarePlan'));
      debugPrint(
          'AHA Care Plan id ${startCarePlanResponse.data.carePlan.id.toString()}');
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  @override
  void initState() {
    loadSharedPrefrance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*if(nurseMemberListGlobe.length != 0){
      nurseMemberListGlobe.addAll(nurseMemberListGlobe);
    }*/
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
              'Set up Your Team',
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              headerText(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Expanded(
                          child: model.busy
                              ? Center(
                                  child: SizedBox(
                                      height: 32,
                                      width: 32,
                                      child: CircularProgressIndicator()))
                              : (nurseMemberListGlobe.isEmpty)
                                  ? noDoctorFound()
                                  : doctorSearchResultListView()) //,
                    ],
                  ),
                ),
              ),
              Container(
                color: colorF6F6FF,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (model.busy)
                      Container()
                    else
                      InkWell(
                        onTap: () {
                          /*nurseMemberListGlobe.clear();
                        nurseMemberListGlobe.addAll(nurseMemberListGlobe);*/
                          Navigator.pushNamed(context,
                              RoutePaths.Setup_Family_Member_For_Care_Plan);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                  color: primaryColor,
                                  size: 16,
                                ),
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
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
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              mini: false,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return _addNurseDialog(context);
                    });
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  Widget headerText() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorF6F6FF,
      ),
      child: Center(
        child: Text(
          'Add Nurse / Social Health Worker',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget noDoctorFound() {
    return Center(
      child: Text('No nurse / social health worker found',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryLightColor)),
    );
  }

  Widget doctorSearchResultListView() {
    return ListView.separated(
        itemBuilder: (context, index) => _makeDoctorListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        itemCount: nurseMemberListGlobe.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget _makeDoctorListCard(BuildContext context, int index) {
    final TeamMember teamMember = nurseMemberListGlobe.elementAt(index);
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(children: <Widget>[
          Card(
            elevation: 0,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 60,
                          width: 60,
                          child: Image(
                            image: AssetImage(
                                'res/images/profile_placeholder.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: Text(
                                  teamMember.details.firstName +
                                      ' ' +
                                      teamMember.details.lastName,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor)),
                            ),
                            Text(teamMember.details.phoneNumber,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0XFF909CAC))),
                            Text(
                              teamMember.details.gender,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w200,
                                  color: Color(0XFF909CAC)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*Align(
            alignment: Alignment.topRight,
            child: SizedBox(
                height: 20,
                width: 20,
                child: new Image.asset('res/images/ic_cross_blue_circle.png')),
          ),*/
        ]),
      ),
    );
  }

/*Widget _makeDoctorListCard(BuildContext context, int index) {
    Doctors doctorDetails = doctorSearchList.elementAt(index);
    debugPrint(doctorDetails.specialities);
    return Container(
      height: 100,
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor, width: 1),
          borderRadius: new BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: primaryColor,
                          child: CircleAvatar(
                              radius: 38,
                              backgroundImage: doctorDetails.imageURL == "" || doctorDetails.imageURL == null
                                  ? AssetImage('res/images/profile_placeholder.png')
                                  : new NetworkImage(doctorDetails.imageURL)),
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            doctorDetails.prefix +
                                doctorDetails.firstName +
                                ' ' +
                                doctorDetails.lastName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: primaryColor)),
                        Row(
                          children: [
                            Text(
                                doctorDetails.specialities == null
                                    ? doctorDetails.qualification
                                    : doctorDetails.specialities ,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                    color: textBlack)),
                            Expanded(
                              child: Text(doctorDetails.qualification == null ? '' : ', ' +
                                  doctorDetails.qualification,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                    color: textBlack),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }*/

  Widget _addNurseDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 540,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Add Nurse / Social Health Worker',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                            fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    icon: Icon(
                      Icons.close,
                      color: primaryColor,
                    ),
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: AddNurseDialog(submitButtonListner: (String firstName,
                    String lastName, String phoneNumber, String gender) {
                  debugPrint('Team Member ==> $firstName');
                  addTeamMembers(firstName, lastName, phoneNumber, gender);
                  Navigator.of(context, rootNavigator: true).pop();
                }),
              )
            ],
          ),
        ));
  }

  addTeamMembers(String firstName, String lastName, String phoneNumber,
      String gender) async {
    try {
      model.setBusy(true);
      //progressDialog.show();

      /*TeamMemberJsonRequest jsonRequest = new TeamMemberJsonRequest();
      jsonRequest.carePlanId = startCarePlanResponse.data.carePlan.id.toString();
      jsonRequest.teamMemberType = "Pharmacy";
      jsonRequest.isEmergencyContact = true;*/
      //jsonRequest.details.userId = pharmacies.userId.toString();

      final data = <String, dynamic>{};
      data['FirstName'] = firstName;
      data['LastName'] = lastName;
      data['Prefix'] = ' ';
      data['PhoneNumber'] = phoneNumber;
      data['Gender'] = gender;

      final map = <String, dynamic>{};
      map['CarePlanId'] = startCarePlanResponse.data.carePlan.id.toString();
      map['IsEmergencyContact'] = true;
      map['TeamMemberType'] = 'HealthWorker';
      map['Details'] = data;

      final AddTeamMemberResponse addTeamMemberResponse =
          await model.addTeamMembers(map);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        //progressDialog.hide();
        setState(() {
          nurseMemberListGlobe.add(addTeamMemberResponse.data.teamMember);
        });
        showToast(addTeamMemberResponse.message, context);
      } else {
        //progressDialog.hide();
        showToast(addTeamMemberResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      //progressDialog.hide();
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException);
    }
  }
}
