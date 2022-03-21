import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/core/models/DoctorAppoinmentBookedSuccessfully.dart';
import 'package:paitent/core/models/DoctorBookingAppoinmentPojo.dart';
import 'package:paitent/core/models/UploadImageResponse.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/labsListApiResponse.dart';
import 'package:paitent/core/models/time_slot.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/infra/networking/ApiProvider.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/SharedPrefUtils.dart';
import 'package:paitent/ui/views/doctorTileWidget.dart';
import 'package:paitent/ui/views/labTileWidget.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'base_widget.dart';

//ignore: must_be_immutable
class BookingInfoView extends StatefulWidget {
  DoctorBookingAppoinmentPojo bookingAppoinmentsDetails;

  BookingInfoView(this.bookingAppoinmentsDetails);

  @override
  _BookingInfoViewState createState() =>
      _BookingInfoViewState(bookingAppoinmentsDetails);
}

class _BookingInfoViewState extends State<BookingInfoView> {
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String name = '';
  var value;
  List<TimeSlot> timeSlot = [];
  String selectedGender = 'Male';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String mobileNumber;
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _mobileNumberFocus = FocusNode();
  final _noteFocus = FocusNode();
  final _emailFocus = FocusNode();
  UserData user;
  Doctors doctorDetails;
  DoctorBookingAppoinmentPojo bookingAppoinmentsDetails;
  var dateFormat = DateFormat('dd MMM, yyyy');
  var dateFormatFull = DateFormat('yyyy-MM-dd');
  var timeFormat = DateFormat('hh:mm a');
  String attachmentPath = '';
  String dob = '';
  ProgressDialog progressDialog;
  var patientId = '';
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();
  Labs labDetails;

  _BookingInfoViewState(this.bookingAppoinmentsDetails);

  String auth = '';
  var model = BookAppoinmentViewModel();

