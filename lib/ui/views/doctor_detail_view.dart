import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/shared/text_styles.dart';
import 'package:paitent/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'base_widget.dart';
import 'doctorTileWidget.dart';

class DoctorDetailsView extends StatefulWidget {

  Doctors doctorDetails;

  DoctorDetailsView(@required this.doctorDetails);

  @override
  _DoctorDetailsViewState createState() => _DoctorDetailsViewState(doctorDetails);
}

class _DoctorDetailsViewState extends State<DoctorDetailsView> {
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
  Doctors doctorDetails;

  _DoctorDetailsViewState(@required this.doctorDetails);

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

    var highlights = doctorDetails.professionalHighlights != null ? doctorDetails.professionalHighlights.split('*') : new List<String>();



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
                'Doctors Profile',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,  fontFamily: 'Montserrat'),
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
                          DoctorTileView(doctorDetails),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "About",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Montserrat', color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                              doctorDetails.aboutMe,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w200,
                                  color: textBlack, fontFamily: 'Montserrat')),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Highlights",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Montserrat', color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),

                          for (int i = 1; i < highlights.length; i++)...[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    //child: Container(color: Colors.white,),),
                                      child: Icon(
                                        Icons.star,
                                        color: color909CAC,
                                        size: 16,
                                      ),
                                      flex: 1),
                                  //SizedBox(width: 8.0,),
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      highlights.elementAt(i).trimLeft(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w200,
                                          color: textBlack, fontFamily: 'Montserrat'),
                                      textAlign: TextAlign.left,
                                    ),
                                  )
                                ]),
                          ],
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Address",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Montserrat', color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                              doctorDetails.address,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w200,
                                  color: textBlack, fontFamily: 'Montserrat')),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Contact No.",
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Montserrat', color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          AutolinkText(
                              text:'+91 '+doctorDetails.phoneNumber,
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
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Montserrat', color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          for(int i = 0 ; i < doctorDetails.appointmentRelatedDetails.workingHours.length; i++)...[
                            /*Text(doctorDetails.appointmentRelatedDetails.workingHours.elementAt(i),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                    color: textBlack, fontFamily: 'Montserrat')), */

                            RichText(
                              text: TextSpan(
                                text: doctorDetails.appointmentRelatedDetails.workingHours.elementAt(i).substring(0,3).toUpperCase()+' : ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: textBlack,
                                    fontSize: 14,  fontFamily: 'Montserrat'),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: doctorDetails.appointmentRelatedDetails.workingHours.elementAt(i).substring(3,doctorDetails.appointmentRelatedDetails.workingHours.elementAt(i).length),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: textBlack,
                                          fontSize: 14, fontFamily: 'Montserrat')),
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
  Widget _continueButton(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Material(  //Wrap with Material
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(24.0) ),
          elevation: 4.0,
          color: primaryColor,
          clipBehavior: Clip.antiAlias, // Add This
          child: MaterialButton(
            minWidth: 200,
            child: new Text('Book A Visit',
                style: new TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.normal)),
            onPressed: () {
              Navigator.pushNamed(context, RoutePaths.Select_Date_And_Time_Book_Appoinment, arguments: doctorDetails);
              debugPrint("Clicked On Proceed");
            },
          ),
        ),
      ],
    );
  }
}
//right_arrow