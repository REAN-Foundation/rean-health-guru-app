import 'package:flutter/material.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/DoctorAppoinmentBookedSuccessfully.dart';
import 'package:paitent/core/models/DoctorBookingAppoinmentPojo.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/labsListApiResponse.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/CommonUtils.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'base_widget.dart';
//ignore: must_be_immutable
class BookingAppoinmentConfirmationView extends StatefulWidget {
  DoctorBookingAppoinmentPojo bookingAppoinmentsDetails;

  BookingAppoinmentConfirmationView(this.bookingAppoinmentsDetails);

  @override
  _BookingAppoinmentConfirmationViewViewState createState() =>
      _BookingAppoinmentConfirmationViewViewState(bookingAppoinmentsDetails);
}

class _BookingAppoinmentConfirmationViewViewState
    extends State<BookingAppoinmentConfirmationView> {
  DoctorBookingAppoinmentPojo bookingAppoinmentsDetails;
  var model = BookAppoinmentViewModel();
  Doctors doctorDetails;
  Patient patientDetails;
  UserData userData;
  Labs labDetails;

  _BookingAppoinmentConfirmationViewViewState(this.bookingAppoinmentsDetails);

  var dateFormat = DateFormat('dd MMM, yyyy');
  var dateFormatFull = DateFormat('yyyy-MM-dd');
  var timeFormat = DateFormat('hh:mm a');

  //Razorpay _razorpay = Razorpay();
  var options;

  @override
  void initState() {
    super.initState();
    //payData();
  }

  /*Future payData() async {

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("payment has succedded");
    _bookADoctorAppoinmentSlot();
    _razorpay.clear();
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("payment has error");
    // Do something when payment fails
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("payment has externalWallet");

    _razorpay.clear();
    // Do something when an external wallet is selected
  }*/

  @override
  Widget build(BuildContext context) {
    if (bookingAppoinmentsDetails.whichFlow == 'Lab') {
      labDetails = bookingAppoinmentsDetails.labs;
    } else {
      doctorDetails = bookingAppoinmentsDetails.doctors;
    }
    debugPrint(bookingAppoinmentsDetails.userData.data.user.id);
    patientDetails = bookingAppoinmentsDetails.patient;
    userData = bookingAppoinmentsDetails.userData;
    return BaseWidget<BookAppoinmentViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Confirm Booking',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          //drawer: AppDrawer(),
          body: Container(
            //padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  _makeDateAndTimeTile(),
                  if (bookingAppoinmentsDetails.whichFlow == 'Lab')
                    _makeLabListCard()
                  else
                    _makeDoctorListCard(),
                  _makePatientListCard(),
                  SizedBox(
                    height: 16,
                  ),
                  if (model.busy)
                    Center(child: CircularProgressIndicator())
                  else
                    _continueButton(),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
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
            child: Text(
                bookingAppoinmentsDetails.whichFlow == 'Lab'
                    ? 'Confirm Booking'
                    : 'Continue To Pay',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              if (bookingAppoinmentsDetails.whichFlow == 'Lab') {
                _bookALabAppoinmentSlot();
              } else {
                _showPaymentNativeView();
              }
              debugPrint('Clicked On Proceed');
            },
          ),
        ),
      ],
    );
  }

  String calculateAge(DateTime birthDate) {
    final DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    final int month1 = currentDate.month;
    final int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      final int day1 = currentDate.day;
      final int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }

  Widget _makePatientListCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48.0, 16, 16, 16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Text(
              'Patient Details',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              patientDetails.user.person.firstName +
                  ' ' +
                  patientDetails.user.person.lastName,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
                patientDetails.user.person.gender == 'M'
                    ? 'Male' ', ' +
                        calculateAge(patientDetails.user.person.birthDate) +
                        ' years'
                    : 'Female' ', ' +
                        calculateAge(patientDetails.user.person.birthDate) +
                        ' years',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Color(0XFF303030))),
            SizedBox(
              height: 8,
            ),
            Text(
                '+91 ' +
                    userData.data.user.person.phone +
                    ' | ' +
                    userData.data.user.person.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                    color: Color(0XFF303030))),
            SizedBox(
              height: 8,
            ),
            /*if(patientDetails.address != null)...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Image(
                    image: AssetImage('res/images/ic_pin.png'),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color(0XFF303030)),
                ),
              ],
            ),
            ],*/
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Note: ',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        color: Color(0XFF303030))),
                Expanded(
                  child: Text(bookingAppoinmentsDetails.patientNote,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: Color(0XFF303030))),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            if (bookingAppoinmentsDetails.attachmentPath != '') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Attachment: ',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: Color(0XFF303030))),
                  SizedBox(
                    width: 16,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    child: Image(
                      image: AssetImage('res/images/ic_lab_report.png'),
                    ),
                  ),
                ],
              ),
            ]
          ]),
    );
  }

  Widget _makeDoctorListCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          Text(
            '        Doctor Details',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      height: 56,
                      width: 56,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: primaryColor,
                        child: CircleAvatar(
                            radius: 38,
                            backgroundImage: doctorDetails.imageURL == ''
                                ? AssetImage(
                                    'res/images/profile_placeholder.png')
                                : NetworkImage(doctorDetails.imageURL)),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          'Dr.' +
                              doctorDetails.firstName +
                              ' ' +
                              doctorDetails.lastName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor)),
                      Text(doctorDetails.specialities,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              color: Color(0XFF909CAC))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 70,),
              RichText(
                text: TextSpan(
                  text: '    Consultation Fee :',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(text: ' ₹ 500', style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),*/
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: Image(
                  image: AssetImage('res/images/ic_pin.png'),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  doctorDetails.address,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color(0XFF303030)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: Image(
                  image: AssetImage('res/images/ic_contact.png'),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              AutolinkText(
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
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _makeLabListCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          Text(
            '        Lab Details',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      height: 56,
                      width: 56,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: primaryColor,
                        child: CircleAvatar(
                            radius: 48,
                            backgroundImage: (labDetails.imageURL == '') ||
                                    (labDetails.imageURL == null)
                                ? AssetImage(
                                    'res/images/profile_placeholder.png')
                                : NetworkImage(labDetails.imageURL)),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(labDetails.firstName + ' ' + labDetails.lastName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor)),
                      Text(labDetails.locality,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              color: Color(0XFF909CAC))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 70,),
              RichText(
                text: TextSpan(
                  text: '    Consultation Fee :',
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(text: ' ₹ 500', style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),*/
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: Image(
                  image: AssetImage('res/images/ic_pin.png'),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  labDetails.address,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color(0XFF303030)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 40,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: Image(
                  image: AssetImage('res/images/ic_contact.png'),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              AutolinkText(
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
                  }),
            ],
          ),
        ],
      ),
    );
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
                  DateTime.parse(bookingAppoinmentsDetails.selectedDate)),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                    text: ' : ' +
                        timeFormat.format(
                            DateTime.parse(bookingAppoinmentsDetails.slotStart)
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

  _bookALabAppoinmentSlot() async {
    try {
      model.setBusy(true);
      final map = <String, String>{};
      map['PatientUserId'] = userData.data.user.id;
      map['Date'] = dateFormatFull
          .format(DateTime.parse(bookingAppoinmentsDetails.selectedDate));
      map['StartTime'] = bookingAppoinmentsDetails.slotStart;
      map['EndTime'] = bookingAppoinmentsDetails.slotEnd;

      final DoctorAppoinmentBookedSuccessfully bookAAppoinmentForDoctor =
          await model.bookAAppoinmentForLab(labDetails.userId.toString(), map,
              'Bearer ' + userData.data.accessToken);

      if (bookAAppoinmentForDoctor.status == 'success') {
        Navigator.pushNamed(context, RoutePaths.Booking_Appoinment_Done_View,
            arguments: bookingAppoinmentsDetails);
        showToast(bookAAppoinmentForDoctor.message, context);
      } else {
        showToast(bookAAppoinmentForDoctor.message, context);
      }
    } catch (CustomException) {
      debugPrint('Error ' + CustomException.toString());
      model.setBusy(false);
      showToast(CustomException.toString(), context);
    }
  }

  _showPaymentNativeView() async {
    const String apiKey = 'rzp_test_ubksTAzpIsHtWk';
    options = {
      'key': apiKey, // Enter the Key ID generated from the Dashboard

      'amount': doctorDetails.consultationFee *
          100, //in the smallest currency sub-unit.
      'name': 'REAN Care',

      'currency': 'INR',
      'theme.color': '#FFFFFF',
      'buttontext': 'Pay',
      'description': 'Doctor Consutation Fee',
      'prefill': {
        'contact': userData.data.user.person.phone,
        'email': userData.data.user..person.email,
      }
    };

    try {
      //_razorpay.open(options);
    } catch (e) {
      debugPrint('errror occured here is ......................./:$e');
    }
  }
}
