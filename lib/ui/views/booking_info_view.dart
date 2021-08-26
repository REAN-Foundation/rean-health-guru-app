import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/DoctorAppoinmentBookedSuccessfully.dart';
import 'package:paitent/core/models/DoctorBookingAppoinmentPojo.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/UploadImageResponse.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/labsListApiResponse.dart';
import 'package:paitent/core/models/time_slot.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/shared/text_styles.dart';
import 'package:paitent/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:paitent/ui/views/doctorTileWidget.dart';
import 'package:paitent/ui/views/labTileWidget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/widgets/app_drawer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/foundation.dart';
import 'base_widget.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BookingInfoView extends StatefulWidget {

  DoctorBookingAppoinmentPojo bookingAppoinmentsDetails;

  BookingInfoView(@required this.bookingAppoinmentsDetails);

  @override
  _BookingInfoViewState createState() => _BookingInfoViewState(bookingAppoinmentsDetails);
}

class _BookingInfoViewState extends State<BookingInfoView> {
  SharedPrefUtils _sharedPrefUtils = new SharedPrefUtils();
  String name = "";
  var value;
  List<TimeSlot> timeSlot = new List();
  String selectedGender = "Male";
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String mobileNumber;
  var _firstNameFocus = FocusNode();
  var _lastNameFocus = FocusNode();
  var _mobileNumberFocus = FocusNode();
  var _noteFocus = FocusNode();
  var _emailFocus = FocusNode();
  UserData user;
  Doctors doctorDetails;
  DoctorBookingAppoinmentPojo bookingAppoinmentsDetails;
  var dateFormat = DateFormat("dd MMM, yyyy");
  var dateFormatFull = DateFormat("yyyy-MM-dd");
  var timeFormat = DateFormat("hh:mm a");
  String attachmentPath = "";
  String dob = "";
  ProgressDialog progressDialog;
  var patientId = "";
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();
  Labs labDetails;
  _BookingInfoViewState(@required this.bookingAppoinmentsDetails);
  String auth = "";
  var model = new BookAppoinmentViewModel();

