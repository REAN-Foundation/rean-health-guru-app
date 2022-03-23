import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/features/common/appoinment_booking/view_models/appoinment_view_model.dart';
import 'package:paitent/infra/themes/app_colors.dart';

import '../../../misc/ui/base_widget.dart';

class PaymentConfirmationView extends StatefulWidget {
  @override
  _PaymentConfirmationViewState createState() =>
      _PaymentConfirmationViewState();
}

class _PaymentConfirmationViewState extends State<PaymentConfirmationView> {
  final _ammountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _ammountController.text = '300';
    return BaseWidget<AppoinmentViewModel>(
      model: AppoinmentViewModel(),
      builder: (context, model, child) => Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Payment',
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
                  _ammountFeild(),
                  SizedBox(
                    height: 16,
                  ),
                  _makePaymentMethodTile(),
                  _makeNewCardInputTile(),
                  SizedBox(
                    height: 16,
                  ),
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
            child: Text('Continue to Pay',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              Navigator.pushNamed(
                  context, RoutePaths.Booking_Appoinment_Done_View);
              debugPrint('Clicked On Proceed');
            },
          ),
        ),
      ],
    );
  }

  Widget _ammountFeild() {
    return Padding(
      padding: const EdgeInsets.only(left: 48, right: 48),
      child: TextFormField(
        controller: _ammountController,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (term) {
          //_fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
        },
        decoration: InputDecoration(
            hintText: 'Ammount',
            contentPadding: const EdgeInsets.only(left: 20, right: 20)),
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
      ),
    );
  }

  Widget _makePaymentMethodTile() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      color: colorF6F6FF,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              left: 48,
            ),
            child: Text('Select Payment Method',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 16)),
          ),
          SizedBox(
            height: 8,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 48,
                ),
                Container(
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: primaryLightColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                      child: Text(
                        'Debit/Credit\nCard',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    )),
                SizedBox(
                  width: 16,
                ),
                Container(
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: primaryLightColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                      child: Text(
                        'Paypal',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    )),
                SizedBox(
                  width: 16,
                ),
                Container(
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: primaryLightColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                      child: Text(
                        'PayTm',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    )),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _makeNewCardInputTile() {
    return Container(
      padding: const EdgeInsets.fromLTRB(48, 16, 48, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: primaryColor, width: 0.80),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              items: <String>['Card 1', 'Card 2', 'Card 3'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Card'),
              onChanged: (_) {},
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Text(
            'Name of the cardholder',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
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
                maxLines: 1,
                enabled: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  //_fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Card Number',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
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
                inputFormatters: [
                  MaskedTextInputFormatter(
                    mask: 'xxxx xxxx xxxx xxxx',
                    separator: ' ',
                  ),
                ],
                maxLines: 1,
                enabled: true,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (term) {
                  //_fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true)),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Expiry Date',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
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
                          inputFormatters: [
                            MaskedTextInputFormatter(
                              mask: 'MM/YY',
                              separator: '/',
                            ),
                          ],
                          maxLines: 1,
                          enabled: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            //_fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
                          },
                          decoration: InputDecoration(
                              hintText: 'MM/YY',
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Security Code (CVV)',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 3,
                          maxLines: 1,
                          enabled: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            //_fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
                          },
                          decoration: InputDecoration(
                              counterText: '',
                              hintText: 'CVV',
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
