import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/appointment_booking/models/pharmacy_list_api_response.dart';
import 'package:patient/features/common/careplan/models/add_team_member_response.dart';
import 'package:patient/features/common/careplan/models/start_careplan_response.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/common/emergency/ui/add_pharma_dialog.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';

class SetUpPharmacyForCarePlanView extends StatefulWidget {
  @override
  _SetUpPharmacyForCarePlanViewState createState() =>
      _SetUpPharmacyForCarePlanViewState();
}

class _SetUpPharmacyForCarePlanViewState
    extends State<SetUpPharmacyForCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  late StartCarePlanResponse startCarePlanResponse;

  //var parmacySearchList = new List<Pharmacies>();

  loadSharedPrefrance() async {
    try {
      startCarePlanResponse = StartCarePlanResponse.fromJson(
          await _sharedPrefUtils.read('CarePlan'));
      debugPrint(
          'AHA Care Plan id ${startCarePlanResponse.data!.carePlan!.id.toString()}');
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }
  }

  @override
  void initState() {
    loadSharedPrefrance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*if(parmacySearchListGlobe.length != 0){
      parmacySearchListGlobe.addAll(parmacySearchListGlobe);
    }*/
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
                      /* Container(
                        height: 40,
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: primaryColor, width: 2),
                            borderRadius: new BorderRadius.all(
                              Radius.circular(8.0),
                            )),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                  controller: _searchController,
                                  maxLines: 1,
                                  enabled: true,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 14),
                                  textInputAction: TextInputAction.done,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 0),
                                      hintText:
                                          "Search Pharmacies")),
                            ),
                            Container(
                              padding: const EdgeInsets.all(0.0),
                              height: 40.0,
                              width: 40.0,
                              child: Center(
                                child: InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.search,
                                    color: primaryColor,
                                    size: 32.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),*/
                      Expanded(
                          child:
                          /*model!.busy
                          ? Center(
                          child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator()))
                          :*/
                              (parmacySearchListGlobe.isEmpty)
                                  ? noDoctorFound()
                                  : doctorSearchResultListView()) //,
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (model!.busy)
                    Container()
                  else
                    InkWell(
                      onTap: () {
                        /*parmacySearchListGlobe.clear();
                      parmacySearchListGlobe.addAll(parmacySearchListGlobe);*/
                        Navigator.pushNamed(
                            context, RoutePaths.Setup_Nurse_For_Care_Plan);
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
        barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return _addFamilyMemberDialog(context);
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
          'Add Pharmacies',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget noDoctorFound() {
    return Center(
      child: Text('No pharmacy added',
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
        itemCount: parmacySearchListGlobe.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget _makeDoctorListCard(BuildContext context, int index) {
    final Pharmacies pharmaciesDetails =
        parmacySearchListGlobe.elementAt(index);
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(children: <Widget>[
          Container(
            height: 80,
            decoration: BoxDecoration(
                color: Color(0XFFF5F8FA),
                border: Border.all(color: Color(0XFFF5F8FA)),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 60,
                            width: 60,
                            child: Center(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: Image(
                                  image: AssetImage(
                                      'res/images/profile_placeholder.png'),
                                ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  pharmaciesDetails.firstName! +
                                      ' ' +
                                      pharmaciesDetails.lastName!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor)),
                              Text(
                                pharmaciesDetails.address!,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0XFF909CAC)),
                                maxLines: 2,
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
                      addTeamMembers(pharmacies);
                  debugPrint('Call back Received ==> ${pharmacies.firstName}');
                  Navigator.of(context, rootNavigator: true).pop();
                }),
              )
            ],
          ),
        ));
  }

  addTeamMembers(Pharmacies pharmacies) async {
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
      map['CarePlanId'] = startCarePlanResponse.data!.carePlan!.id.toString();
      map['IsEmergencyContact'] = true;
      map['TeamMemberType'] = 'Pharmacy';
      map['Details'] = data;

      final AddTeamMemberResponse addTeamMemberResponse =
          await model.addTeamMembers(map);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        setState(() {
          parmacySearchListGlobe.add(pharmacies);
        });
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
}