  loadSharedPrefs() async {
    try {
       user = UserData.fromJson(await _sharedPrefUtils.read("user"));
       patientId = user.data.user.userId.toString();
       auth = user.data.accessToken;

       setSelfData();
      debugPrint(user.toJson().toString());
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  setSelfData(){

    dob = dateFormat.format(bookingAppoinmentsDetails.patient.birthDate);

    _firstNameController.text = user.data.user.firstName;
    _firstNameController.selection = TextSelection.fromPosition(
      TextPosition(offset: _firstNameController.text.length),
    );

    _lastNameController.text = user.data.user.lastName;
    _lastNameController.selection = TextSelection.fromPosition(
      TextPosition(offset: _lastNameController.text.length),
    );

    _mobileNumberController.text = user.data.user.phoneNumber;
    _mobileNumberController.selection = TextSelection.fromPosition(
      TextPosition(offset: _mobileNumberController.text.length),
    );
    _emailController.text = user.data.user.email;

    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSharedPrefs();

  }


  @override
  Widget build(BuildContext context) {
    if(bookingAppoinmentsDetails.whichFlow == "Lab"){
      labDetails = bookingAppoinmentsDetails.labs;
    }else {
      doctorDetails = bookingAppoinmentsDetails.doctors;
    }

    progressDialog = new ProgressDialog(context);

    //loadSharedPrefs();
    //UserData data = UserData.fromJson(_sharedPrefUtils.read("user"));
    //debugPrint(_sharedPrefUtils.read("user"));

    return BaseWidget<BookAppoinmentViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Patient Details',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: new IconThemeData(color: Colors.black),
          ),
          //drawer: AppDrawer(),
          body: Container(
            //padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 16,),
                    bookingAppoinmentsDetails.whichFlow == "Lab" ?  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LabTileView(labDetails),
                    ) : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DoctorTileView(doctorDetails),
                    ),
                    _makeDateAndTimeTile(),
                    //_bookAppoinmentFor(),
                    _textFeildWidget(),
                    SizedBox(height: 16,),
                    model.busy ? Center(child: CircularProgressIndicator()) : _continueButton(),
                    SizedBox(height: 24,),
                  ],
              ),
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
            child: new Text('Continue',
                style: new TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.normal)),
            onPressed: () {
              if (_firstNameController.text == '') {
                showToast("Please enter first name");
              } else if (_lastNameController.text == '') {
                showToast("Please enter last name");
              } else if (_mobileNumberController.text.toString().length != 10) {
                showToast("Please enter valid mobile number");
              } else if(selectedGender == '') {
                showToast("Please select gender");
              } else if(dob == '') {
                showToast("Please select Date of Birth");
              } /*else if(validateEmail(_emailController.text)) {
                showToast("Please enter valid email");
              }  else if (_noteController.text == '') {
                showToast("Please enter password");
              } */else {
                bookingAppoinmentsDetails.patientNote =
                    _noteController.text.toString();
                bookingAppoinmentsDetails.attachmentPath = attachmentPath;
                Navigator.pushNamed(
                    context, RoutePaths.Booking_Appoinment_Confirmation_View,
                    arguments: bookingAppoinmentsDetails);
              }
              //bookADoctorAppoinmentSlot();

            },
          ),
        ),
      ],
    );
  }

  bookADoctorAppoinmentSlot() async {
    try {
      model.setBusy(true);
      var map = new Map<String, String>();
      map["patientUserId"] = patientId;
      map["date"] = dateFormatFull.format(DateTime.parse(bookingAppoinmentsDetails.selectedDate));
      map["startTime"] = bookingAppoinmentsDetails.slotStart;
      map["endTime"] = bookingAppoinmentsDetails.slotEnd;

      DoctorAppoinmentBookedSuccessfully bookAAppoinmentForDoctor = await model.bookAAppoinmentForDoctor(doctorDetails.userId.toString(), map, 'Bearer '+auth);

      if (bookAAppoinmentForDoctor.status == 'success') {
        //Navigator.pushNamed(context, RoutePaths.Booking_Appoinment_Confirmation_View);
        showToast(bookAAppoinmentForDoctor.message);
        debugPrint("Clicked On Proceed");
      } else {
        showToast(bookAAppoinmentForDoctor.message);
      }

    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error "+CustomException.toString());
    } catch (Exception){
      debugPrint(Exception.toString());
    }
  }

  Widget _makeDoctorListCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Image(
                        image: AssetImage('res/images/profile_placeholder.png'),
                      ),
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
                      Text(
                          'Dr.' +
                              doctorDetails.firstName +
                              ' ' +
                              doctorDetails.lastName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                              color: primaryColor)),
                      Text(
                          doctorDetails.specialities +
                              ', ' +
                              doctorDetails.qualification,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w100,
                              color: textBlack,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 55,
              ),
              RichText(
                text: TextSpan(
                  text: '    Consultation Fee :',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: textBlack,
                      fontSize: 14,
                      fontFamily: 'Montserrat'),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' ₹'+doctorDetails.consultationFee.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            fontSize: 14,
                            fontFamily: 'Montserrat')),
                  ],
                ),
              ),
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
        children: <Widget>[
          Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Image(
                        image: AssetImage('res/images/profile_placeholder.png'),
                      ),
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
                      Text(
                          labDetails.firstName +
                              ' ' +
                              labDetails.lastName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                              color: primaryColor)),
                      Text(
                          labDetails.locality,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w100,
                              color: textBlack,
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeDateAndTimeTile(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Appointment On', style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14)),
          SizedBox(width: 4,),
          RichText(
            text: TextSpan(
              text: dateFormat.format(DateTime.parse(bookingAppoinmentsDetails.selectedDate)),
              style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14),
              children: <TextSpan>[
                TextSpan(text: ' : '+timeFormat.format(DateTime.parse(bookingAppoinmentsDetails.slotStart).toLocal()), style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14)),
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

  Widget _genderWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Gender",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
         /* InkWell(
            onTap: (){},
            child: ToggleSwitch(
                initialLabelIndex: bookingAppoinmentsDetails.patient.gender == "M" || bookingAppoinmentsDetails.patient.gender == "Male" ? 0 : 1,
                minWidth: 90.0,
                cornerRadius: 20,
                activeBgColor: Colors.green,
                activeTextColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveTextColor: Colors.white,
                labels: ['Male', 'Female'],
                icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                activeColors: [Colors.blue, Colors.pink],
                onToggle: (index) {
                  print('switched to: $index');
                  if(index == 0){
                    selectedGender = "Male";
                  }else{
                    selectedGender = "Female";
                  }
                }
            ),
          )*/
          Container(
            width: MediaQuery.of(context).size.width,
            height: 48.0,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Color(0XFF909CAC),
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0,8,0,8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      bookingAppoinmentsDetails.patient.gender == "M" || bookingAppoinmentsDetails.patient.gender == "Male" ? "Male" : "Female",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookAppoinmentFor(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Book a appoinment for",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          ToggleSwitch(
              minWidth: 120.0,
              cornerRadius: 20,
              activeBgColor: Color(0xFFC8DDFF),
              activeTextColor: Colors.black,
              inactiveBgColor: Colors.black12,
              inactiveTextColor: Colors.black,
              labels: ['Self', 'Others'],
              onToggle: (index) {
                print('switched to: $index');
                if(index == 0){
                  setSelfData();
                }else{
                  setState(() {
                    _firstNameController.clear();
                    _lastNameController.clear();
                    _mobileNumberController.clear();
                  });
                }
              }
          )
        ],
      ),
    );
  }

  Widget _textFeildWidget() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _entryFirstNameField("First Name"),
          _entryLastNameField("Last Name"),
          _entryMobileNoField("Mobile Number"),
          _genderWidget(),
          _dateOfBirthField("Date Of Birth"),
          _entryEmailField(),
          _entryNoteField("Note"),
          _addAttachment(),
        ],
      ),
    );
  }

  Widget _dateOfBirthField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Color(0XFF909CAC),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0,8,0,8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        dob,
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black54),
                      ),
                    ),
                    SizedBox( height: 32, width: 32, child: new Image.asset('res/images/ic_calender.png')),
                  ],
                ),
              ),
            ),
            onTap: (){
             /* DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  maxTime: DateTime.now().subtract(Duration(days: 1)), onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    setState(() {
                      dob = dateFormat.format(date);
                    });
                    print('confirm $date');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);*/
            },
          ),
        ],
      ),
    );
  }

  Widget _entryEmailField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: 'Email',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: '(Optional)',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.black54,
                width: 1.0,
              ),
            ),
            child: TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                enabled: false,
                style: TextStyle(color: Colors.black54,),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _emailFocus, _noteFocus);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)),
          )
        ],
      ),
    );
  }

  Widget _entryFirstNameField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.black54,
                width: 1.0,
              ),
            ),
            child: TextFormField(
                obscureText: isPassword,
                controller: _firstNameController,
                focusNode: _firstNameFocus,
                maxLines: 1,
                style: TextStyle(color: Colors.black54,),
                enabled: false,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)
                ),
          )
        ],
      ),
    );
  }

  Widget _entryLastNameField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.black54,
                width: 1.0,
              ),
            ),
            child: TextFormField(
                obscureText: isPassword,
                controller: _lastNameController,
                focusNode: _lastNameFocus,
                enabled: false,
                maxLines: 1,
                style: TextStyle(color: Colors.black54,),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _lastNameFocus, _mobileNumberFocus);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)
                ),
          )
        ],
      ),
    );
  }

  Widget _entryMobileNoField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.black54,
                  width: 1.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                    child: Text(
                      "+91",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black54,),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: _mobileNumberController,
                        focusNode: _mobileNumberFocus,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 10,
                        enabled: false,
                        style: TextStyle(color: Colors.black54,),
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _mobileNumberFocus, _noteFocus);
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  )
                ],
              )

            /*InternationalPhoneNumberInput
              .withCustomDecoration(
              onInputChanged: (PhoneNumber number) {
                mobileNumber = number.toString().trim();
                debugPrint(mobileNumber);

                if (mobileNumber != number.parseNumber()) {

                } else {
                  //dismissOtpWidget();
                }

              },
              textFieldController: _mobileNumberController,
              focusNode: _mobileNumberFocus,
              onSubmit: () {
                _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
              },
              keyboardAction: TextInputAction.next,
              autoValidate: false,
              formatInput: false,
              selectorType:
              PhoneInputSelectorType.BOTTOM_SHEET,
              initialCountry2LetterCode: 'IN',
              inputDecoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true)
          ),*/
          ),
        ],
      ),
    );
  }

  Widget _entryNoteField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: primaryColor,
                width: 1.0,
              ),
            ),
            child: TextFormField(
                obscureText: isPassword,
                controller: _noteController,
                focusNode: _noteFocus,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (term) {
                  //_fieldFocusChange(context, _lastNameFocus, _mobileNumberFocus);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)),
          )
        ],
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  Future getFile() async {
    String result;
    try {
      result = await FlutterDocumentPicker.openDocument();
      debugPrint('File Result ==> ${result}');

      if(result != '') {
        File file = File(result);
        debugPrint(result);
        String fileName = file.path.split('/').last;
        print("File Name ==> ${fileName}");
        uploadProfilePicture(file);
      } else {
        showToast('Please select document');
      }
    } catch (e) {
      showToast('Please select document');
      print(e);
      result = 'Error: $e';
    }
  }

  uploadProfilePicture(File file) async {

    try {
      progressDialog.show();
      var map = new Map<String, String>();
      map["enc"] = "multipart/form-data";
      map["Authorization"] = 'Bearer '+auth;

      String _baseUrl = apiProvider.getBaseUrl();

      var postUri = Uri.parse(_baseUrl+"/resources/upload/");
      var request = new http.MultipartRequest("POST", postUri);
      request.headers.addAll(map);
      request.files.add(
          http.MultipartFile('name',
              file.readAsBytes().asStream(),
              file.lengthSync(),
              filename: file.path.split('/').last
          )
      );
      request.fields['isPublicprofile'] = "true";

      request.send().then((response) async {
        if (response.statusCode == 200){
          progressDialog.hide();
          print("Uploaded!");
          final respStr = await response.stream.bytesToString();
          debugPrint("Uploded "+respStr);
          UploadImageResponse uploadResponse = UploadImageResponse.fromJson(json.decode(respStr));
          if(uploadResponse.status == "success"){
            progressDialog.hide();
            attachmentPath = uploadResponse.data.details.elementAt(0).url;
            listFiles.add(attachmentPath);
            showToast('File uploaded successfully!');
            setState(() {
            });
          }else{
            progressDialog.hide();
            showToast('Opps, something wents wrong!');
          }

        }else{
          progressDialog.hide();
          print("Upload Faild !");
        }
      });// debugPrint("3");

    } catch (CustomException) {
      progressDialog.hide();
      debugPrint("4");
      showToast(CustomException.toString());
      debugPrint("Error "+CustomException.toString());
    }
  }


  var listFiles = new List<String>();

  Widget _addAttachment(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            getFile();
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                Text(
                  "Attachment",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(width: 4,),
                SizedBox(height: 24, width: 24, child:  Image(
                  image: AssetImage('res/images/ic_attachment.png'),
                  ),
                ),
                (listFiles.length != 0 ? Container(
                  height: 40,
                   width: 40,
                  child: Image(
                   image: AssetImage(
                         'res/images/ic_lab_report.png'),),
                ) :
                 SizedBox()),
              ],
            ),
          ),
        ),


      ],
    );
  }

 /* uploadAttachment() async {
    Dio dio = new Dio();
    FormData formdata = new FormData(); // just like JS
     formdata.add("photos", new UploadFileInfo(_image, path.basename(_image.path)));
     dio.post(uploadURL, data: formdata, options:
    Options(method: 'POST',responseType: ResponseType.PLAIN // or ResponseType.JSON
     )).then((response) => print(response)).catchError((error) => print(error));
  }*/


    bool validateEmail(String value) {
      Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (regex.hasMatch(value))
      return false;
      else
      return true;
    }
}
//right_arrow