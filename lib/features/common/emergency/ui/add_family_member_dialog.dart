import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/models/upload_image_response.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';

import '../../../misc/ui/base_widget.dart';

//ignore: must_be_immutable
class AddFamilyMemberDialog extends StatefulWidget {
  late Function _submitButtonListner;

  //AllergiesDialog(@required this._allergiesCategoryMenuItems,@required this._allergiesSeveretyMenuItems, @required Function this.submitButtonListner, this.patientId);

  AddFamilyMemberDialog({Key? key, required Function submitButtonListner})
      : super(key: key) {
    _submitButtonListner = submitButtonListner;
  }

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<AddFamilyMemberDialog> {
  var model = PatientCarePlanViewModel();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _mobileNumberFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  String? profileImage = '';
  String? profileImagePath = '';
  String selectedGender = '';
  String? mobileNumber = '';
  String? countryCode = '';
  int? maxLengthOfPhone = 0;
  final List<String> radioItemsForGender = ['Female', 'Intersex', 'Male'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
        model: model,
        builder: (context, model, child) => Container(
              /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              backgroundColor: colorF6F6FF,*/
              child: addOrEditNurseDialog(context),
            ));
  }

  addOrEditNurseDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //_profileIcon(),
                  _entryFirstNameField('First Name'),
                  _entryLastNameField('Last Name'),
                  _entryMobileNoField('Phone'),
                  _entryDecriptionNameField('Relation'),
                  _genderWidget(),
                  const SizedBox(
                    height: 16,
                  ),
                  _submitButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_firstNameController.text == '') {
          showToastMsg('Enter first name', context);
        } else if (_lastNameController.text == '') {
          showToastMsg('Enter last name', context);
        } else if (mobileNumber!.isEmpty) {
          showToastMsg('Enter mobile number', context);
        } else if (mobileNumber!.length != maxLengthOfPhone) {
          showToastMsg('Enter valid mobile number', context);
        } else if (_descriptionController.text == '') {
          showToastMsg('Enter relation', context);
        } else if (selectedGender == '') {
          showToastMsg('Select sex', context);
        } else {
          widget._submitButtonListner(
              _firstNameController.text.trim(),
              _lastNameController.text.trim(),
              countryCode! + '-' + mobileNumber!,
              selectedGender,
              _descriptionController.text);
        }
      },
      style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(primaryLightColor),
          backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: primaryColor)))),
      child: Text(
        '      Save       ',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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
          Row(
            children: [
              Text(
                'Sex',
                semanticsLabel: 'Sex of family member or friend',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                '*',
                semanticsLabel: 'required',
                style: TextStyle(
                    color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
         /* RadioGroup<String>.builder(
            items: radioItemsForGender,
            groupValue: selectedGender.toString(),
            direction: Axis.horizontal,
            horizontalAlignment: MainAxisAlignment.start,
            onChanged: (item) {
              debugPrint(item);
              selectedGender = item.toString();
              setState(() {});
            },
            itemBuilder: (item) => RadioButtonBuilder(
              item,
              textPosition: RadioButtonTextPosition.right,
            ),
          ),*/
          Semantics(
            hint: 'required',
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: primaryColor, width: 0.80),
                  color: Colors.white),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedGender == ''
                    ? null
                    : selectedGender,
                items: radioItemsForGender.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Choose an option'),
                onChanged: (data) {
                  debugPrint(data);
                  setState(() {
                    selectedGender = data.toString();
                  });
                  setState(() {});
                },
              ),
            ),
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
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                '*',
                semanticsLabel: 'required',
                style: TextStyle(
                    color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.white),
            child: Semantics(
              label: 'first name of family member or friend',
              hint: 'required',
              child: TextFormField(
                  obscureText: isPassword,
                  controller: _firstNameController,
                  focusNode: _firstNameFocus,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
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
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                '*',
                semanticsLabel: 'required',
                style: TextStyle(
                    color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.white),
            child: Semantics(
              label: 'last name of family or friend',
              hint: 'required',
              child: TextFormField(
                  obscureText: isPassword,
                  controller: _lastNameController,
                  focusNode: _lastNameFocus,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(
                        context, _lastNameFocus, _mobileNumberFocus);
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
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
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                '*',
                semanticsLabel: 'required',
                style: TextStyle(
                    color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: primaryColor, width: 1),
                  color: Colors.white),
              child:
                  /*Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                    child: Text(
                      "+91",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: _mobileNumberController,
                        focusNode: _mobileNumberFocus,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 10,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _mobileNumberFocus, _descriptionFocus);
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  )
                ],
              )*/

                  /*InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  mobileNumber = number.parseNumber();
                  debugPrint(number.parseNumber());
                  if (mobileNumber.length == 10) {
                    if(mobileNumber.length == 10){
                      _fieldFocusChange(context, _mobileNumberFocus, _descriptionFocus);
                    }
                    //_fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                  }
                  if (mobileNumber != number.parseNumber()) {
                  } else {
                    //dismissOtpWidget();
                  }
                },
                keyboardAction: TextInputAction.done,
                focusNode: _mobileNumberFocus,
                */ /*textStyle:
                TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black26),*/ /*
                textFieldController: _mobileNumberController,
                isEnabled: true,
                formatInput: true,
                ignoreBlank: true,
                onFieldSubmitted: (term) {
                  //_fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                },
                selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                initialValue: PhoneNumber(isoCode: details.alpha2Code),
                inputDecoration: InputDecoration(
                  //filled: true,
                  //fillColor: Color(0xFFFFFFFF),

                //hintText: 'Mobile Number',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            )*/
              getAppFlavour() == "Heart & Stroke Helper™ " ? _customMobileNumberFeild() : IntlPhoneField(
                /*decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),*/
                controller: _mobileNumberController,
                focusNode: _mobileNumberFocus,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                autoValidate: true,
                decoration: InputDecoration(
                    counterText: '',
                    hintText: 'mobile number of family or friend required',
                    hintStyle: TextStyle(color: Colors.transparent),
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true),
                initialCountryCode: getCurrentLocale(),
                inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                countries: getAppFlavour() == 'Heart & Stroke Helper™ ' ? ['US'] : getAppFlavour() == 'HF Helper' ? ['US']  :null,
                onChanged: (phone) {
                  debugPrint(phone.countryCode);
                  debugPrint(phone.number);
                  mobileNumber = phone.number;
                  countryCode = phone.countryCode;
                  debugPrint(
                      'Country max length ==> ${countries.firstWhere((element) => element['code'] == phone.countryISOCode)['max_length']}');
                  maxLengthOfPhone = countries.firstWhere((element) =>
                      element['code'] == phone.countryISOCode)['max_length'];
                  /*if(mobileNumber.length == 10){
                    _fieldFocusChange(context, _mobileNumberFocus, _passwordFocus);
                  }*/
                },
                onCountryChanged: (phone) {
                  mobileNumber = '';
                  _mobileNumberController.clear();
                  setState(() {});
                },
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
                fillColor: Colors.white,
                filled: true)
        ),*/
              ),
        ],
      ),
    );
  }

  Widget _customMobileNumberFeild(){
    return TextFormField(
      keyboardType: TextInputType.phone,
      autocorrect: false,
      controller: _mobileNumberController,
      focusNode: _mobileNumberFocus,
      enabled: !model.busy,
      maxLength: 10,
      decoration: InputDecoration(
        //hintText: 'Mobile Number',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          prefixIcon:Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(" + 1  ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textBlack),),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          /*prefixText: '  +1    ',
          prefixStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textBlack),*/
          counterText: "",
          contentPadding: EdgeInsets.only(top: 12),
          fillColor: Colors.white,
          filled: true),
      inputFormatters: [
        // MaskedInputFormatter('(###) ###-####')
      ],
      onChanged: (phone){
        debugPrint(phone);
        mobileNumber = phone;
        countryCode = '+1';
        debugPrint("Mobile Number ==> $mobileNumber");
        if (phone.length == maxLengthOfPhone) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      // .. etc
    );
  }

  Widget _entryDecriptionNameField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                '*',
                semanticsLabel: 'required',
                style: TextStyle(
                    color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: primaryColor, width: 1),
                color: Colors.white),
            child: Semantics(
              label: 'Relation of family or friend',
              hint: 'required',
              child: TextFormField(
                  obscureText: isPassword,
                  controller: _descriptionController,
                  focusNode: _descriptionFocus,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term) {},
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
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

/*
  File _image;
  final picker = ImagePicker();
  List<String> listFiles = new List();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    //https://pub.dev/packages/image_cropper
    setState(() {
      _image = File(pickedFile.path);
      debugPrint(pickedFile.path);
    });

    uploadProfilePicture(pickedFile.path);
  }*/

  uploadProfilePicture(String filePath) async {
    try {
      final map = <String, String>{};
      map['enc'] = 'multipart/form-data';
      map['Authorization'] = 'Bearer ' + auth!;

      final postUri =
          Uri.parse('https://hca-bff-dev.services.tikme.app/resources/upload/');
      final request = http.MultipartRequest('POST', postUri);
      request.headers.addAll(map);
      request.files.add(http.MultipartFile.fromBytes(
          'name', await File.fromUri(Uri.parse(filePath)).readAsBytes()));
      //request.fields['isPublicprofile'] = "true";

      request.send().then((response) async {
        if (response.statusCode == 200) {
          debugPrint('Uploaded!');
          final respStr = await response.stream.bytesToString();
          debugPrint('Uploded ' + respStr);
          final UploadImageResponse uploadResponse =
              UploadImageResponse.fromJson(json.decode(respStr));
          if (uploadResponse.status == 'success') {
            profileImagePath = uploadResponse.data!.details!.elementAt(0).url;
            profileImage = uploadResponse.data!.details!.elementAt(0).url;
            showToastMsg(uploadResponse.message!, context);
          } else {
            showToastMsg('Opps, something wents wrong!', context);
          }
        } else {
          debugPrint('Upload Faild !');
        }
      }); // debugPrint("3");

    } catch (CustomException) {
      debugPrint('4');
      showToastMsg(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }
}
