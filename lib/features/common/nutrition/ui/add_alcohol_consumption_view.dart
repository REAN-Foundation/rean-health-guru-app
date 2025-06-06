
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

//ignore: must_be_immutable
class AddAlcoholConsumptionView extends StatefulWidget {
  String? mode;
  late Function _submitButtonListner;

  AddAlcoholConsumptionView({
    Key? key,
    required Function submitButtonListner,
  }) : super(key: key) {
    _submitButtonListner = submitButtonListner;
  }

  @override
  _MyAddAlcoholViewState createState() => _MyAddAlcoholViewState();
}

class _MyAddAlcoholViewState extends State<AddAlcoholConsumptionView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String unit = 'cal';
  Color buttonColor = primaryLightColor;
  final _nutritionNameController = TextEditingController();
  final _nutritionNameFocus = FocusNode();

  @override
  void initState() {
    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientHealthMarkerViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: primaryColor,
              systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              title: Text(
                'Alcohol Intake',
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
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [textFeilds(), _submitButton()],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget textFeilds() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add your alcohol intake in ml',
            style: TextStyle(
                color: textBlack, fontWeight: FontWeight.w600, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: textGrey, width: 1),
                color: Colors.white),
            child: Semantics(
              label: 'Add your alcohol intake in Mili litre',
              //textField: true,
              //hint: 'Example Banana',
              child: TextFormField(
                  controller: _nutritionNameController,
                  focusNode: _nutritionNameFocus,
                  maxLines: 1,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (term) {},
                  /*inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[\\,|\\+|\\-]')),
                  ],*/
                  decoration: InputDecoration(
                      hintStyle:
                      TextStyle(fontSize: 14, color: Colors.grey[400]),
                      hintText: '5 ml',
                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            if (_nutritionNameController.text.trim().isEmpty) {
              showToastMsg("Please add alcohol intake", context);
            }
            /*else if (_consumedCaloriesController.text.isEmpty) {
              showToastMsg("Please enter calories", context);
            } else if (double.parse(
                    _consumedCaloriesController.text.toString()) >
                999) {
              showToastMsg("Please enter valid calories", context);
            } */
            else {
              widget._submitButtonListner(
                  _nutritionNameController.text.toString().trim());
            }
          },
          style: ButtonStyle(
              foregroundColor:
              WidgetStateProperty.all<Color>(primaryLightColor),
              backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: primaryColor)))),
          child: Text(
            '      Add       ',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
