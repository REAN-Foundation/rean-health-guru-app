import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/appointment_booking/ui/doctor_tile_widget.dart';
import 'package:patient/features/common/appointment_booking/view_models/appointment_view_model.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';

//ignore: must_be_immutable
class DoctorDetailsView extends StatefulWidget {
  Doctors? doctorDetails;

  DoctorDetailsView(doctorDetails) {
    this.doctorDetails = doctorDetails;
  }

  @override
  _DoctorDetailsViewState createState() =>
      _DoctorDetailsViewState(doctorDetails);
}

class _DoctorDetailsViewState extends State<DoctorDetailsView> {
  /*Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  List<Address> addresses;
  Address first;*/
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String? name = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Doctors? doctorDetails;

  _DoctorDetailsViewState(this.doctorDetails);

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      //debugPrint(user.toJson().toString());
      setState(() {
        name = user.data!.user!.person!.firstName;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }
  }

  void getLocation() {
    /*_serviceEnabled = await location.serviceEnabled();
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
    });*/
  }

  void findOutCityFromGeoCord(double lat, double long) {
    /*final coordinates = new Coordinates(lat, long);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    debugPrint("${first.featureName} : ${first.locality}");*/
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final highlights = doctorDetails!.professionalHighlights != null
        ? doctorDetails!.professionalHighlights!.split('*')
        : <String>[];

    return BaseWidget<AppoinmentViewModel?>(
      model: AppoinmentViewModel(),
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
              title: Text(
                'Doctors Profile',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat'),
              ),
              iconTheme: IconThemeData(color: Colors.black),
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
                            'About',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(doctorDetails!.aboutMe!,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w200,
                                  color: textBlack,
                                  fontFamily: 'Montserrat')),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Highlights',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          for (int i = 1; i < highlights.length; i++) ...[
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
                                          color: textBlack,
                                          fontFamily: 'Montserrat'),
                                      textAlign: TextAlign.left,
                                    ),
                                  )
                                ]),
                          ],
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Address',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(doctorDetails!.address!,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w200,
                                  color: textBlack,
                                  fontFamily: 'Montserrat')),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Contact No.',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          /*AutolinkText(
                              text: '+91 ' + doctorDetails.phoneNumber,
                              textStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w200,
                                  color: textBlack),
                              linkStyle: TextStyle(color: Colors.blue),
                              onPhoneTap: (link) async {
                                final String url = 'tel://' + link;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),*/
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Working Hours',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                color: primaryColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          for (int i = 0;
                              i <
                                  doctorDetails!.appointmentRelatedDetails!
                                      .workingHours!.length;
                              i++) ...[
                            /*Text(doctorDetails.appointmentRelatedDetails.workingHours.elementAt(i),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                    color: textBlack, fontFamily: 'Montserrat')), */

                            RichText(
                              text: TextSpan(
                                text: doctorDetails!.appointmentRelatedDetails!
                                        .workingHours!
                                        .elementAt(i)
                                        .substring(0, 3)
                                        .toUpperCase() +
                                    ' : ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: textBlack,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat'),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: doctorDetails!
                                          .appointmentRelatedDetails!
                                          .workingHours!
                                          .elementAt(i)
                                          .substring(
                                              3,
                                              doctorDetails!
                                                  .appointmentRelatedDetails!
                                                  .workingHours!
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
            child: Text('Book A Visit',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              Navigator.pushNamed(
                  context, RoutePaths.Select_Date_And_Time_Book_Appoinment,
                  arguments: doctorDetails);
              debugPrint('Clicked On Proceed');
            },
          ),
        ),
      ],
    );
  }
}
//right_arrow
