import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/appointment_booking/models/labs_list_api_response.dart';
import 'package:patient/features/common/appointment_booking/view_models/appointment_view_model.dart';
import 'package:patient/features/misc/models/doctor_booking_appointment_pojo.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/themes/app_colors.dart';

//ignore: must_be_immutable
class BookingConfirmedView extends StatefulWidget {
  DoctorBookingAppoinmentPojo? bookingAppoinmentsDetails;

  BookingConfirmedView(bookingAppoinmentsDetails) {
    this.bookingAppoinmentsDetails = bookingAppoinmentsDetails;
  }

  @override
  _BookingConfirmedViewState createState() =>
      _BookingConfirmedViewState(bookingAppoinmentsDetails);
}

class _BookingConfirmedViewState extends State<BookingConfirmedView> {
  DoctorBookingAppoinmentPojo? bookingAppoinmentsDetails;
  Doctors? doctorDetails;
  var dateFormat = DateFormat('dd MMM, yyyy');
  var dateFormatFull = DateFormat('yyyy-MM-dd');
  var timeFormat = DateFormat('hh:mm a');
  Labs? labDetails;

  _BookingConfirmedViewState(this.bookingAppoinmentsDetails);

  @override
  Widget build(BuildContext context) {
    if (bookingAppoinmentsDetails!.whichFlow == 'Lab') {
      labDetails = bookingAppoinmentsDetails!.labs;
    } else {
      doctorDetails = bookingAppoinmentsDetails!.doctors;
    }
    return BaseWidget<AppoinmentViewModel?>(
        model: AppoinmentViewModel(),
        builder: (context, model, child) => Container(
                child: WillPopScope(
              onWillPop: _onBackPressed,
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    child: Image(
                                      image:
                                          AssetImage('res/images/ic_tick.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text('Appointment Confirmed',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  Text('ID: 2359852',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor)),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  /*Text(
                                        'Confirmation email and sms has been sent to\nyour registered details',
                                        style: TextStyle(
                                            fontSize: 12, fontWeight: FontWeight.normal),
                                        textAlign: TextAlign.center,
                                      ),*/
                                  SizedBox(
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                            _makeDateAndTimeTile(),
                            Container(
                              height: 360,
                              child:
                              bookingAppoinmentsDetails!.whichFlow == 'Lab'
                                      ? _makeLabTile()
                                      : _makeDoctorTile(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    _continueButton(),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget _makeDoctorTile() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 24,
          ),
          Text('Appointment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 56,
            width: 56,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: primaryColor,
              child: CircleAvatar(
                  radius: 38,
                  backgroundImage: (doctorDetails!.imageURL == ''
                          ? AssetImage('res/images/profile_placeholder.png')
                          : NetworkImage(doctorDetails!.imageURL!))
                      as ImageProvider<Object>?),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
              'Dr.' +
                  doctorDetails!.firstName! +
                  ' ' +
                  doctorDetails!.lastName!,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          SizedBox(
            height: 4,
          ),
          Text(doctorDetails!.specialities!,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                  color: textBlack)),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Divider(
              color: Color(0XFF909CAC),
              thickness: 0.2,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              doctorDetails!.address!,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w300, color: textBlack),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Contact No.: ',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: textBlack),
              ),
              SizedBox(
                width: 8,
              ),
              /* AutolinkText(
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
            ],
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Divider(
              color: Color(0XFF909CAC),
              thickness: 0.2,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          /* RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Medical Complaint\n',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16),
              children: <TextSpan>[
                TextSpan(
                    text: 'Fever & Cough',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 16)),
              ],
            ),
          ),*/
          SizedBox(
            height: 16,
          ),
        ]);
  }

  Widget _makeLabTile() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 24,
          ),
          Text('Appointment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 56,
            width: 56,
            child: CircleAvatar(
              radius: 48,
              backgroundColor: primaryColor,
              child: CircleAvatar(
                  radius: 48,
                  backgroundImage: ((labDetails!.imageURL == '') ||
                              (labDetails!.imageURL == null)
                          ? AssetImage('res/images/profile_placeholder.png')
                          : NetworkImage(labDetails!.imageURL!))
                      as ImageProvider<Object>?),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(labDetails!.firstName! + ' ' + labDetails!.lastName!,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          SizedBox(
            height: 4,
          ),
          Text(labDetails!.locality!,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                  color: textBlack)),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Divider(
              color: Color(0XFF909CAC),
              thickness: 0.2,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              labDetails!.address!,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w300, color: textBlack),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Contact No.: ',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: textBlack),
              ),
              SizedBox(
                width: 8,
              ),
              /*AutolinkText(
                  text: '+91 ' + labDetails.phoneNumber,
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
            ],
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Divider(
              color: Color(0XFF909CAC),
              thickness: 0.2,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          //_continueButton(),
        ]);
  }

  Widget _makeDateAndTimeTile() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Appointment On',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 16)),
          SizedBox(
            width: 4,
          ),
          RichText(
            text: TextSpan(
              text: dateFormat.format(
                  DateTime.parse(bookingAppoinmentsDetails!.selectedDate)),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                    text: ' : ' +
                        timeFormat.format(DateTime.parse(
                                bookingAppoinmentsDetails!.slotStart!)
                            .toLocal()),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20)),
              ],
            ),
          ),
          /* Expanded(
            child: TextFormField(
              //validator: value.isEmpty ? 'this field is required' : null,
              readOnly: true,
              style: TextStyle(fontSize: 13.0),
              decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 13.0),
                  hintText: 'Pick Month',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  suffixIcon: Icon(Icons.calendar_today)),
              onTap: () => handleReadOnlyInputClick(context),
            ),
          )*/
        ],
      ),
    );
  }

  /*Widget _continueButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Material(
          //Wrap with Material
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          elevation: 4.0,
          color: Color(0xFFC8DDFF),
          clipBehavior: Clip.antiAlias,
          // Add This
          child: MaterialButton(
            minWidth: 200,
            child: new Text('Done',
                style: new TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF142642),
                    fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return HomeView();
              }), (Route<dynamic> route) => false);
              debugPrint("Clicked On Proceed");
            },
          ),
        ),
      ],
    );
  }*/

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
            minWidth: 240,
            child: Text('Go to My Appointments',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return HomeView(
                  3,
                );
              }), (Route<dynamic> route) => false);
              debugPrint('Clicked On Proceed');
            },
          ),
        ),
      ],
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        barrierDismissible: false,
      context: context,
          builder: (context) => AlertDialog(
            title: Text('Thank You For Booking'),
            content: Text('Your Appointment is Booked Successfully'),
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return HomeView(4);
            }), (Route<dynamic> route) => false),
            child: Text('Ok'),
          ),
        ],
      ),
    ).then((value) => value as bool);
  }
}
