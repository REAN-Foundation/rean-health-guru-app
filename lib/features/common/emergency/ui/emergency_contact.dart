import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/emergency/models/emergency_contact_response.dart';
import 'package:patient/features/common/emergency/ui/add_doctor_details_dialog.dart';
import 'package:patient/features/common/emergency/ui/add_family_member_dialog.dart';
import 'package:patient/features/common/emergency/ui/add_nurse_dialog.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/dashboard_tile.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/view_models/common_config_model.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
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
    /*catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }*/
  }

  @override
  void initState() {
    loadSharedPrefs();
    getEmergencyTeam();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<CommonConfigModel?>(
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
                  emergency(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Emergency Contact ',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
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
                    FontAwesomeIcons.firstAid,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text('Have you been hospitalised?',
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
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 24,
                              color: primaryColor,
                              semanticLabel: 'edit emergency text',
                            ),
                            onPressed: () {
                              _emergencyDetailDialog(true);
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    Semantics(
                      label: 'Yes, I had an emergency',
                      button: true,
                      child: ExcludeSemantics(
                        child: InkWell(
                          onTap: () {
                            _emergencyDetailDialog(false);
                          },
                          child: ExcludeSemantics(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.ambulance,
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
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          width: MediaQuery.of(context).size.width,
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
                  labelText: 'Enter emergency details',
                  hintText: ''),
            ),
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
                if (emergencyDetailsTextControler.text.trim().isEmpty) {
                  showToastMsg('Please enter emergency details', context);
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
                      if (tittle == 'Doctors')
                        InfoScreen(
                            tittle: 'Information',
                            description:
                                'To share your health information with your doctor, you must include their email address in the doctor profile.',
                            height: 208),
                      Semantics(
                        label: 'Add ' + tittle + ' details',
                        button: true,
                        child: InkWell(
                          onTap: () {
                            //showToast(tittle);
                            if (tittle == 'Doctors') {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return _addEmergencyDoctorDialog(context);
                                  });
                            } else if (tittle == 'Pharmacies') {
                            } else if (tittle ==
                                'Nurses / Social Health Workers') {
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
                                if (await canLaunch(url)) {
                                  await launch(url);
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
                            if (details.contactPerson!.email != null)
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
                                            /*Text(
                                                'Email:  ',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w300,
                                                    color: primaryColor)),*/
                                            Expanded(
                                              child: Text(
                                                  details.contactPerson!.email!,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: textGrey)),
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
                              ),
                            Text("Doctor",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                    color: textGrey)),
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
    if (await canLaunch(
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
                                  color: textGrey)),
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
                                    if (await canLaunch(url)) {
                                      await launch(url);
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
                                      color: textGrey),
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
                                    if (await canLaunch(url)) {
                                      await launch(url);
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
                                      color: textGrey),
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
          height: 600,
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
        showToast(addTeamMemberResponse.message!, context);
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
    showDialog(
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
        showToast('Emergency details saved successfully!', context);
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

}
