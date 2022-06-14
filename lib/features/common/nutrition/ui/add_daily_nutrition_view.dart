import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/db_utils/database_helper.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

//ignore: must_be_immutable
class AddDailyNutritionView extends StatefulWidget {
  String? mode;
  late Function _submitButtonListner;
  String? _nutritionName;

  AddDailyNutritionView({
    Key? key,
    required Function submitButtonListner,
    String? nutritionName,
  }) : super(key: key) {
    _submitButtonListner = submitButtonListner;
    _nutritionName = nutritionName;
  }

  @override
  _MyDailyNutritionViewState createState() => _MyDailyNutritionViewState();
}

class _MyDailyNutritionViewState extends State<AddDailyNutritionView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String unit = 'cal';
  Color buttonColor = primaryLightColor;
  final _nutritionNameController = TextEditingController();
  final _consumedCaloriesController = TextEditingController();
  final _nutritionNameFocus = FocusNode();
  final __consumedCaloriesFocus = FocusNode();
  final dbHelper = DatabaseHelper.instance;
  int allNutritionCount = 0;
  var nutritionList = <Map<String, dynamic>>[];
  int selectedIndex = 30000;
  var hintFoodName = '1 bowl of rice';
  var hintFoodCalories = '44 calories';

  getNutririonEntry() async {
    nutritionList = await dbHelper
        .querySelectOrderByConsumedQuantity(widget._nutritionName);
    print('Query row: ${nutritionList.length}');
    allNutritionCount = nutritionList.length;

    nutritionList.forEach((row) => print(row));

    setState(() {});
  }

  @override
  void initState() {
    if (widget._nutritionName == 'breakfast') {
      hintFoodName = '1 boiled egg';
      hintFoodCalories = '78 calories';
    } else if (widget._nutritionName == 'lunch') {
      hintFoodName = '1 bowl of rice';
      hintFoodCalories = '130 calories';
    } else if (widget._nutritionName == 'dinner') {
      hintFoodName = 'broccoli';
      hintFoodCalories = '45 calories';
    } else if (widget._nutritionName == 'snack') {
      hintFoodName = '1 bowl of vegetable salad';
      hintFoodCalories = '85 calories';
    }

    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }
    getNutririonEntry();
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
              brightness: Brightness.dark,
              title: Text(
                widget._nutritionName!.substring(0, 1).toUpperCase() +
                    widget._nutritionName!.substring(1),
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
                          children: [
                            textFeilds(),
                            SizedBox(
                              height: 16,
                            ),
                            allNutritionCount == 0
                                ? frequentlyUsedFoodListViewPlaceHoleder()
                                : frequentlyUsedFoodListView(),
                            selectedIndex != 30000
                                ? addBottomUIPart()
                                : Container(),
                            SizedBox(
                              height: 8,
                            ),
                            _submitButton()
                          ],
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

  Widget addBottomUIPart() {
    return _makeUndoListCard();
  }

  Widget textFeilds() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add your food',
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
              label: 'Add your food ',
              //textField: true,
              //hint: 'Example Banana',
              child: TextFormField(
                  controller: _nutritionNameController,
                  focusNode: _nutritionNameFocus,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (term) {
                    _fieldFocusChange(
                        context, _nutritionNameFocus, __consumedCaloriesFocus);
                  },
                  /*inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[\\,|\\+|\\-]')),
                  ],*/
                  decoration: InputDecoration(
                      hintStyle:
                          TextStyle(fontSize: 14, color: Colors.grey[400]),
                      hintText: hintFoodName,
                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true)),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                'Calories',
                style: TextStyle(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
              RichText(
                text: TextSpan(
                  text: ' (cal)',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: textBlack,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: textGrey, width: 1),
                      color: Colors.white),
                  child: Semantics(
                    label: 'Calories textfield',
                    child: TextFormField(
                        controller: _consumedCaloriesController,
                        focusNode: __consumedCaloriesFocus,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onFieldSubmitted: (term) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp('[\\,|\\+|\\-|\\ ]')),
                        ],
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 14, color: Colors.grey[400]),
                            hintText: hintFoodCalories,
                            contentPadding: EdgeInsets.all(0),
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _makeUndoListCard() {
    final row = nutritionList.elementAt(selectedIndex);
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(row[DatabaseHelper.columnNutritionFoodItemName],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              Semantics(
                label: "Undo",
                button: true,
                child: ExcludeSemantics(
                  child: InkWell(
                    onTap: () {
                      selectedIndex = 30000;
                      _nutritionNameController.text = '';
                      _nutritionNameController.selection =
                          TextSelection.fromPosition(
                        TextPosition(
                            offset: _nutritionNameController.text.length),
                      );

                      _consumedCaloriesController.text = '';
                      _consumedCaloriesController.selection =
                          TextSelection.fromPosition(
                        TextPosition(
                            offset: _consumedCaloriesController.text.length),
                      );

                      setState(() {});
                    },
                    child: Text('Undo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor)),
                  ),
                ),
              )
            ],
          )),
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
              showToastMsg("Please add your food", context);
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
                  _nutritionNameController.text.toString().trim(),
                  _consumedCaloriesController.text == ''
                      ? 0.0
                      : double.parse(_consumedCaloriesController.text),
                  widget._nutritionName);
            }
          },
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all<Color>(primaryLightColor),
              backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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

  Widget frequentlyUsedFoodListViewPlaceHoleder() {
    return Expanded(
        child: ExcludeSemantics(
      child: Center(
        child: Image.asset(
          'res/images/ic_nutition_dummy.png',
          height: 160,
          width: 160,
        ),
      ),
    ));
  }

  Widget frequentlyUsedFoodListView() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily ' + widget._nutritionName! + ' food',
            style: TextStyle(
                color: textBlack, fontWeight: FontWeight.w600, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    _makeFoodListCard(context, index),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 4,
                  );
                },
                itemCount: allNutritionCount,
                scrollDirection: Axis.vertical,
                shrinkWrap: true),
          ),
        ],
      ),
    );
  }

  Widget _makeFoodListCard(BuildContext context, int index) {
    final row = nutritionList.elementAt(index);

    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Text(row[DatabaseHelper.columnNutritionFoodItemName],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),

                  /* SizedBox(
                    height: 4,
                  ),
                  Text(
                    '',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: textGrey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),*/
                ],
              ),
            ),
            Semantics(
              label: row[DatabaseHelper.columnNutritionFoodItemCalories]
                      .toString() +
                  ' Calories',
              child: ExcludeSemantics(
                child: Row(
                  children: [
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      row[DatabaseHelper.columnNutritionFoodItemCalories]
                          .toString(),
                      semanticsLabel: '',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'cals',
                      semanticsLabel: 'cals',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                  color: index == selectedIndex ? Colors.green : buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Center(
                child: IconButton(
                  onPressed: () async {
                    selectedIndex = index;
                    _nutritionNameController.text =
                        row[DatabaseHelper.columnNutritionFoodItemName];
                    _nutritionNameController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                          offset: _nutritionNameController.text.length),
                    );

                    _consumedCaloriesController.text =
                        row[DatabaseHelper.columnNutritionFoodItemCalories]
                            .toString();
                    _consumedCaloriesController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                          offset: _consumedCaloriesController.text.length),
                    );

                    setState(() {});
                  },
                  icon: Icon(
                    index == selectedIndex ? Icons.check : Icons.add,
                    color: index == selectedIndex ? Colors.white : primaryColor,
                    semanticLabel: 'Add ' +
                        row[DatabaseHelper.columnNutritionFoodItemName] +
                        ' in food name',
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
