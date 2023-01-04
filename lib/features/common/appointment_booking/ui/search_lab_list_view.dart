import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/appointment_booking/models/lab_details_response.dart';
import 'package:patient/features/common/appointment_booking/models/labs_list_api_response.dart';
import 'package:patient/features/common/appointment_booking/view_models/book_appointment_view_model.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../misc/ui/base_widget.dart';

class SearchLabListView extends StatefulWidget {
  @override
  _SearchLabListViewState createState() => _SearchLabListViewState();
}

class _SearchLabListViewState extends State<SearchLabListView> {
  /*Location location = new Location();
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  List<Address> addresses;
  Address first;
  bool _serviceEnabled;*/
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String? name = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String? auth = '';
  var model = BookAppoinmentViewModel();
  var labSearchList = <Labs>[];
  late ProgressDialog progressDialog;

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      //debugPrint(user.toJson().toString());
      auth = user.data!.accessToken;
      getLabList();
      setState(() {
        name = user.data!.user!.person!.firstName;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }
  }

  getLabList() async {
    try {
      final LabsListApiResponse labsListApiResponse =
          await model.getLabsList('Bearer ' + auth!);

      if (labsListApiResponse.status == 'success') {
        if (labsListApiResponse.data!.labs!.isNotEmpty) {
          labSearchList.clear();
          labSearchList.addAll(labsListApiResponse.data!.labs!);
        } else {
          labSearchList.clear();
        }
      } else {
        showToast(labsListApiResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  getLabListByName(String name) async {
    try {
      final LabsListApiResponse labsListApiResponse =
          await model.getLabsListByLocality(name, 'Bearer ' + auth!);

      if (labsListApiResponse.status == 'success') {
        if (labsListApiResponse.data!.labs!.isNotEmpty) {
          labSearchList.clear();
          labSearchList.addAll(labsListApiResponse.data!.labs!);
        } else {
          labSearchList.clear();
        }
      } else {
        showToast(labsListApiResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  getLocation() async {
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

  findOutCityFromGeoCord(double lat, double long) async {
    /*final coordinates = new Coordinates(lat, long);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    debugPrint("${first.featureName} : ${first.locality}");*/
  }

  getLabDetails(String labUserId) async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');
      progressDialog.show(max: 100, msg: 'Loading...');
      final LabDetailsResponse doctorDetailsResponse =
          await model.getLabDetails('Bearer ' + auth!, labUserId);

      if (doctorDetailsResponse.status == 'success') {
        progressDialog.close();
        Navigator.pushNamed(context, RoutePaths.Lab_Details_View,
            arguments: doctorDetailsResponse.data!.lab);
      } else {
        progressDialog.close();
        showToast(doctorDetailsResponse.message!, context);
      }
    } catch (CustomException) {
      progressDialog.close();
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
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
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<BookAppoinmentViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            title: Text(
              'Lab List',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: MergeSemantics(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                                getLabListByName(text);
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 0),
                                  hintText: 'Search labs by name')),
                        ),
                        Container(
                          padding: const EdgeInsets.all(0.0),
                          height: 40.0,
                          width: 40.0,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                _searchController.clear();
                                getLabList();
                              },
                              child: Icon(
                                _searchController.text.isEmpty
                                    ? Icons.search
                                    : Icons.clear,
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
                    'Near By',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: model!.busy
                        ? Center(
                            child: SizedBox(
                                height: 32,
                                width: 32,
                                child: CircularProgressIndicator()))
                        : (labSearchList.isEmpty
                            ? noLabFound()
                            : labSearchResultListView()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget noLabFound() {
    return Center(
      child: Text('No lab found in your locality',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryLightColor)),
    );
  }

  Widget labSearchResultListView() {
    return ListView.separated(
        itemBuilder: (context, index) => _makeLabListCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        itemCount: labSearchList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget _makeLabListCard(BuildContext context, int index) {
    final Labs labDetails = labSearchList.elementAt(index);
    return MergeSemantics(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                                backgroundImage: ((labDetails.imageURL == '') ||
                                        (labDetails.imageURL == null)
                                    ? AssetImage(
                                        'res/images/profile_placeholder.png')
                                    : NetworkImage(labDetails
                                        .imageURL!)) as ImageProvider<Object>?),
                          ),
                        ),
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
                            Text(labDetails.establishmentName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: primaryColor)),
                            Text(labDetails.locality!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                    color: textBlack)),
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
                  Semantics(
                    label: 'Book_' + labDetails.establishmentName! + '',
                    button: true,
                    hint: 'activate to book now',
                    child: InkWell(
                      onTap: () {
                        /*Navigator.pushNamed(context, RoutePaths.Lab_Details_View,
                            arguments: labDetails);*/
                        getLabDetails(labDetails.userId!);
                      },
                      child: Container(
                        height: 56,
                        width: 120,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            border: Border.all(color: primaryColor),
                            borderRadius: BorderRadius.only(
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
                              fontWeight: FontWeight.w600),
                        )),
                      ),
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
