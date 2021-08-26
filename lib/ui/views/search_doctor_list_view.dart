import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/DoctorDetailsResponse.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/shared/text_styles.dart';
import 'package:paitent/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/widgets/app_drawer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'base_widget.dart';

class SearchDoctorListView extends StatefulWidget {
  @override
  _SearchDoctorListViewState createState() => _SearchDoctorListViewState();
}

class _SearchDoctorListViewState extends State<SearchDoctorListView> {
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
  var model = new BookAppoinmentViewModel();
  String auth = "";
  var doctorSearchList = new List<Doctors>();
  ProgressDialog progressDialog;

  loadSharedPrefs() async {
    try {
      UserData user = UserData.fromJson(await _sharedPrefUtils.read("user"));
      //debugPrint(user.toJson().toString());
      auth = user.data.accessToken;
      getDoctorList();
      setState(() {
        name = user.data.user.firstName;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  getDoctorList() async {
    try {
      DoctorListApiResponse doctorListApiResponse =
          await model.getDoctorList('Bearer ' + auth);

      if (doctorListApiResponse.status == 'success') {
        if (doctorListApiResponse.data.doctors.length != 0) {
          doctorSearchList.clear();
          doctorSearchList.addAll(doctorListApiResponse.data.doctors);
        }else{
          doctorSearchList.clear();
        }
      } else {
        showToast(doctorListApiResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint(CustomException.toString());
    }
  }

  getDoctorListByName(String name) async {
    try {
      DoctorListApiResponse doctorListApiResponse =
      await model.getDoctorListByLocality(name, 'Bearer ' + auth);

      if (doctorListApiResponse.status == 'success') {
        if (doctorListApiResponse.data.doctors.length != 0) {
          doctorSearchList.clear();
          doctorSearchList.addAll(doctorListApiResponse.data.doctors);
        }else{
          doctorSearchList.clear();
        }
      } else {
        showToast(doctorListApiResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint(CustomException.toString());
    }
  }

  getDoctorDetails(String doctorUserId) async {
    try {
      progressDialog.show();
      DoctorDetailsResponse doctorDetailsResponse =
      await model.getDoctorDetails('Bearer ' + auth, doctorUserId);

      if (doctorDetailsResponse.status == 'success') {
        progressDialog.hide();
        Navigator.pushNamed(context, RoutePaths.Doctor_Details_View,
            arguments: doctorDetailsResponse.data.doctor);
      } else {
        progressDialog.hide();
        showToast(doctorDetailsResponse.message);
      }
    } catch (CustomException) {
      progressDialog.hide();
      showToast(CustomException.toString());
      debugPrint(CustomException.toString());
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
    debugPrint("${first.adminArea} : ${first.locality}");
  }

  @override
  void initState() {

    model.setBusy(true);
    loadSharedPrefs();
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog  = new ProgressDialog(context);
    return BaseWidget<BookAppoinmentViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Doctors List',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: new IconThemeData(color: Colors.black),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
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
                            onChanged: (text) {
                              getDoctorListByName(text);
                            },
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 0),
                                hintText:
                                    "Search doctor by name")),
                      ),
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        height: 40.0,
                        width: 40.0,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              _searchController.clear();
                              getDoctorList();
                            },
                            child: Icon(
                              _searchController.text.length == 0 ? Icons.search : Icons.clear,
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
                ),
                Text(
                  "Near By",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      fontFamily: 'Montserrat'),
                ),
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
                      : (doctorSearchList.length == 0
                          ? noDoctorFound()
                          : doctorSearchResultListView()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noDoctorFound() {
    return Center(
      child: Text("No doctor found in your locality",
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
        itemCount: doctorSearchList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget _makeDoctorListCard(BuildContext context, int index) {
    Doctors doctorDetails = doctorSearchList.elementAt(index);
    debugPrint(doctorDetails.specialities);
    return MergeSemantics(
      child: Container(
        height: 100,
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor, width: 1),
            borderRadius: new BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: ExcludeSemantics(
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
                                    fontWeight: FontWeight.w700,
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
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 60,
                  ),
                  ExcludeSemantics(
                    child: RichText(
                      text: TextSpan(
                        text: 'Consultation Fee :',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Montserrat'),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' ₹' + doctorDetails.consultationFee.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontFamily: 'Montserrat')),
                        ],
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Book_'+doctorDetails.firstName+' ',
                    child: RaisedButton(
                        child: Text(
                          'Book Now',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700),
                        ),
                        color: primaryColor,
                        onPressed: (){
                          getDoctorDetails(doctorDetails.userId);
                        },
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0))
                    )/*InkWell(
                      onTap: () {
                        *//*Navigator.pushNamed(context, RoutePaths.Doctor_Details_View,
                            arguments: doctorDetails);*//*
                        getDoctorDetails(doctorDetails.userId);
                      },
                      child: ExcludeSemantics(
                        child: Container(
                          height: 56,
                          width: 120,
                          decoration: new BoxDecoration(
                              color: primaryColor,
                              border: Border.all(color: primaryColor),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              )),
                          child: Center(
                              child: Text(
                            'Book Now',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700),
                          )),
                        ),
                      ),
                    )*/,
                  ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
//right_arrow
