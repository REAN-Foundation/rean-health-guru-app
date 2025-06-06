import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/nutrition/models/alcohol_consumption.dart';
import 'package:patient/features/common/nutrition/models/glass_of_water_consumption.dart';
import 'package:patient/features/common/nutrition/view_models/patients_health_marker.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/custom_tooltip.dart';

//ignore: must_be_immutable
class NutritionQuestionnaireView extends StatefulWidget {
  String? mode;

  NutritionQuestionnaireView(this.mode);

  @override
  _NutritionQuestionnaireViewState createState() =>
      _NutritionQuestionnaireViewState();
}

class _NutritionQuestionnaireViewState
    extends State<NutritionQuestionnaireView> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormat = DateFormat('yyyy-MM-dd');
  //final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  Color buttonColor = primaryLightColor;
  int vegetableServing = 0;
  int fruitServing = 0;
  int grainServing = 0;
  int meatServing = 0;
  int sugaryDrinkServing = 0;
  bool protienValue = false;
  String protienValueClicked = '';
  bool saltValue = false;
  String salthValueClicked = '';
  int waterGlass = 0;
  GlassOfWaterConsumption? glassOfWaterConsumption;
  int alcoholIntakeInMililitre = 0;
  AlcoholConsumption? _alcoholConsumption;
  DateTime? startDate;
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();

  @override
  void initState() {
    startDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    loadWaterConsuption();
    loadAlcohol();
    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }
    super.initState();
  }

  loadWaterConsuption() async {
    final waterConsuption = await _sharedPrefUtils.read('waterConsumption');

    if (waterConsuption != null) {
      glassOfWaterConsumption =
          GlassOfWaterConsumption.fromJson(waterConsuption);
    }

    if (glassOfWaterConsumption != null) {
      if (startDate == glassOfWaterConsumption!.date) {
        waterGlass = glassOfWaterConsumption!.count ?? 0;
      }
    }
    setState(() {});
  }

  loadAlcohol() async {
    final alcoholIntake = await _sharedPrefUtils.read('alcoholIntake');

    if (alcoholIntake != null) {
      _alcoholConsumption = AlcoholConsumption.fromJson(alcoholIntake);
    }

    if (_alcoholConsumption != null) {
      if (startDate == _alcoholConsumption!.date) {
        alcoholIntakeInMililitre = _alcoholConsumption!.count ?? 0;

      }
    }
    setState(() {});
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
              'Nutrition',
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
                          color: colorF5F5F5,
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
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    vegetable(),
                    SizedBox(
                      height: 8,
                    ),
                    fruit(),
                    SizedBox(
                      height: 8,
                    ),
                    grain(),
                    SizedBox(
                      height: 8,
                    ),
                    seaFood(),
                    SizedBox(
                      height: 8,
                    ),
                    sugaryDrink(),
                    SizedBox(
                      height: 8,
                    ),
                    water(),
                    SizedBox(
                      height: 8,
                    ),
                    alcohol(),
                    SizedBox(
                      height: 8,
                    ),
                    protein(),
                    SizedBox(
                      height: 8,
                    ),
                    salt(),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, bottom: 24, top: 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: ElevatedButton(
                onPressed: () {
                  bool isValueEnteredOrSelected = false;

                  if (vegetableServing > 0) {
                    isValueEnteredOrSelected = true;
                    recordMyCaloriesConsumed(
                        false, 'Vegetables', vegetableServing);
                  }
                  if (fruitServing > 0) {
                    isValueEnteredOrSelected = true;
                    recordMyCaloriesConsumed(false, 'Fruit', fruitServing);
                  }
                  if (grainServing > 0) {
                    isValueEnteredOrSelected = true;
                    recordMyCaloriesConsumed(false, 'Grains', grainServing);
                  }
                  if (meatServing > 0) {
                    isValueEnteredOrSelected = true;
                    recordMyCaloriesConsumed(false, 'Sea food', meatServing);
                  }
                  if (sugaryDrinkServing > 0) {
                    isValueEnteredOrSelected = true;
                    recordMyCaloriesConsumed(
                        false, 'Sugary drinks', sugaryDrinkServing);
                  }

                  if (protienValueClicked.isNotEmpty) {
                    isValueEnteredOrSelected = true;
                    recordMyCaloriesConsumed(protienValue, 'Protein', 0);
                  }

                  if (salthValueClicked.isNotEmpty) {
                    isValueEnteredOrSelected = true;
                    recordMyCaloriesConsumed(saltValue, 'Salt', 0);
                  }

                  if (isValueEnteredOrSelected) {
                    clearText();
                  } else {
                    showToast('Please select serving values', context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                )),
          ),
        )
      ],
    );
  }

  Widget vegetable() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    ImageIcon(
                      AssetImage('res/images/ic_vegetable.png'),
                      size: 32,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                          'How many servings of vegetables did you eat today?',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ),
                    SizedBox(width: 32,),

                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 56,
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    if (vegetableServing != 0) {
                                      vegetableServing = vegetableServing - 1;
                                      announceText('$vegetableServing Serving of vegetable');
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                    semanticLabel:
                                        'decrease vegetables serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            Semantics(
                              label: '$vegetableServing Servings of vegetable',
                              child: ExcludeSemantics(
                                child: Container(
                                  width: 180,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border:
                                        Border.all(color: colorD6D6D6, width: 0.80),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        vegetableServing == 0
                                            ? ''
                                            : vegetableServing.toString(),
                                        semanticsLabel: '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Servings',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    vegetableServing = vegetableServing + 1;
                                    setState(() {});
                                    announceText('$vegetableServing Servings of vegetable');
                                    debugPrint(
                                        "Vegetable Serving ==> $vegetableServing");
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    semanticLabel:
                                        'increase vegetables serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: CustomTooltip(
                  message: '1 serving = 1/2 cup.\n\nBell pepper: Half of a large \nBroccoli or cauliflower: 5 to 8 florets \nCarrot: 6 baby or 1 whole medium \nLeafy vegetable: 1 cup raw or ½ cup cooked \nPotato: Half of a medium \nZucchini: Half of a large.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,//Colors.grey.withOpacity(0.6),
                    semanticLabel: 'info',
                    size: 24,
                  ),
                ),)
          ],
        ),
      ),
    );
  }

  Widget fruit() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    ImageIcon(
                      AssetImage('res/images/ic_fruit.png'),
                      size: 32,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text('How many servings of fruit did you eat today?',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ),
                    SizedBox(width: 24,),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 56,
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    if (fruitServing != 0) {
                                      fruitServing = fruitServing - 1;
                                      announceText('$fruitServing Serving of fruits');
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                    semanticLabel:
                                        'decrease fruit serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            Semantics(
                              label: '$fruitServing Serving of fruits',
                              child: ExcludeSemantics(
                                child: Container(
                                  width: 180,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border:
                                        Border.all(color: colorD6D6D6, width: 0.80),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        fruitServing == 0
                                            ? ''
                                            : fruitServing.toString(),
                                        semanticsLabel: '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Servings',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    fruitServing = fruitServing + 1;
                                    announceText('$fruitServing Serving of fruits');
                                    setState(() {});
                                    debugPrint("Fruit Serving ==> $fruitServing");
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    semanticLabel:
                                        'increase fruit serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: CustomTooltip(
                  message: '1 serving = 1/2 cup. \n\nApple, pear, orange, peach or nectarine: 1 medium \nAvocado: Half of a medium \nBanana: 1 small \nGrape: 16 \nKiwifruit: 1 medium \nMelon: Half-inch thick wedge of sliced watermelon, honeydew, cantaloupe.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,//Colors.grey.withOpacity(0.6),
                    semanticLabel: 'info',
                    size: 24,
                  ),
                ),)
          ],
        ),
      ),
    );
  }

  Widget grain() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    ImageIcon(
                      AssetImage('res/images/ic_grain.png'),
                      size: 32,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                          'How many servings of whole grains did you eat today?',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ),
                    SizedBox(width: 24,),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 56,
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    if (grainServing != 0) {
                                      grainServing = grainServing - 1;
                                      announceText('$grainServing Serving of grains');
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                    semanticLabel:
                                        'decrease grain serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            Semantics(
                              label: '$grainServing Serving of grains',
                              child: ExcludeSemantics(
                                child: Container(
                                  width: 180,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border:
                                        Border.all(color: colorD6D6D6, width: 0.80),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        grainServing == 0
                                            ? ''
                                            : grainServing.toString(),
                                        semanticsLabel: '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Servings',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    grainServing = grainServing + 1;
                                    announceText('$grainServing Serving of grains');
                                    setState(() {});
                                    debugPrint("Grain Serving ==> $grainServing");
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    semanticLabel:
                                        'increase grain serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
                right: 0,
                top: 0,
                child: CustomTooltip(
                  message:
                  '1 serving = 1 slice whole-grain bread or 3/4 cup whole-grain pasta or cereal.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,//Colors.grey.withOpacity(0.6),
                    semanticLabel: 'info',
                    size: 24,
                  ),
                ),)
          ],
        ),
      ),
    );
  }

  Widget seaFood() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    ImageIcon(
                      AssetImage('res/images/ic_meat.png'),
                      size: 32,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                          'How many servings of fish or shellfish / seafood did you eat today?',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ),
                    SizedBox(width: 24,),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 56,
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    if (meatServing != 0) {
                                      meatServing = meatServing - 1;
                                      announceText('$meatServing Serving of Seafood');
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                    semanticLabel:
                                        'decrease sea food serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            Semantics(
                              label: '$meatServing Serving of Seafood',
                              child: ExcludeSemantics(
                                child: Container(
                                  width: 180,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border:
                                        Border.all(color: colorD6D6D6, width: 0.80),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        meatServing == 0
                                            ? ''
                                            : meatServing.toString(),
                                        semanticsLabel: '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Servings',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    meatServing = meatServing + 1;
                                    announceText('$meatServing Serving of Seafood');
                                    setState(() {});
                                    debugPrint("Meat Serving ==> $meatServing");
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    semanticLabel:
                                        'increase sea food serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: CustomTooltip(
                  message: '1 serving = 3 oz cooked, not fried.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,//Colors.grey.withOpacity(0.6),
                    semanticLabel: 'info',
                    size: 24,
                  ),
                ),)
          ],
        ),
      ),
    );
  }

  Widget sugaryDrink() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    ImageIcon(
                      AssetImage('res/images/ic_sugary_drink.png'),
                      size: 32,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                          'How many servings of sugary drinks did you drink today?',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ),
                    SizedBox(width: 28,),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 56,
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    if (sugaryDrinkServing != 0) {
                                      sugaryDrinkServing = sugaryDrinkServing - 1;
                                      announceText('$sugaryDrinkServing Serving of Sugary drinks');
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                    semanticLabel:
                                        'decrease sugary drink serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            Semantics(
                              label: '$sugaryDrinkServing Serving of Sugary drinks',
                              child: ExcludeSemantics(
                                child: Container(
                                  width: 180,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border:
                                        Border.all(color: colorD6D6D6, width: 0.80),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        sugaryDrinkServing == 0
                                            ? ''
                                            : sugaryDrinkServing.toString(),
                                        semanticsLabel: '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Servings',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: textGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    sugaryDrinkServing = sugaryDrinkServing + 1;
                                    announceText('$sugaryDrinkServing Serving of Sugary drinks');
                                    setState(() {});
                                    debugPrint(
                                        "Sugary Drink Serving Serving ==> $sugaryDrinkServing");
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    semanticLabel:
                                        'increase sugary drink serving quantity',
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: CustomTooltip(
                  message:
                  '1 serving = 12 oz; includes sports drinks, lemonade, fruit drinks with added sugar, energy drinks and soda, drinks with added sugar.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,//Colors.grey.withOpacity(0.6),
                    semanticLabel: 'info',
                    size: 24,
                  ),
                ),)
          ],
        ),
      ),
    );
  }

  Widget protein() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    ImageIcon(
                      AssetImage('res/images/ic_protein.png'),
                      size: 32,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                          'Did you select healthy sources of protein today?',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ),
                    SizedBox(width: 24,),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'Yes I had source of protein today',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              protienValue = true;
                              protienValueClicked = 'Yes';
                              setState(() {});
                            },
                            child: ExcludeSemantics(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    color: protienValueClicked == 'Yes'
                                        ? Color(0XFF007E1A)
                                        : buttonColor,
                                    size: 36,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text('Yes',
                                      style: TextStyle(
                                          color: protienValueClicked == 'Yes'
                                              ? Color(0XFF007E1A)
                                              : buttonColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: 'No I havn`t source of protein today',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              protienValue = false;
                              protienValueClicked = 'No';
                              setState(() {});
                            },
                            child: ExcludeSemantics(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thumb_down,
                                    color: protienValueClicked == 'No'
                                        ? primaryColor
                                        : buttonColor,
                                    size: 36,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text('No',
                                      style: TextStyle(
                                          color: protienValueClicked == 'No'
                                              ? primaryColor
                                              : buttonColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: CustomTooltip(
                  message:
                  'Legumes and nuts; fish and seafood; low-fat or nonfat dairy; unprocessed and lean poultry or meat.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,//Colors.grey.withOpacity(0.6),
                    semanticLabel: 'info',
                    size: 24,
                  ),
                ),)
          ],
        ),
      ),
    );
  }

  Widget salt() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    ImageIcon(
                      AssetImage('res/images/ic_salt.png'),
                      size: 32,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                          'Did you choose or prepare foods with little or no salt today?',
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat')),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'Yes I had salt in my food today',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              saltValue = true;
                              salthValueClicked = 'Yes';

                              setState(() {});
                            },
                            child: ExcludeSemantics(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    color: salthValueClicked == 'Yes'
                                        ? Color(0XFF007E1A)
                                        : buttonColor,
                                    size: 36,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text('Yes',
                                      style: TextStyle(
                                          color: salthValueClicked == 'Yes'
                                              ? Color(0XFF007E1A)
                                              : buttonColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: 'No I havn`t ate salty food today',
                          button: true,
                          child: InkWell(
                            onTap: () {
                              saltValue = false;
                              salthValueClicked = 'No';

                              setState(() {});
                            },
                            child: ExcludeSemantics(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thumb_down,
                                    color: salthValueClicked == 'No'
                                        ? primaryColor
                                        : buttonColor,
                                    size: 36,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text('No',
                                      style: TextStyle(
                                          color: salthValueClicked == 'No'
                                              ? primaryColor
                                              : buttonColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat')),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    /*Positioned(
                      bottom: 0,
                      right: 0,
                      child: CustomTooltip(
                        message: 'Legumes and nuts; fish and seafood; low-fat or nonfat dairy; unprocessed and lean poultry or meat',
                        child: Icon(
                          Icons.info_outline_rounded,
                        color: Colors.grey.withOpacity(0.6),,
                          semanticLabel: 'info',
                          size: 32,
                        ),
                      ),
                    )*/
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
            /*Positioned(
                top: 0,
                right: 0,
                child: )*/
          ],
        ),
      ),
    );
  }

  recordMyCaloriesConsumed(
      bool ateHealthyFood, String nutritionType, int servings) async {
    try {
      var list = [nutritionType];

      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['FoodTypes'] = list;
      map['UserResponse'] = ateHealthyFood;
      map['Servings'] = servings;

      final BaseResponse baseResponse =
          await model.recordMyCaloriesConsumed(map);
      if (baseResponse.status == 'success') {
        //showToast(baseResponse.message!, context);
      } else {}
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
    /*catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ==> ' + CustomException.toString());
    }*/
  }

  Widget water() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageIcon(
                    AssetImage('res/images/ic_glass_of_water.png'),
                    size: 24,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                      'Water',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ),
                CustomTooltip(
                  message: '1 glass = 8 ounces of water.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,//Colors.grey.withOpacity(0.6),
                    semanticLabel: 'info',
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 56,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                if (waterGlass != 0) {
                                  waterGlass = waterGlass - 1;
                                  announceText('$waterGlass glass of water');
                                  setState(() {});
                                  recordMyWaterConsumptions();
                                }
                              },
                              icon: Icon(
                                Icons.remove,
                                color: primaryColor,
                                semanticLabel:
                                'decrease water Glass quantity',
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: '$waterGlass glass of water',
                          child: ExcludeSemantics(
                            child: Container(
                              width: 180,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                border:
                                Border.all(color: colorD6D6D6, width: 0.80),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    waterGlass == 0
                                        ? ''
                                        : waterGlass.toString(),
                                    semanticsLabel: '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: textGrey),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    waterGlass > 1 ? 'glasses' : 'glass',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: textGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                waterGlass = waterGlass + 1;
                                announceText('$waterGlass glass of water');
                                setState(() {});
                                debugPrint(
                                    "waterGlass ==> $waterGlass");
                                recordMyWaterConsumptions();
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                Icons.add,
                                color: primaryColor,
                                semanticLabel:
                                'increase water Glass quantity',
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget alcohol() {
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 8,
                ),
                   ImageIcon(
                    AssetImage('res/images/ic_drink.png'),
                    size: 32,
                    color: primaryColor,
                  ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                      'Alcohol',
                      style: TextStyle(
                          color: textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat')),
                ),
                CustomTooltip(
                  message: 'One drink is 12 ounces of beer, 4 ounces of wine, 1.5 ounces of 80-proof spirits or 1 ounce of 100-proof spirit.',
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,//Colors.grey.withOpacity(0.6),
                    semanticLabel: 'info',
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 56,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                if (alcoholIntakeInMililitre != 0) {
                                  alcoholIntakeInMililitre = alcoholIntakeInMililitre - 1;
                                  announceText('$alcoholIntakeInMililitre driks of alcohol');
                                  setState(() {});
                                  recordMyAlcoholConsumption();
                                }
                              },
                              icon: Icon(
                                Icons.remove,
                                color: primaryColor,
                                semanticLabel:
                                'decrease alcohol drink quantity',
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          label: '$alcoholIntakeInMililitre driks of alcohol',
                          child: ExcludeSemantics(
                            child: Container(
                              width: 180,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                border:
                                Border.all(color: colorD6D6D6, width: 0.80),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    alcoholIntakeInMililitre == 0
                                        ? ''
                                        : alcoholIntakeInMililitre.toString(),
                                    semanticsLabel: '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: textGrey),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    alcoholIntakeInMililitre > 1 ? 'drinks' : 'drink',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: textGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                alcoholIntakeInMililitre = alcoholIntakeInMililitre + 1;
                                announceText('$alcoholIntakeInMililitre driks of alcohol');
                                setState(() {});
                                debugPrint(
                                    "alcoholIntakeInMililitre ==> $alcoholIntakeInMililitre");
                                recordMyAlcoholConsumption();
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                Icons.add,
                                color: primaryColor,
                                semanticLabel:
                                'increase alcohol drink quantity',
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  recordMyWaterConsumptions() async {
    try {
      _sharedPrefUtils.save('waterConsumption',
          GlassOfWaterConsumption(startDate, waterGlass, '').toJson());

      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Volume'] = waterGlass;
      map['Time'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMyWaterCount(map);
      if (baseResponse.status == 'success') {
      } else {}
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  recordMyAlcoholConsumption() async {
    try {
      recordMyMonitoringFoodConsumtion(
          'Alcohol', 'ml', alcoholIntakeInMililitre.toDouble());
      _sharedPrefUtils.save('alcoholIntake',
          AlcoholConsumption(startDate, alcoholIntakeInMililitre, '').toJson());
      //showToast("Alcohol intake added successfully", context);
      setState(() {});
      /* final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['Volume'] = waterGlass;
      map['Time'] = dateFormat.format(DateTime.now());

      final BaseResponse baseResponse = await model.recordMyWaterCount(map);
      if (baseResponse.status == 'success') {
      } else {}*/
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  recordMyMonitoringFoodConsumtion(
      String foodName, String unit, double amount) async {
    try {
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['MonitoredFoodComponent'] = foodName;
      map['Unit'] = unit;
      map['Amount'] = amount;

      final BaseResponse baseResponse =
      await model.recordMyMonitoringFoodConsumtion(map);
      if (baseResponse.status == 'success') {
        //showToast(baseResponse.message!, context);
      }
    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      showToast(e.toString(), context);
    }
    /*catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ==> ' + CustomException.toString());
    }*/
  }

  void clearText() {
    showSuccessToast('Food consumption record created successfully!', context);
    vegetableServing = 0;
    fruitServing = 0;
    grainServing = 0;
    meatServing = 0;
    sugaryDrinkServing = 0;
    protienValue = false;
    protienValueClicked = '';
    saltValue = false;
    salthValueClicked = '';
    setState(() {});
  }
}
