
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/emergency/models/emergency_contact_response.dart';
import 'package:patient/features/common/emergency/models/health_syetem_hospital_pojo.dart';
import 'package:patient/features/common/emergency/models/health_system_pojo.dart';
import 'package:patient/features/common/emergency/ui/add_doctor_details_dialog.dart';
import 'package:patient/features/common/emergency/ui/add_family_member_dialog.dart';
import 'package:patient/features/common/emergency/ui/add_nurse_dialog.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/dashboard_tile.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/view_models/common_config_model.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactView extends StatefulWidget {
  @override
  _EmergencyContactViewState createState() => _EmergencyContactViewState();
}

class _EmergencyContactViewState extends State<EmergencyContactView> {
  var model = CommonConfigModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  var dateFormat = DateFormat('yyyy-MM-dd');
  DashboardTile? emergencyDashboardTile;
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  var doctorTeam = <Items>[];
  var pharmaTeam = <Items>[];
  var socialWorkerTeam = <Items>[];
  var familyTeam = <Items>[];
  Color widgetBackgroundColor = primaryColor;
  Color widgetBorderColor = primaryColor;
  Color iconColor = Colors.white;
  Color textColor = Colors.white;
  var emergencyDetailsTextControler = TextEditingController();
  var healthSystemList = <String>[];
  var healthSystemHospitalList = <String>[];
  List<HealthSystems>? _healthSystems;
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

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
        _sortTeamMembers(emergencyContactResponse);
      } else {
        showToast(emergencyContactResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
  }

  getHealthSystem() async {
    try {
      healthSystemList.clear();
      final HealthSystemPojo healthSystemPojo =
      await model.getHealthSystem();

      if (healthSystemPojo.status == 'success') {
        _healthSystems = healthSystemPojo.data!.healthSystems;
        for(int i = 0 ; i < healthSystemPojo.data!.healthSystems!.length ; i++ ){
          healthSystemList.add(healthSystemPojo.data!.healthSystems![i].name.toString());
        }
        setState(() {});
      } else {
        showToast(healthSystemPojo.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
  }

  getHealthSystemHospital(String healthSystemId) async {
    try {
      healthSystemHospitalList.clear();
      final HealthSyetemHospitalPojo systemHospitals =
      await model.getHealthSystemHospital(healthSystemId);

      if (systemHospitals.status == 'success') {

        for(int i = 0 ; i < systemHospitals.data!.healthSystemHospitals!.length ; i++ ){
          healthSystemHospitalList.add(systemHospitals.data!.healthSystemHospitals![i].name.toString());
        }
        setState(() {});
      } else {
        showToast(systemHospitals.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
  }

  _sortTeamMembers(EmergencyContactResponse emergencyContactResponse) {
    for (final teamMember
        in emergencyContactResponse.data!.emergencyContacts!.items!) {
      if (teamMember.contactRelation == 'Doctor') {
        doctorTeam.add(teamMember);
      } else if (teamMember.contactRelation == 'Pharmacy user') {
        pharmaTeam.add(teamMember);
      } else if (teamMember.contactRelation == 'HealthWorker') {
        socialWorkerTeam.add(teamMember);
      } else if (teamMember.contactRelation == 'FamilyMember') {
        familyTeam.add(teamMember);
      }

      setState(() {});
    }
  }

  loadSharedPrefs() async {
    try {
      setKnowdledgeLinkLastViewDate(dateFormat.format(DateTime.now()));
      emergencyDashboardTile =
          DashboardTile.fromJson(await _sharedPrefUtils.read('emergency'));
      //debugPrint('Emergency Dashboard Tile ==> ${emergencyDashboardTile.date}');
      setState(() {});
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
    }
    catch (Excepetion) {
      // do something
      emergencyDashboardTile = null;
      debugPrint('error caught : ${Excepetion.toString()}');
      setState(() {

      });
    }
  }

  @override
  void initState() {
    getHealthSystem();
    loadSharedPrefs();
    getEmergencyTeam();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('##########################${RemoteConfigValues.hospitalSystemVisibility}');
    return BaseWidget<CommonConfigModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  emergency(),
                  if(RemoteConfigValues.hospitalSystemVisibility)...[
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                        child: Text(
                          'Health System ',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: InfoScreen(
                            tittle: 'Health System Information',
                            description: "Select your health system details here.",
                            height: 180),
                      ),
                      SizedBox(width: 8,),
                    ],
                  ),
                  healthSystem(),
                  ],
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                        child: Text(
                          'Emergency Contact ',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: InfoScreen(
                            tittle: 'Emergency Contact Information',
                            description: "Add details of your emergency contact here.",
                            height: 180),
                      ),
                      SizedBox(width: 8,),
                    ],
                  ),
                  sectionHeader('Doctors'),
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

  Widget healthSystem(){
    debugPrint('Health System Globe ==> $healthSystemGlobe');
    debugPrint('Health System Hospital Globe ==> $healthSystemHospitalGlobe');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Health System',
            style: TextStyle(
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: primaryColor, width: 0.80),
                      color: Colors.white),
                  child: Semantics(
                    label: 'Select Health System',
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: healthSystemGlobe,
                      items: healthSystemList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text(healthSystemGlobe ?? 'Choose an option'),
                      onChanged: (data) {
                        FirebaseAnalytics.instance.logEvent(name: 'health_system_dropdown_selection', parameters: <String, dynamic>{
                          'health_system': data,
                        },);
                        debugPrint(data);
                        setState(() {
                          healthSystemGlobe = data.toString();
                          healthSystemHospitalGlobe = null;
                        });
                        for(int i = 0 ; i < _healthSystems!.length ; i++ ){
                          if(_healthSystems![i].name.toString() == data){
                           getHealthSystemHospital(_healthSystems![i].id.toString());
                          }
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
          Text(
            'Select Hospital',
            style: TextStyle(
                color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: primaryColor, width: 0.80),
                      color: Colors.white),
                  child: Semantics(
                    label: 'Select Hospital',
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: healthSystemHospitalGlobe,
                      items: healthSystemHospitalList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, maxLines: 2, overflow: TextOverflow.ellipsis,),
                        );
                      }).toList(),
                      hint: Text(healthSystemHospitalGlobe ?? 'Choose an option', maxLines: 2, overflow: TextOverflow.ellipsis,),
                      onChanged: (data) {
                        FirebaseAnalytics.instance.logEvent(name: 'hospital_system_dropdown_selection', parameters: <String, dynamic>{
                          'select_hospital': data,
                        },);
                        debugPrint(data);
                        setState(() {
                          healthSystemHospitalGlobe = data.toString();
                        });
                        setState(() {});
                        updateHospitalSystem();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget emergency() {
    String? discription = '';

    if (emergencyDashboardTile != null) {
      //debugPrint('Emergency ==> ${emergencyDashboardTile.date.difference(DateTime.now()).inDays}');
      if (emergencyDashboardTile!.date!.difference(DateTime.now()).inDays ==
          0) {
        discription = emergencyDashboardTile!.discription;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widgetBackgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: widgetBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  /*ImageIcon(
                    AssetImage('res/images/ic_pharmacy_colored.png'),
                    size: 24,
                    color: iconColor,
                  ),*/
                  Icon(
                    FontAwesomeIcons.kitMedical,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text('Have you been hospitalized?',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat')),
                ],
              ),
            ),
            Container(
              color: primaryLightColor,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){

                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.home, color: Colors.green, size: 40,),
                          SizedBox(height: 6,),
                          Text('No I am good!',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat')),
                        ],
                      ),
                    ),
                  ),*/

                  if (discription != '')
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(discription!,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat')),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.edit,
                                  size: 24,
                                  color: primaryColor,
                                  semanticLabel: 'edit hospitalization details',
                                ),
                                onPressed: () {
                                  FirebaseAnalytics.instance.logEvent(name: 'emergency_edit_button_click');
                                  _emergencyDetailDialog(true);
                                },
                              ),
                              SizedBox(height: 16,),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.delete,
                                  size: 24,
                                  color: primaryColor,
                                  semanticLabel: 'delete hospitalization details',
                                ),
                                onPressed: () {
                                  FirebaseAnalytics.instance.logEvent(name: 'emergency_delete_button_click');
                                  ConfirmationBottomSheet(
                                      context: context,
                                      height: 180,
                                      onPositiveButtonClickListner: () {
                                        deleteMedicalEmergencyEvent();
                                        //debugPrint('Positive Button Click');
                                      },
                                      onNegativeButtonClickListner: () {
                                        //debugPrint('Negative Button Click');
                                      },
                                      question: 'Are you sure you want to delete this record?',
                                      tittle: 'Alert!');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    Semantics(
                      label: 'Yes, I have been hospitalized',
                      button: true,
                      child: ExcludeSemantics(
                        child: InkWell(
                          onTap: () {
                            FirebaseAnalytics.instance.logEvent(name: 'emergency_yes_button_click');
                            _emergencyDetailDialog(false);
                          },
                          child: ExcludeSemantics(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.truckMedical,
                                  color: primaryColor,
                                  size: 36,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Yes',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _emergencyDetailDialog(bool isEdit) async {
    if (isEdit) {
      emergencyDetailsTextControler.text = emergencyDashboardTile!.discription!;
      emergencyDetailsTextControler.selection = TextSelection.fromPosition(
        TextPosition(offset: emergencyDetailsTextControler.text.length),
      );
    }
    showDialog(
        barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter your hospitalization details\n(Date & Reason)',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat')),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Semantics(
                  child: TextField(
                    controller: emergencyDetailsTextControler,
                    autofocus: true,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                        color: Colors.black),
                    decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 16),
                        //labelText: 'Enter your hospitalization details (Date & Reason)',
                        hintText: ''),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                emergencyDetailsTextControler.clear();
              }),
          TextButton(
              child: const Text('Submit'),
              onPressed: () {
                FirebaseAnalytics.instance.logEvent(name: 'emergency_submit_button_click');
                if (emergencyDetailsTextControler.text.trim().isEmpty) {
                  showToastMsg('Please enter hospitalization details', context);
                } else {
                  addMedicalEmergencyEvent(
                      emergencyDetailsTextControler.text.trim());
                  Navigator.of(context, rootNavigator: true).pop();
                  emergencyDetailsTextControler.clear();
                }
              })
        ],
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
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*if (tittle == 'Doctors')
                        InfoScreen(
                            tittle: 'Information',
                            description:
                                'To share your health information with your doctor, you must include their email address in the doctor profile.',
                            height: 208),*/
                      Semantics(
                        label: 'Add ' + tittle + ' details',
                        button: true,
                        child: InkWell(
                          onTap: () {
                            FirebaseAnalytics.instance.logEvent(name: 'emergency_add_${tittle.toLowerCase()}_button_click');
                            //showToast(tittle);
                            if (tittle == 'Doctors') {
                              showDialog(
        barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return _addEmergencyDoctorDialog(context);
                                  });
                            } else if (tittle == 'Pharmacies') {
                            } else if (tittle ==
                                'Nurses / Social Health Workers') {
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
                    ],
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
                color: primaryColor)),
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
    final Items details = doctorTeam.elementAt(index);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: getAppType() == 'AHA' ? primaryColor : primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          semanticContainer: false,
          elevation: 0,
          child: Stack(
            children: [
              InkWell(
                  onTap: () {
                    _removeConfirmation(doctorTeam.elementAt(index));
                  },
                  child: Semantics(
                    label: 'Delete Doctor',
                    button: true,
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
                    ),
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Semantics(
                            label: 'Call Doctor',
                            button: true,
                            child: InkWell(
                              onTap: () async {
                                final String url =
                                    'tel://' + details.contactPerson!.phone!;
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                } else {
                                  showToast('Unable to dial number', context);
                                  debugPrint('Could not launch $url');
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                child: Lottie.asset(
                                  'res/lottiefiles/call.json',
                                  height: 120,
                                ), /*Image(
                                  image: AssetImage(
                                      'res/images/profile_placeholder.png'),
                                ),*/
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: Text(
                                  'Dr. ' +
                                      details.contactPerson!.firstName
                                          .toString() +
                                      ' ' +
                                      details.contactPerson!.lastName
                                          .toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor)),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Semantics(
                              label: "Phone: " +
                                  details.contactPerson!.phone!
                                      .replaceAllMapped(RegExp(r".{1}"),
                                          (match) => "${match.group(0)} "),
                              child: ExcludeSemantics(
                                child: Text(details.contactPerson!.phone!,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        color: primaryColor)),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            /*if (details.contactPerson!.email != null)
                              Semantics(
                                label:
                                    "Email: " + details.contactPerson!.email!,
                                child: ExcludeSemantics(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 250,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            *//*Text(
                                                'Email:  ',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w300,
                                                    color: primaryColor)),*//*
                                            Expanded(
                                              child: Text(
                                                  details.contactPerson!.email!,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: textBlack)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),*/
                            Text("Doctor",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                    color: textBlack)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*sendMail(String email) async{

    final link = 'mailto:' +
        email +
        '?subject=Emergency';
    if (await canLaunchUrl(
    link.toString())) {
    await launch(link.toString());
    } else {
    final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
    'subject':
    appName.replaceAll(
    '%20', ' ') +
    ' app query',
    'body': ''
    '' +
    name +
    ' wants to get in touch with you. ---- '
    'Contact Number:' +
    userPhone +
    ''
    '',
    });
    await launch(_emailLaunchUri
        .toString()
        .replaceAll('+', '%20'));

    debugPrint(
    'Could not launch ${link.toString()}');
    throw 'Could not launch ${link.toString()}';
    }
  }*/

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
          border: Border.all(
              color: getAppType() == 'AHA' ? primaryColor : primaryLightColor),
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
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor)),
                          ),
                          Text('Vijayawada, Andhra Pradesh',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: textBlack)),
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
                color: primaryColor)),
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
    final Items details = socialWorkerTeam.elementAt(index);
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color:
                    getAppType() == 'AHA' ? primaryColor : primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            semanticContainer: false,
            elevation: 0,
            child: Stack(
              children: [
                InkWell(
                    onTap: () {
                      _removeConfirmation(socialWorkerTeam.elementAt(index));
                    },
                    child: Semantics(
                      label: 'Delete Nurse',
                      button: true,
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
                      ),
                    )),
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
                              child: Semantics(
                                label: 'Call Nurse',
                                button: true,
                                child: InkWell(
                                  onTap: () async {
                                    final String url = 'tel://' +
                                        details.contactPerson!.phone!;
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      showToast(
                                          'Unable to dial number', context);
                                      debugPrint('Could not launch $url');
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    child: Lottie.asset(
                                      'res/lottiefiles/call.json',
                                      height: 120,
                                    ), /*Image(
                                    image: AssetImage(
                                        'res/images/profile_placeholder.png'),
                                  ),*/
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: Text(
                                      details.contactPerson!.firstName
                                              .toString() +
                                          ' ' +
                                          details.contactPerson!.lastName
                                              .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor)),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Semantics(
                                  label: "Phone: " +
                                      details.contactPerson!.phone!
                                          .replaceAllMapped(RegExp(r".{1}"),
                                              (match) => "${match.group(0)} "),
                                  child: ExcludeSemantics(
                                    child: Text(details.contactPerson!.phone!,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300,
                                            color: primaryColor)),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  details.contactRelation!,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w200,
                                      color: textBlack),
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
        child: Text('No family member / friend found',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: primaryColor)),
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
    final Items details = familyTeam.elementAt(index);
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color:
                    getAppType() == 'AHA' ? primaryColor : primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            semanticContainer: false,
            elevation: 0,
            child: Stack(
              children: [
                InkWell(
                    onTap: () {
                      _removeConfirmation(familyTeam.elementAt(index));
                    },
                    child: Semantics(
                      label: 'Delete Family Members',
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
                      ),
                    )),
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
                              child: Semantics(
                                label: 'Call Family Member',
                                button: true,
                                child: InkWell(
                                  onTap: () async {
                                    final String url = 'tel://' +
                                        details.contactPerson!.phone!;
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      showToast(
                                          'Unable to dial number', context);
                                      debugPrint('Could not launch $url');
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    child: Lottie.asset(
                                      'res/lottiefiles/call.json',
                                      height: 120,
                                    ), /*Image(
                                    image: AssetImage(
                                        'res/images/profile_placeholder.png'),
                                  ),*/
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: Text(
                                      details.contactPerson!.firstName
                                              .toString() +
                                          ' ' +
                                          details.contactPerson!.lastName
                                              .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor)),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Semantics(
                                  label: "Phone: " +
                                      details.contactPerson!.phone!
                                          .replaceAllMapped(RegExp(r".{1}"),
                                              (match) => "${match.group(0)} "),
                                  child: ExcludeSemantics(
                                    child: Text(details.contactPerson!.phone!,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300,
                                            color: primaryColor)),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  details.contactRelation!,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w200,
                                      color: textBlack),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addEmergencyDoctorDialog(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: double.infinity,
          height: 460,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Doctor',
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
                child: AddDoctorDetailsDialog(submitButtonListner:
                    (String firstName, String lastName, String email,
                        String phoneNumber, String gender) {
                  debugPrint('Team Member ==> $firstName');
                  FirebaseAnalytics.instance.logEvent(name: 'emergency_doctor_save_button_click');
                  addTeamMembers(
                      firstName, lastName, phoneNumber, gender, '', 'Doctor',
                      email: email);
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
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: double.infinity,
          height: 580,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
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
                  FirebaseAnalytics.instance.logEvent(name: 'emergency_nurse_save_button_click');
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
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        //child: addOrEditAllergiesDialog(context),
        child: Container(
          width: double.infinity,
          height: 660,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Add Family Member \n/ Friend',
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
                      FirebaseAnalytics.instance.logEvent(name: 'emergency_family_member_save_button_click');
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
      String gender, String relation, String type,
      {String? email}) async {
    try {
      model.setBusy(true);
      //progressDialog.show(max: 100, msg: 'Loading...' );progressDialog.show(max: 100, msg: 'Loading...' );

      /*TeamMemberJsonRequest jsonRequest = new TeamMemberJsonRequest();
      jsonRequest.carePlanId = startCarePlanResponse.data.carePlan.id.toString();
      jsonRequest.teamMemberType = "Pharmacy";
      jsonRequest.isEmergencyContact = true;*/
      //jsonRequest.details.userId = pharmacies.userId.toString();

      final contactPerson = <String, dynamic>{};
      contactPerson['FirstName'] = firstName;
      contactPerson['LastName'] = lastName;
      if (email != null && email.isNotEmpty) {
        contactPerson['Email'] = email;
      }
      contactPerson['Prefix'] = ' ';
      contactPerson['Phone'] = phoneNumber;

      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['ContactRelation'] = type;
      map['ContactPerson'] = contactPerson;
      map['IsAvailableForEmergency'] = true;
      //map['Email'] = email;

      final BaseResponse addTeamMemberResponse =
          await model.addTeamMembers(map);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        getEmergencyTeam();
        showSuccessToast(addTeamMemberResponse.message!, context);
      } else {
        showToast(addTeamMemberResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }

  _removeConfirmation(Items contact) {
    /*showDialog(
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
            '\nAre you sure you want to remove this contact?',
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
              removeTeamMembers(contact.id!);
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
    );*/
    ConfirmationBottomSheet(
        context: context,
        height: 180,
        onPositiveButtonClickListner: () {
          //debugPrint('Positive Button Click');
          removeTeamMembers(contact.id!);
        },
        onNegativeButtonClickListner: () {
          //debugPrint('Negative Button Click');
        },
        question: 'Are you sure you want to remove this contact?',
        tittle: 'Alert!');
  }

  removeTeamMembers(String emergencyContactId) async {
    try {
      model.setBusy(true);
      final BaseResponse addTeamMemberResponse =
          await model.removeTeamMembers(emergencyContactId);
      debugPrint('Team Member Response ==> ${addTeamMemberResponse.toJson()}');
      if (addTeamMemberResponse.status == 'success') {
        getEmergencyTeam();
        showSuccessToast(addTeamMemberResponse.message!, context);
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

  deleteMedicalEmergencyEvent() async {
    try {
        _sharedPrefUtils.remove('emergency');
        showSuccessToast('Hospitalization details record deleted successfully!', context);
        loadSharedPrefs();
    } catch (CustomException) {
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  addMedicalEmergencyEvent(String emergencyBreif) async {
    try {
      final map = <String, String?>{};
      map['PatientUserId'] = patientUserId;
      map['Details'] = emergencyBreif;
      map['EmergencyDate'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse =
          await model.addMedicalEmergencyEvent(map);
      debugPrint('Base Response ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        _sharedPrefUtils.save(
            'emergency',
            DashboardTile(DateTime.now(), 'emergency', emergencyBreif)
                .toJson());
        showSuccessToast('Hospitalization details saved successfully!', context);
        loadSharedPrefs();
        setState(() {});
      } else {
        //showToast(knowledgeTopicResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  updateHospitalSystem() async {

    final map = <String, dynamic>{};
    map['HealthSystem'] = healthSystemGlobe;
    map['AssociatedHospital'] = healthSystemHospitalGlobe;

    try {
      final BaseResponse updateProfileSuccess = await model
          .updateProfilePatient(map);

      if (updateProfileSuccess.status == 'success') {
        showSuccessToast('Patient Health System details updated successfully!', context);


        getPatientDetails();
        //Navigator.pushNamed(context, RoutePaths.Home);
      } else {
        showToast(updateProfileSuccess.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint("3");
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
  }

  getPatientDetails() async {
    try {
      /*//ApiProvider apiProvider = new ApiProvider();

      ApiProvider apiProvider = GetIt.instance<ApiProvider>();*/

      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth!;

      final response =
      await apiProvider!.get('/patients/' + patientUserId!, header: map);

      final PatientApiDetails doctorListApiResponse =
      PatientApiDetails.fromJson(response);

      if (doctorListApiResponse.status == 'success') {
        debugPrint(doctorListApiResponse.data!.patient!.user!.person!
            .toJson()
            .toString());
        await _sharedPrefUtils.save(
            'patientDetails', doctorListApiResponse.data!.patient!.toJson());
      } else {
        showToast(doctorListApiResponse.message!, context);
        model.setBusy(false);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

}
