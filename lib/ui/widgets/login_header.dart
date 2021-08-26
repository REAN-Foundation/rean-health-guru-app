import 'package:paitent/ui/shared/text_styles.dart';
import 'package:paitent/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final TextEditingController mobileNumberController;
  final TextEditingController passwordController;
  final FocusNode _mobileNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final String validationMessage;

  String mobileNumber;

  LoginHeader(
      {@required this.mobileNumberController,
      @required this.passwordController,
      this.validationMessage});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      /*Text('Login', style: headerStyle),
      UIHelper.verticalSpaceMedium,
      Text('Enter a number between 1 - 10', style: subHeaderStyle),
      LoginTextField(controller),
      this.validationMessage != null
          ? Text(validationMessage, style: TextStyle(color: Colors.red))
          : Container()*/

      Padding(
        padding: const EdgeInsets.all(60.0),
        child: Image(
          image: new AssetImage("assets/images/doctor_logo.png"),
          height: 180,
          width: 180,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
            width: 400.0,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /*Expanded(
                  child: Container(
                    child:  InternationalPhoneNumberInput(
                      onInputChanged:
                          (PhoneNumber number) {
                        mobileNumber = number
                            .parseNumber();
                        debugPrint(number
                            .parseNumber());

                        if (mobileNumber !=
                            number
                                .parseNumber()) {

                        } else {
                          //dismissOtpWidget();
                        }
                      },
                      keyboardAction:
                      TextInputAction.done,
                      isEnabled: true,
                      formatInput: true,
                      ignoreBlank: true,
                      selectorConfig: SelectorConfig(
                          selectorType:
                          PhoneInputSelectorType
                              .BOTTOM_SHEET),
                      initialValue: PhoneNumber(
                          isoCode: 'IN'),
                      inputDecoration:
                      InputDecoration(
                        //filled: true,
                        //fillColor: Color(0xFFFFFFFF),

                        hintText:
                        'Mobile Number',
                        enabledBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(
                              Radius
                                  .circular(
                                  10.0)),
                          borderSide:
                          BorderSide(
                              color: Colors
                                  .white),
                        ),
                        focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(
                              Radius
                                  .circular(
                                  10.0)),
                          borderSide:
                          BorderSide(
                              color: Colors
                                  .white),
                        ),
                      ),
                    ),
                  ),
                )*/
              ],
            )),
      ),
      Container(
        width: 400.0,
        height: 52.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  focusNode: _passwordFocus,
                  controller: passwordController,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (text) {
                    debugPrint(text);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    hintText: 'Enter your Password',
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ]),
      ),
      SizedBox(
        height: 40,
      ),
    ]);
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

/*
class LoginTextField extends StatelessWidget {
  final TextEditingController controller;

  LoginTextField(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      height: 50.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: TextField(
          decoration: InputDecoration.collapsed(hintText: 'User Id'),
          controller: controller),
    );
  }
}
*/
