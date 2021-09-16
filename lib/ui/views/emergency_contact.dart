import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/EmergencyContactResponse.dart';
import 'package:paitent/core/models/TeamCarePlanReesponse.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/viewmodels/views/common_config_model.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/addDoctorDetailsDialog.dart';
import 'package:paitent/ui/views/addFamilyMemberDialog.dart';
import 'package:paitent/ui/views/addNurseDialog.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/StringUtility.dart';

class EmergencyContactView extends StatefulWidget {
  @override
  _EmergencyContactViewState createState() => _EmergencyContactViewState();
}

class _EmergencyContactViewState extends State<EmergencyContactView> {
  var model = CommonConfigModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);

  var doctorTeam = <Contacts>[];
  var pharmaTeam = <Contacts>[];
  var socialWorkerTeam = <Contacts>[];
  var familyTeam = <Contacts>[];

  getEmergencyTeam() async {
    try {
      final EmergencyContactResponse emergencyContactResponse =
          await model.getEmergencyTeam();

      if (emergencyContactResponse.status == 'success') {
        doctorTeam.clear();
        pharmaTeam.clear();
        socialWorkerTeam.clear();
        familyTeam.clear();
        debugPrint(
            'Emergency Contact ==> ${emergencyContactResponse.toJson()}');
        _srotTeamMembers(emergencyContactResponse);
      } else {
        showToast(emergencyContactResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  _srotTeamMembers(EmergencyContactResponse emergencyContactResponse) {
    for (final teamMemeber in emergencyContactResponse.data.contacts) {
      if (teamMemeber.roleName == 'Doctor') {
        doctorTeam.add(teamMemeber);
      } else if (teamMemeber.roleName == 'Pharmacy') {
        pharmaTeam.add(teamMemeber);
      } else if (teamMemeber.roleName == 'HealthWorker') {
        socialWorkerTeam.add(teamMemeber);
      } else if (teamMemeber.roleName == 'FamilyMember') {
        familyTeam.add(teamMemeber);
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    getEmergencyTeam();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<CommonConfigModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Emergency Contact ',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                  sectionHeader('Doctor'),
                  if (model.busy)
                    Container(
                      height: 80,
                      child: Center(
                          child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator())),
                    )
                  else
                    (doctorTeam.isEmpty)
                        ? noDoctorFound()
                        : doctorSearchResultListView(),
                  const SizedBox(
                    height: 16,
                  ),
                  sectionHeader('Nurses / Social Health Workers'),
                  if (model.busy)
                    Container(
                      height: 80,
                      child: Center(
                          child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator())),
                    )
                  else
                    (socialWorkerTeam.isEmpty)
                        ? noNurseFound()
                        : nurseSearchResultListView(),
                  const SizedBox(
                    height: 16,
                  ),
                  sectionHeader('Family Members / Friends'),
                  if (model.busy)
                    Container(
                      height: 80,
                      child: Center(
                          child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator())),
                    )
                  else
                    (familyTeam.isEmpty)
                        ? noFamilyMemberFound()
                        : familyMemberSearchResultListView(),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionHeader(String tittle) {
    return Column(
      children: [
        Container(
            height: 40,
            decoration: BoxDecoration(
              color: colorF6F6FF,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: primaryLightColor, width: 0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Text(
                  tittle,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: Semantics(
                    label: tittle,
                    child: InkWell(
                      onTap: () {
                        //showToast(tittle);
                        if (tittle == 'Doctor') {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return _addEmergencyDoctorDialog(context);
                              });
                        } else if (tittle == 'Pharmacies') {
                        } else if (tittle == 'Nurses / Social Health Workers') {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return _addNurseDialog(context);
                              });
                        } else if (tittle == 'Family Members / Friends') {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return _addFamilyMemberDialog(context);
                              });
                        }
                      },
                      child: Container(
                        key: Key(tittle),
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add_circle,
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            )),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget noDoctorFound() {
    return Container(
      height: 80,
      child: Center(
        child: Text('No doctor found',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: Colors.deepPurple)),
      ),
    );
  }

  Widget doctorSearchResultListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
          itemBuilder: (context, index) => _makeDoctorListCard(context, index),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8,
            );
          },
          itemCount: doctorTeam.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true),
    );
  }

  Widget _makeDoctorListCard(BuildContext context, int index) {
    final Details details = doctorTeam.elementAt(index).details;
    return ExcludeSemantics(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 0,
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                height: 48,
                                width: 48,
                                child: Image(
                                  image: AssetImage(
                                      'res/images/profile_placeholder.png'),
                                ),
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
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 18.0),
                                  child: Text(
                                      'Dr. ' +
                                          details.firstName +
                                          ' ' +
                                          details.lastName,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor)),
                                ),
                                Text(details.gender,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0XFF909CAC))),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Phone:  ' + details.phoneNumber,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300,
                                            color: primaryColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Semantics(
                    label: 'delete_doctor',
                    child: InkWell(
                        onTap: () {
                          _removeConfirmation(doctorTeam.elementAt(index));
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete_forever,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noPharmacyFound() {
    return Container(
      height: 80,
      child: Center(
        child: Text('No pharmacy found',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: primaryLightColor)),
      ),
    );
  }

  Widget pharmacySearchResultListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
          itemBuilder: (context, index) =>
              _makePharmacyListCard(context, index),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8,
            );
          },
          itemCount: 1,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true),
    );
  }

  Widget _makePharmacyListCard(BuildContext context, int index) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
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
                          image:
                              AssetImage('res/images/profile_placeholder.png'),
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
                            child: Text('Sai Medical Stores',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor)),
                          ),
                          Text('Vijayawada, Andhra Pradesh',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0XFF909CAC))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noNurseFound() {
    return Container(
      height: 80,
      child: Center(
        child: Text('No nurse / social health worker found',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: Colors.deepPurple)),
      ),
    );
  }

  Widget nurseSearchResultListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
          itemBuilder: (context, index) => _makeNurseListCard(context, index),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8,
            );
          },
          itemCount: socialWorkerTeam.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true),
    );
  }

  Widget _makeNurseListCard(BuildContext context, int index) {
    final Details details = socialWorkerTeam.elementAt(index).details;
    return ExcludeSemantics(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 0,
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                height: 48,
                                width: 48,
                                child: Image(
                                  image: AssetImage(
                                      'res/images/profile_placeholder.png'),
                                ),
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
                                      details.firstName +
                                          ' ' +
                                          details.lastName,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor)),
                                ),
                                Text('Phone:  ' + details.phoneNumber,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        color: primaryColor)),
                                Text(
                                  details.gender,
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
                Semantics(
                    label: 'delete_nurse',
                    child: InkWell(
                        onTap: () {
                          _removeConfirmation(
                              socialWorkerTeam.elementAt(index));
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete_forever,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noFamilyMemberFound() {
    return Container(
      height: 80,
      child: Center(
        child: Text('No family member found',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: Colors.deepPurple)),
      ),
    );
  }

  Widget familyMemberSearchResultListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
          itemBuilder: (context, index) =>
              _makeFamilyMemberListCard(context, index),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8,
            );
          },
          itemCount: familyTeam.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true),
    );
  }

  Widget _makeFamilyMemberListCard(BuildContext context, int index) {
    final Details details = familyTeam.elementAt(index).details;
    return ExcludeSemantics(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 0,
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                height: 48,
                                width: 48,
                                child: Image(
                                  image: AssetImage(
                                      'res/images/profile_placeholder.png'),
                                ),
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
                                      details.firstName +
                                          ' ' +
                                          details.lastName,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor)),
                                ),
                                Text('Phone: ' + details.phoneNumber,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        color: primaryColor)),
                                Text(
                                  details.relation,
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
                Semantics(
                    label: 'delete_family_members',
                    child: InkWell(
                        onTap: () {
                          _removeConfirmation(familyTeam.elementAt(index));
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete_forever,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addEmergencyDoctorDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 580,
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
                        'Doctors',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
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
                child: AddDoctorDetailsDialog(submitButtonListner:
                    (String firstName, String lastName, String phoneNumber,
                        String gender) {
                      debugPrint('Team Member ==> $firstName');
                  addTeamMembers(
                      firstName, lastName, phoneNumber, gender, '', 'Doctor');
                  Navigator.of(context, rootNavigator: true).pop();
                }),
              )
            ],
          ),
        ));
  }

  addDoctorTeamMembers(Doctors doctors) async {
    try {
      model.setBusy(true);

      /*TeamMemberJsonRequest jsonRequest = new TeamMemberJsonRequest();
      jsonRequest.carePlanId = startCarePlanResponse.data.carePlan.id.toString();
      jsonRequest.teamMemberType = "Doctor";
      jsonRequest.isEmergencyContact = true;
      jsonRequest.details.userId = doctors.userId;*/

      final data = <String, dynamic>{};
      data['UserId'] = doctors.userId;
      data['FirstName'] = '';
      data['LastName'] = '';
      data['Prefix'] = '';
      data['PhoneNumber'] = '';
      data['Gender'] = '';

      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Type'] = 'Doctor';
      map['Details'] = data;

      final BaseResponse addTeamMemberResponse =
          await model.addTeamMembers(map);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        getEmergencyTeam();
        showToast(addTeamMemberResponse.message, context);
      } else {
        showToast(addTeamMemberResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException);
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

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
          height: 580,
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
                            fontWeight: FontWeight.bold,
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
                  addTeamMembers(firstName, lastName, phoneNumber, gender, '',
                      'HealthWorker');
                  Navigator.of(context, rootNavigator: true).pop();
                }),
              )
            ],
          ),
        ));
  }

  Widget _addFamilyMemberDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 660,
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
                        'Add FamilyMember \n/ Friends',
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
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
                child: AddFamilyMemberDialog(submitButtonListner:
                    (String firstName, String lastName, String phoneNumber,
                        String gender, String relation) {
                      debugPrint('Team Member ==> $firstName');
                  addTeamMembers(firstName, lastName, phoneNumber, gender,
                      relation, 'FamilyMember');
                  Navigator.of(context, rootNavigator: true).pop();
                }),
              )
            ],
          ),
        ));
  }

  addTeamMembers(String firstName, String lastName, String phoneNumber,
      String gender, String relation, String type) async {
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
      data['Relation'] = relation;

      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Type'] = type;
      map['Details'] = data;

      final BaseResponse addTeamMemberResponse =
          await model.addTeamMembers(map);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        getEmergencyTeam();
        showToast(addTeamMemberResponse.message, context);
      } else {
        showToast(addTeamMemberResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      //progressDialog.hide();
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException);
    } catch (Exception) {
      //progressDialog.hide();
      debugPrint(Exception.toString());
    }
  }

  _removeConfirmation(Contacts contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            'Alert!',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
                color: Colors.black),
          ),
          contentPadding: EdgeInsets.all(4.0),
          subtitle: Text(
            '\nAre you sure you want to remove this contact?',
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 14.0,
                color: Colors.black),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              removeTeamMembers(contact.id);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
    );
  }

  removeTeamMembers(String emergencyContactId) async {
    try {
      model.setBusy(true);
      final BaseResponse addTeamMemberResponse =
          await model.removeTeamMembers(emergencyContactId);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        getEmergencyTeam();
        showToast(addTeamMemberResponse.message, context);
      } else {
        showToast(addTeamMemberResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      //progressDialog.hide();
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException);
    } catch (Exception) {
      //progressDialog.hide();
      debugPrint(Exception.toString());
    }
  }
}