  loadSharedPrefs() async {
    try {
      user = UserData.fromJson(await _sharedPrefUtils.read('user'));
      patientId = user.data.user.id.toString();
      auth = user.data.accessToken;

      setSelfData();
      debugPrint(user.toJson().toString());
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  setSelfData() {
    dob = dateFormat
        .format(bookingAppoinmentsDetails.patient.user.person.birthDate);

    _firstNameController.text = user.data.user.person.firstName;
    _firstNameController.selection = TextSelection.fromPosition(
      TextPosition(offset: _firstNameController.text.length),
    );

    _lastNameController.text = user.data.user.person.lastName;
    _lastNameController.selection = TextSelection.fromPosition(
      TextPosition(offset: _lastNameController.text.length),
    );

    _mobileNumberController.text = user.data.user.person.phone;
    _mobileNumberController.selection = TextSelection.fromPosition(
      TextPosition(offset: _mobileNumberController.text.length),
    );
    _emailController.text = user.data.user.person.email;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    if (bookingAppoinmentsDetails.whichFlow == 'Lab') {
      labDetails = bookingAppoinmentsDetails.labs;
    } else {
      doctorDetails = bookingAppoinmentsDetails.doctors;
    }

    progressDialog = ProgressDialog(context);

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
                  if (bookingAppoinmentsDetails.whichFlow == 'Lab')
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LabTileView(labDetails),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DoctorTileView(doctorDetails),
                    ),
                  _makeDateAndTimeTile(),
                  //_bookAppoinmentFor(),
                  _textFeildWidget(),
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
            child: Text('Continue',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              if (_firstNameController.text == '') {
                showToast('Please enter first name', context);
              } else if (_lastNameController.text == '') {
                showToast('Please enter last name', context);
              } else if (_mobileNumberController.text.toString().length != 10) {
                showToast('Please enter valid mobile number', context);
              } else if (selectedGender == '') {
                showToast('Please select gender', context);
              } else if (dob == '') {
                showToast('Please select Date of Birth', context);
              }
              /*else if(validateEmail(_emailController.text)) {
                showToast("Please enter valid email");
              }  else if (_noteController.text == '') {
                showToast("Please enter password");
              } */
              else {
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
      final map = <String, String>{};
      map['patientUserId'] = patientId;
      map['date'] = dateFormatFull
          .format(DateTime.parse(bookingAppoinmentsDetails.selectedDate));
      map['startTime'] = bookingAppoinmentsDetails.slotStart;
      map['endTime'] = bookingAppoinmentsDetails.slotEnd;

      final DoctorAppoinmentBookedSuccessfully bookAAppoinmentForDoctor =
          await model.bookAAppoinmentForDoctor(
              doctorDetails.userId.toString(), map, 'Bearer ' + auth);

      if (bookAAppoinmentForDoctor.status == 'success') {
        //Navigator.pushNamed(context, RoutePaths.Booking_Appoinment_Confirmation_View);
        showToast(bookAAppoinmentForDoctor.message, context);
        debugPrint('Clicked On Proceed');
      } else {
        showToast(bookAAppoinmentForDoctor.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }


  Widget _makeDateAndTimeTile() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Appointment On',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 14)),
          SizedBox(
            width: 4,
          ),
          RichText(
            text: TextSpan(
              text: dateFormat.format(
                  DateTime.parse(bookingAppoinmentsDetails.selectedDate)),
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 14),
              children: <TextSpan>[
                TextSpan(
                    text: ' : ' +
                        timeFormat.format(
                            DateTime.parse(bookingAppoinmentsDetails.slotStart)
                                .toLocal()),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 14)),
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

  Widget _genderWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Gender',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                  debugPrint('switched to: $index');
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
              padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      bookingAppoinmentsDetails.patient.user.person.gender ==
                                  'M' ||
                              bookingAppoinmentsDetails
                                      .patient.user.person.gender ==
                                  'Male'
                          ? 'Male'
                          : 'Female',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black54),
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

  Widget _textFeildWidget() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _entryFirstNameField('First Name'),
          _entryLastNameField('Last Name'),
          _entryMobileNoField('Mobile Number'),
          _genderWidget(),
          _dateOfBirthField('Date Of Birth'),
          _entryEmailField(),
          _entryNoteField('Note'),
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        dob,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black54),
                      ),
                    ),
                    SizedBox(
                        height: 32,
                        width: 32,
                        child: Image.asset('res/images/ic_calender.png')),
                  ],
                ),
              ),
            ),
            onTap: () {
              /* DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  maxTime: DateTime.now().subtract(Duration(days: 1)), onChanged: (date) {
                    debugPrint('change $date');
                  }, onConfirm: (date) {
                    setState(() {
                      dob = dateFormat.format(date);
                    });
                    debugPrint('confirm $date');
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
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: '(Optional)',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: Colors.black87)),
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
                style: TextStyle(
                  color: Colors.black54,
                ),
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                style: TextStyle(
                  color: Colors.black54,
                ),
                enabled: false,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
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

  Widget _entryLastNameField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                style: TextStyle(
                  color: Colors.black54,
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  _fieldFocusChange(
                      context, _lastNameFocus, _mobileNumberFocus);
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

  Widget _entryMobileNoField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                      '+91',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black54,
                      ),
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
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _mobileNumberFocus, _noteFocus);
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            counterText: '',
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
      debugPrint('File Result ==> $result');

      if (result != '') {
        final File file = File(result);
        debugPrint(result);
        final String fileName = file.path.split('/').last;
        debugPrint('File Name ==> $fileName');
        uploadProfilePicture(file);
      } else {
        showToast('Please select document', context);
      }
    } catch (e) {
      showToast('Please select document', context);
      debugPrint(e);
      result = 'Error: $e';
    }
  }

  uploadProfilePicture(File file) async {
    try {
      progressDialog.show();
      final map = <String, String>{};
      map['enc'] = 'multipart/form-data';
      map['Authorization'] = 'Bearer ' + auth;

      final String _baseUrl = apiProvider.getBaseUrl();

      final postUri = Uri.parse(_baseUrl + '/resources/upload/');
      final request = http.MultipartRequest('POST', postUri);
      request.headers.addAll(map);
      request.files.add(http.MultipartFile(
          'name', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
      request.fields['isPublicprofile'] = 'true';

      request.send().then((response) async {
        if (response.statusCode == 200) {
          progressDialog.hide();
          debugPrint('Uploaded!');
          final respStr = await response.stream.bytesToString();
          debugPrint('Uploded ' + respStr);
          final UploadImageResponse uploadResponse =
              UploadImageResponse.fromJson(json.decode(respStr));
          if (uploadResponse.status == 'success') {
            progressDialog.hide();
            attachmentPath = uploadResponse.data.details.elementAt(0).url;
            listFiles.add(attachmentPath);
            showToast('File uploaded successfully!', context);
            setState(() {});
          } else {
            progressDialog.hide();
            showToast('Opps, something wents wrong!', context);
          }
        } else {
          progressDialog.hide();
          debugPrint('Upload Faild !');
        }
      }); // debugPrint("3");

    } catch (CustomException) {
      progressDialog.hide();
      debugPrint('4');
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  var listFiles = <String>[];

  Widget _addAttachment() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            getFile();
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                Text(
                  'Attachment',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                SizedBox(
                  width: 4,
                ),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Image(
                    image: AssetImage('res/images/ic_attachment.png'),
                  ),
                ),
                (listFiles.isNotEmpty
                    ? Container(
                        height: 40,
                        width: 40,
                        child: Image(
                          image: AssetImage('res/images/ic_lab_report.png'),
                        ),
                      )
                    : SizedBox()),
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
     )).then((response) => debugPrint(response)).catchError((error) => debugPrint(error));
  }*/

  bool validateEmail(String value) {
    const Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(pattern);
    if (regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }
}
//right_arrow
