
import 'package:flutter/material.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/appointment_booking/models/pharmacy_list_api_response.dart';
import 'package:patient/features/common/careplan/models/add_team_member_response.dart';
import 'package:patient/features/common/careplan/models/team_careplan_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/common/emergency/ui/add_family_member_dialog.dart';
import 'package:patient/features/common/emergency/ui/add_nurse_dialog.dart';
import 'package:patient/features/common/emergency/ui/add_pharma_dialog.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

import '../../emergency/ui/add_doctor_dialog.dart';

class TeamOfMyCarePlanView extends StatefulWidget {
  @override
  _TeamOfMyCarePlanViewState createState() => _TeamOfMyCarePlanViewState();
}

class _TeamOfMyCarePlanViewState extends State<TeamOfMyCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var doctorTeam = <Team>[];
  var pharmaTeam = <Team>[];
  var socialWorkerTeam = <Team>[];
  var familyTeam = <Team>[];

  getAHACarePlanSummary() async {
    try {
      final TeamCarePlanReesponse teamCarePlanReesponse =
          await model.getAHACarePlanTeam(carePlanEnrollmentForPatientGlobe!
              .data!.patientEnrollments!
              .elementAt(0)
              .enrollmentId
              .toString());

      if (teamCarePlanReesponse.status == 'success') {
        doctorTeam.clear();
        pharmaTeam.clear();
        socialWorkerTeam.clear();
        familyTeam.clear();
        debugPrint('AHA Care Plan ==> ${teamCarePlanReesponse.toJson()}');
        _srotTeamMembers(teamCarePlanReesponse);
      } else {
        showToast(teamCarePlanReesponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  _srotTeamMembers(TeamCarePlanReesponse teamCarePlanReesponse) {
    for (final teamMemeber in teamCarePlanReesponse.data!.team!) {
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
    getAHACarePlanSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                sectionHeader('Doctor'),
                const SizedBox(
                  height: 16,
                ),
                    if (model!.busy)
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
                sectionHeader('Pharmacies'),
                const SizedBox(
                  height: 16,
                ),
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
                  (pharmaTeam.isEmpty)
                      ? noPharmacyFound()
                      : pharmacySearchResultListView(),
                const SizedBox(
                  height: 16,
                ),
                sectionHeader('Nurses / Social Health Workers'),
                const SizedBox(
                  height: 16,
                ),
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
                const SizedBox(
                  height: 16,
                ),
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
    );
  }

  Widget sectionHeader(String tittle) {
    return Column(
      children: [
        Container(
            height: 30,
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
                      fontWeight: FontWeight.w600),
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
        barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return _addEmergencyDoctorDialog(context);
                              });
                        } else if (tittle == 'Pharmacies') {
                          showDialog(
        barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return _addPharmaciesDialog(context);
                              });
                        } else if (tittle == 'Nurses / Social Health Workers') {
                          showDialog(
        barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return _addNurseDialog(context);
                              });
                        } else if (tittle == 'Family Members / Friends') {
                          showDialog(
        barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return _addFamilyMemberDialog(context);
                              });
                        }
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.add_circle,
                          color: primaryColor,
                          size: 24,
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
                color: primaryLightColor)),
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
    final Details details = doctorTeam.elementAt(index).details!;
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
                                        details.firstName! +
                                        ' ' +
                                        details.lastName!,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor)),
                              ),
                              Text(details.gender!,
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
                                  Text('Phone: +91 ' + details.phoneNumber!,
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
                        child: Icon(
                          Icons.delete_forever,
                          color: primaryColor,
                          size: 24,
                        ),
                      )))
            ],
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
          itemCount: pharmaTeam.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true),
    );
  }

  Widget _makePharmacyListCard(BuildContext context, int index) {
    final Details details = pharmaTeam.elementAt(index).details!;
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
                                    details.firstName! +
                                        ' ' +
                                        details.lastName!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor)),
                              ),
                              Text('Phone: +91 ' + details.phoneNumber!,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: primaryColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Semantics(
                  label: 'delete_pharma',
                  child: InkWell(
                      onTap: () {
                        _removeConfirmation(pharmaTeam.elementAt(index));
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.delete_forever,
                          color: primaryColor,
                          size: 24,
                        ),
                      )))
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
                color: primaryLightColor)),
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
    final Details details = socialWorkerTeam.elementAt(index).details!;
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
                                    details.firstName! +
                                        ' ' +
                                        details.lastName!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor)),
                              ),
                              Text('Phone: +91 ' + details.phoneNumber!,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: primaryColor)),
                              Text(
                                details.gender!,
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
                        _removeConfirmation(socialWorkerTeam.elementAt(index));
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.delete_forever,
                          color: primaryColor,
                          size: 24,
                        ),
                      )))
            ],
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
                color: primaryLightColor)),
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
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true),
    );
  }

  Widget _makeFamilyMemberListCard(BuildContext context, int index) {
    final Details details = familyTeam.elementAt(index).details!;
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
                                    details.firstName! +
                                        ' ' +
                                        details.lastName!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor)),
                              ),
                              Text('Phone: +91 ' + details.phoneNumber!,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: primaryColor)),
                              Text(
                                details.relation!,
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
                  label: 'delete_family_member',
                  child: InkWell(
                      onTap: () {
                        _removeConfirmation(familyTeam.elementAt(index));
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.delete_forever,
                          color: primaryColor,
                          size: 24,
                        ),
                      )))
            ],
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
                        'Select Doctors',
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
                child: AddDoctorDialog(submitButtonListner: (Doctors doctors) {
                  addDoctorTeamMembers(doctors);
                  debugPrint('Call back Received ==> ${doctors.firstName}');
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
      final data = <String, dynamic>{};
      data['UserId'] = doctors.userId;
      data['FirstName'] = '';
      data['LastName'] = '';
      data['Prefix'] = '';
      data['PhoneNumber'] = '';
      data['Gender'] = '';

      final map = <String, dynamic>{};
      map['CarePlanId'] = carePlanEnrollmentForPatientGlobe!
          .data!.patientEnrollments!
          .elementAt(0)
          .enrollmentId
          .toString();
      map['IsEmergencyContact'] = true;
      map['TeamMemberType'] = 'Doctor';
      map['Details'] = data;

      final AddTeamMemberResponse addTeamMemberResponse =
          await model.addTeamMembers(map);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        getAHACarePlanSummary();
        showToast(addTeamMemberResponse.message!, context);
      } else {
        showToast(addTeamMemberResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  Widget _addPharmaciesDialog(BuildContext context) {
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
                        'Select Pharmacy',
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
                child: AddPharmaDialog(
                    submitButtonListner: (Pharmacies pharmacies) {
                      addPharmaciesTeamMembers(pharmacies);
                  debugPrint('Call back Received ==> ${pharmacies.firstName}');
                  Navigator.of(context, rootNavigator: true).pop();
                }),
              )
            ],
          ),
        ));
  }

  addPharmaciesTeamMembers(Pharmacies pharmacies) async {
    try {
      model.setBusy(true);

      /*TeamMemberJsonRequest jsonRequest = new TeamMemberJsonRequest();
      jsonRequest.carePlanId = startCarePlanResponse.data.carePlan.id.toString();
      jsonRequest.teamMemberType = "Pharmacy";
      jsonRequest.isEmergencyContact = true;*/
      //jsonRequest.details.userId = pharmacies.userId.toString();

      final data = <String, dynamic>{};
      data['UserId'] = pharmacies.userId.toString();
      data['FirstName'] = '';
      data['LastName'] = '';
      data['Prefix'] = '';
      data['PhoneNumber'] = '';
      data['Gender'] = '';

      final map = <String, dynamic>{};
      map['CarePlanId'] = carePlanEnrollmentForPatientGlobe!
          .data!.patientEnrollments!
          .elementAt(0)
          .enrollmentId
          .toString();
      map['IsEmergencyContact'] = true;
      map['TeamMemberType'] = 'Pharmacy';
      map['Details'] = data;

      final AddTeamMemberResponse addTeamMemberResponse =
          await model.addTeamMembers(map);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        getAHACarePlanSummary();
        showToast(addTeamMemberResponse.message!, context);
      } else {
        showToast(addTeamMemberResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
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

      final data = <String, dynamic>{};
      data['FirstName'] = firstName;
      data['LastName'] = lastName;
      data['Prefix'] = ' ';
      data['PhoneNumber'] = phoneNumber;
      data['Gender'] = gender;
      data['Relation'] = relation;

      final map = <String, dynamic>{};
      map['CarePlanId'] = carePlanEnrollmentForPatientGlobe!
          .data!.patientEnrollments!
          .elementAt(0)
          .enrollmentId
          .toString();
      map['IsEmergencyContact'] = true;
      map['TeamMemberType'] = type;
      map['Details'] = data;

      final AddTeamMemberResponse addTeamMemberResponse =
          await model.addTeamMembers(map);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        getAHACarePlanSummary();
        showToast(addTeamMemberResponse.message!, context);
      } else {
        showToast(addTeamMemberResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      //progressDialog.close();
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  _removeConfirmation(Team team) {
    showDialog(
        barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            'Alert!',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
                color: Colors.black),
          ),
          contentPadding: EdgeInsets.all(4.0),
          subtitle: Text(
            'Are you sure you want to remove this team member?',
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 14.0,
                color: Colors.black),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              removeTeamMembers(team.id!);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
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
        getAHACarePlanSummary();
        showToast(addTeamMemberResponse.message!, context);
      } else {
        showToast(addTeamMemberResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      //progressDialog.close();
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }
}
