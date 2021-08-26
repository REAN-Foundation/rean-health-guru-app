import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/labsListApiResponse.dart';
import 'package:paitent/core/models/pharmacyListApiResponse.dart';
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
import 'package:provider/provider.dart';

import 'base_widget.dart';

class SearchPharmacyListView extends StatefulWidget {
  @override
  _SearchPharmacyListViewState createState() => _SearchPharmacyListViewState();
}

class _SearchPharmacyListViewState extends State<SearchPharmacyListView> {
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
  String auth = "";
  var model = new BookAppoinmentViewModel();
  var parmacySearchList = new List<Pharmacies>();

  loadSharedPrefs() async {
    try {
      UserData user = UserData.fromJson(await _sharedPrefUtils.read("user"));
      //debugPrint(user.toJson().toString());
      auth = user.data.accessToken;
      getLabListByLocality();
      setState(() {
        name = user.data.user.firstName;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  getLabListByLocality() async {
    try {
      PharmacyListApiResponse listApiResponse = await model.getPhrmacyListByLocality("18.526301","73.834522", 'Bearer '+auth);

      if (listApiResponse.status == 'success') {
        if(listApiResponse.data.pharmacies.length != 0){
          parmacySearchList.addAll(listApiResponse.data.pharmacies);
        }
      } else {
        showToast(listApiResponse.message);
      }

    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint(CustomException.toString());
    }
  }

  void getLocation() async{
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
      debugPrint('Latitude = ${currentLocation.latitude} Longitude = ${currentLocation.longitude}');
      findOutCityFromGeoCord(currentLocation.latitude, currentLocation.longitude);
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
    model.setBusy(true);
    loadSharedPrefs();
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BaseWidget<BookAppoinmentViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          /*appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              title: Text('Lab List',
                    style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),),
              iconTheme: new IconThemeData(color: Colors.black),

            ),
          ),*/


          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(
                  height: 40,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0XFFA6ABB3)),
                      borderRadius: new BorderRadius.all(Radius.circular(8.0))
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                         child: TextFormField(
                              controller: _searchController,
                              maxLines: 1,
                              enabled: true,
                              textInputAction: TextInputAction.done,
                             decoration: new InputDecoration(
                                 border: InputBorder.none,
                                 focusedBorder: InputBorder.none,
                                 enabledBorder: InputBorder.none,
                                 errorBorder: InputBorder.none,
                                 disabledBorder: InputBorder.none,
                                 contentPadding:
                                 EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                 hintText: "Search Pharmacy")
                         ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        height: 40.0,
                        width: 40.0,
                        child: Center(
                          child:InkWell(
                            onTap: (){

                            },
                            child: Icon(
                                Icons.search,
                                color: Color(0xff909CAC),
                                size: 32.0,
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16,),
                Text("Near By", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                SizedBox(height: 16,),
                 Expanded(
                   child: model.busy ? Center(child: SizedBox( height : 32, width: 32 ,child: CircularProgressIndicator())) : (parmacySearchList.length == 0 ? noPharmacyFound() : phamacySearchResultListView()),
                 ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noPharmacyFound(){
    return Center(
      child: Text("No Pharmacy found in your Locality", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14,fontFamily: 'Montserrat', color: primaryLightColor)),
    );
  }

  Widget phamacySearchResultListView(){
    return ListView.separated(
        itemBuilder: (context, index) =>
            _makePharmacyListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        itemCount: parmacySearchList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget _makePharmacyListCard(BuildContext context, int index) {
    Pharmacies pharmaciesDetails = parmacySearchList.elementAt(index);
    return Container(
      height: 100,
      decoration: new BoxDecoration(
          color: Color(0XFFF5F8FA),
          border: Border.all(color: Color(0XFFF5F8FA)),
          borderRadius: new BorderRadius.all(Radius.circular(8.0))
      ),
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
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Container(
                          height: 56,
                          width: 56,
                          child:  Center(
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: Image(
                                image: AssetImage('res/images/profile_placeholder.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      flex: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(pharmaciesDetails.firstName+' '+pharmaciesDetails.lastName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(pharmaciesDetails.address, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Color(0XFF909CAC))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap:(){

                    },
                  child: Container(
                    height: 48,
                    width: 60,
                    decoration: new BoxDecoration(
                        color: Color(0XFF00CFB4),
                        border: Border.all(color: Color(0XFF00CFB4)),
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        )
                    ),
                    child: Center(child: Text('Go', style: TextStyle(color: Colors.white),)),
                  ),
                ),

                ],
              ),
            )

          ],
        ),
    );
  }

}
//right_arrow