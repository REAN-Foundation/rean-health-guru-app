import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:patient/infra/themes/app_colors.dart';

//ignore: must_be_immutable
class LocationPermissionRequest extends StatefulWidget {

  @override
  _LocationPermissionRequestViewState createState() =>
      _LocationPermissionRequestViewState();
}

class _LocationPermissionRequestViewState extends State<LocationPermissionRequest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              'Location Permission',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.white),
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
          body: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    color: primaryColor,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: primaryColor,
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: body(),
                    ),
                  )
                ],
              ),
            ],
          ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 180,
            width: 180,
            child: Lottie.asset(
              'res/lottiefiles/location.json',
              height: 180,
            ), ),
          SizedBox(height: 32,),
          Text(
            'Enable Location',
            style: TextStyle(
                fontSize: 18.0,
                color: textBlack,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20,),
          Text(
            'Granting access to your device\'s location enables us to provide you with updated medication reminders tailored to your current timezone..',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.0,
                color: textGrey,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 60,),
          _allowButton(),
          SizedBox(height: 10,),
          _laterButton(),
        ],
      ),
    );
  }

  Widget _allowButton() {
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
            minWidth: 180,
            child: Text('Allow',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
            onPressed: () {
              Navigator.pop(context, 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _laterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Material(
          //Wrap with Material
          color: Colors.transparent,
          // Add This
          child: MaterialButton(
            minWidth: 180,
            child: Text('Maybe later',
                style: TextStyle(
                    fontSize: 16.0,
                    color: textGrey,
                    fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.pop(context, 0);
            },
          ),
        ),
      ],
    );
  }
}