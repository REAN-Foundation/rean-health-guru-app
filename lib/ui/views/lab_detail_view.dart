import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/labsListApiResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/shared/text_styles.dart';
import 'package:paitent/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:paitent/ui/views/labTileWidget.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'base_widget.dart';

class LabDetailsView extends StatefulWidget {
  Labs labdetails;

  LabDetailsView(@required this.labdetails);

  @override
  _LabDetailsViewState createState() => _LabDetailsViewState(labdetails);
}

class _LabDetailsViewState extends State<LabDetailsView> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  SharedPrefUtils _sharedPrefUtils = new SharedPrefUtils();
  String name = "";
  List<Address> addresses;
  Address first;
  int _currentNav = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _searchController = new TextEditingController();
  Labs labDetails;

  _LabDetailsViewState(@required this.labDetails);

  loadSharedPrefs() async {
    try {
      UserData user = UserData.fromJson(await _sharedPrefUtils.read("user"));
      //debugPrint(user.toJson().toString());
      setState(() {
        name = user.data.user.firstName;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      debugPrint(
          'Latitude = ${currentLocation.latitude} Longitude = ${currentLocation.longitude}');
      findOutCityFromGeoCord(
          currentLocation.latitude, currentLocation.longitude);
    });
  }

  void findOutCityFromGeoCord(double lat, double long) async {
    final coordinates = new Coordinates(lat, long);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    debugPrint("${first.featureName} : ${first.locality}");
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<AppoinmentViewModel>(
      model: AppoinmentViewModel(),
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              title: Text(
                'Lab Profile',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w700),
              ),
              iconTheme: new IconThemeData(color: Colors.black),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 16,
                          ),
                          LabTileView(labDetails),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "About",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16, color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(labDetails.aboutUs,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0XFF303030))),
                          SizedBox(
                            height: 16,
                          ),

                          /* Text("Highlights", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                  SizedBox(height: 4,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          //child: Container(color: Colors.white,),),
                            child: Icon(
                              Icons.star,
                              color: Color(0XFF909CAC),
                              size: 16,
                            ),
                            flex: 1),
                        //SizedBox(width: 8.0,),
                        Expanded(
                          flex: 10,
                          child: Text('15 Years Experience Overall', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Color(0XFF303030)), textAlign: TextAlign.left,),
                        )
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          //child: Container(color: Colors.white,),),
                            child: Icon(
                              Icons.star,
                              color: Color(0XFF909CAC),
                              size: 16,
                            ),
                            flex: 1),
                        //SizedBox(width: 8.0,),
                        Expanded(
                          flex: 10,
                          child: Text('Male Fertility Specialist', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Color(0XFF303030)), textAlign: TextAlign.left,),
                        )
                      ]),
                  SizedBox(height: 16,),*/

                          Text(
                            "Address",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16, color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(labDetails.address,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0XFF303030))),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Contact No.",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16, color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          AutolinkText(
                              text:'+91 '+labDetails.phoneNumber,
                              textStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w200,
                                  color: textBlack),
                              linkStyle: TextStyle(color: Colors.blue),
                              onPhoneTap: (link) async {
                                String url = 'tel://'+link;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Working Hours",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16, color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          for (int i = 0;
                              i <
                                  labDetails.appointmentRelatedDetails
                                      .workingHours.length;
                              i++) ...[
                            /*Text(doctorDetails.appointmentRelatedDetails.workingHours.elementAt(i),
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                        color: textBlack, fontFamily: 'Montserrat')), */

                            RichText(
                              text: TextSpan(
                                text: labDetails
                                    .appointmentRelatedDetails.workingHours
                                    .elementAt(i)
                                    .substring(0, 3).toUpperCase()+" : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: textBlack,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat'),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: labDetails.appointmentRelatedDetails
                                          .workingHours
                                          .elementAt(i)
                                          .substring(
                                              3,
                                              labDetails
                                                  .appointmentRelatedDetails
                                                  .workingHours
                                                  .elementAt(i)
                                                  .length),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: textBlack,
                                          fontSize: 14,
                                          fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                _continueButton(),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _continueButton() {
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
            child: new Text('Book A Visit',
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              Navigator.pushNamed(
                  context, RoutePaths.Select_Date_And_Time_Lab_Book_Appoinment,
                  arguments: labDetails);
              debugPrint("Clicked On Proceed");
            },
          ),
        ),
      ],
    );
  }
}
//right_arrow