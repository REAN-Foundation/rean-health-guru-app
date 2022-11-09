import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/vitals/models/get_my_vitals_history.dart';
import 'package:patient/features/common/vitals/view_models/patients_vitals.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/get_health_data.dart';
import 'package:patient/infra/utils/simple_time_series_chart.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

//ignore: must_be_immutable
class BiometricBloodPresureVitalsView extends StatefulWidget {
  bool allUIViewsVisible = false;

  BiometricBloodPresureVitalsView(bool allUIViewsVisible) {
    this.allUIViewsVisible = allUIViewsVisible;
  }

  @override
  _BiometricBloodPresureVitalsViewState createState() =>
      _BiometricBloodPresureVitalsViewState();
}

class _BiometricBloodPresureVitalsViewState
    extends State<BiometricBloodPresureVitalsView> {
  var model = PatientVitalsViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  List<Items> records = <Items>[];
  var dateFormatStandard = DateFormat('MMM dd, yyyy');
  final _systolicFocus = FocusNode();
  final _diastolicFocus = FocusNode();
  GetHealthData getHealthData = GetIt.instance<GetHealthData>();
  int sytolicBloodPressure = 0;
  int diastolicBloodPressure = 0;

  late ProgressDialog progressDialog;

  @override
  void initState() {
    getVitalsHistory();
    getVitalsFromDevice();
    super.initState();
  }

  getVitalsFromDevice() {
    if (getHealthData.getBPDiastolic() != '0.0') {
      _diastolicController.text = getHealthData.getBPDiastolic();
      _diastolicController.selection = TextSelection.fromPosition(
        TextPosition(offset: _diastolicController.text.length),
      );
    }

    if (getHealthData.getBPSystolic() != '0.0') {
      _systolicController.text = getHealthData.getBPSystolic();
      _systolicController.selection = TextSelection.fromPosition(
        TextPosition(offset: _systolicController.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientVitalsViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: widget.allUIViewsVisible
            ? Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  title: Text(
                    'Blood Pressure',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                  iconTheme: IconThemeData(color: Colors.black),
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
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        bloodPresureFeilds(),
                        if (records.isEmpty) Container() else bpScale(),
                        if (records.isEmpty) Container() else _systolicgraph(),
                        const SizedBox(
                          height: 16,
                        ),
                        if (records.isEmpty) Container() else _diastolicgraph(),
                        //allGoal(),
                        const SizedBox(
                          height: 16,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        historyListFeilds(),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    /*bloodPresureFeilds(),
                    const SizedBox(height: 16,),*/
                    if (records.isEmpty) Container() else _systolicgraph(),
                    const SizedBox(
                      height: 16,
                    ),
                    if (records.isEmpty) Container() else _diastolicgraph(),
                    const SizedBox(
                      height: 16,
                    ),
                    historyListFeilds(),
                    //allGoal(),
                    //const SizedBox(height: 16,),
                  ],
                ),
              ),
      ),
    );
  }

  Widget bloodPresureFeilds() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enter your blood pressure:',
                  style: TextStyle(
                      color: textBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InfoScreen(
                      tittle: 'Blood Pressure Information',
                      description:
                          'If your blood pressure is below 120/80 mm Hg, be sure to get it checked at least once every two years, starting at age 20. If your blood pressure is higher, your doctor may want to check it more often. High blood pressure can be controlled through lifestyle changes and/or medication. \n*Normal: Less than 120/80 \n*Elevated: Systolic 120-129 AND Diastolic less than 80 \n*High Blood Pressure Stage 1: Systolic 130-139 OR Diastolic 80-89 \n*High Blood Pressure Stage 2: Systolic 140+ OR Diastolic 90+ \n*Hypertensive Crisis (Consult your doctor immediately): Systolic 180+ and/or Diastolic 120+',
                      height: 408),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Systolic',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: textBlack,
                          fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  mm Hg     ',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: textBlack,
                                fontFamily: 'Montserrat',
                                fontStyle: FontStyle.italic)),
                      ]),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Systolic measures in mm Hg',
                      child: TextFormField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          controller: _systolicController,
                          focusNode: _systolicFocus,
                          maxLines: 1,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _systolicFocus, _diastolicFocus);
                          },
                          decoration: InputDecoration(
                              //hintText: '(80 to 120)',
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Diastolic',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          color: textBlack,
                          fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  mm Hg  ',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: textBlack,
                                fontFamily: 'Montserrat',
                                fontStyle: FontStyle.italic)),
                      ]),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: textGrey, width: 1),
                        color: Colors.white),
                    child: Semantics(
                      label: 'Diastolic measures in mm Hg',
                      child: TextFormField(
                          controller: _diastolicController,
                          focusNode: _diastolicFocus,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (term) {
                            /*_fieldFocusChange(
                              context,
                              _diastolicFocus,
                              _weightFocus);*/
                          },
                          decoration: InputDecoration(
                            //hintText: '(60 to 80)',
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                model.busy ? CircularProgressIndicator() :Semantics(
                  label: "Save",
                  button: true,
                  child: InkWell(
                    onTap: () {
                      if (_systolicController.text.toString().isEmpty) {
                        showToast('Please enter your systolic blood pressure',
                            context);
                      } else if (_diastolicController.text.toString().isEmpty) {
                        showToast('Please enter your diastolic blood pressure',
                            context);
                      } else {
                        addvitals();
                      }
                    },
                    child: ExcludeSemantics(
                      child: Container(
                          height: 40,
                          width: 120,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            border: Border.all(color: primaryColor, width: 1),
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  /*oldLogic(){
    int bmiLeftSideValue = 0;
    int bmiRightSideValue = 0;
    String value = '';
    Color valeTextColor = textBlack;

    if(sytolicBloodPressure <= 119 && diastolicBloodPressure <= 80){
      bmiLeftSideValue = 2;
      bmiRightSideValue = 28;
      debugPrint('Normal BP');
      value = 'Normal';
      valeTextColor = Color(0XFFA6CE39);
    }else if((sytolicBloodPressure >= 120 && sytolicBloodPressure <= 129) && diastolicBloodPressure <= 80){
      bmiLeftSideValue = 9;
      bmiRightSideValue = 23;
      debugPrint('Elevated BP');
      value = 'Elevated';
      valeTextColor = Color(0XFFFBED4F);
    }else if(sytolicBloodPressure >= 130 && sytolicBloodPressure <= 139 *//*|| (diastolicBloodPressure >= 81 && diastolicBloodPressure <= 89)*//*){
      bmiLeftSideValue = 17;
      bmiRightSideValue = 17;
      debugPrint('Stage 1 BP');
      value = 'Stage 1';
      valeTextColor = Color(0XFFFBB601);
    }else if(sytolicBloodPressure >= 140 && sytolicBloodPressure <= 180 *//*|| (diastolicBloodPressure >= 90 && diastolicBloodPressure <= 120)*//*){
      bmiLeftSideValue = 23;
      bmiRightSideValue = 9;
      debugPrint('Stage 2 BP');
      value = 'Stage 2';
      valeTextColor = Color(0XFFBA3903);
    }else if(sytolicBloodPressure > 180 *//*&& diastolicBloodPressure > 120*//*){
      bmiLeftSideValue = 28;
      bmiRightSideValue = 2;
      debugPrint('Crisis BP');
      value = 'Crisis';
      valeTextColor = Color(0XFF991112);
    }
  }*/


  Widget bpScale(){
    int bmiLeftSideValue = 0;
    int bmiRightSideValue = 0;
    String value = '';
    Color valeTextColor = textBlack;
    debugPrint('BP Systolic Value ==> $sytolicBloodPressure BP Diastolic Value ==> $diastolicBloodPressure');
    /*if (bmiValue != 0.0) {
      bmiLeftSideValue = int.parse(bmiValue.toStringAsFixed(0)) - 1;
      bmiRightSideValue = (60 - int.parse(bmiValue.toStringAsFixed(0))) - 1;
    }*/

    if(sytolicBloodPressure <= 119 ){
      bmiLeftSideValue = 2;
      bmiRightSideValue = 28;
      debugPrint('Normal BP');
      value = 'Normal';
      valeTextColor = Color(0XFFA6CE39);

      if(diastolicBloodPressure < 80){
        bmiLeftSideValue = 2;
        bmiRightSideValue = 28;
        debugPrint('Diastolic Normal BP');
        value = 'Normal';
        valeTextColor = Color(0XFFA6CE39);
      }else if(diastolicBloodPressure < 80){
        bmiLeftSideValue = 9;
        bmiRightSideValue = 23;
        debugPrint('Diastolic Elevated BP');
        value = 'Elevated';
        valeTextColor = Color(0XFFFBED4F);
      }else if(diastolicBloodPressure >= 80 && diastolicBloodPressure <= 89){
        bmiLeftSideValue = 17;
        bmiRightSideValue = 17;
        debugPrint('Diastolic Stage 1 BP');
        value = 'Stage 1';
        valeTextColor = Color(0XFFFBB601);
      }else if(diastolicBloodPressure >= 90 && diastolicBloodPressure <= 120){
        bmiLeftSideValue = 23;
        bmiRightSideValue = 9;
        debugPrint('Diastolic Stage 2 BP');
        value = 'Stage 2';
        valeTextColor = Color(0XFFBA3903);
      }else if(diastolicBloodPressure > 120){
        bmiLeftSideValue = 28;
        bmiRightSideValue = 2;
        debugPrint('Diastolic Crisis BP');
        value = 'Crisis';
        valeTextColor = Color(0XFF991112);
      }

    }else if(sytolicBloodPressure >= 120 && sytolicBloodPressure <= 129 /*&& diastolicBloodPressure <= 80*/){
      bmiLeftSideValue = 9;
      bmiRightSideValue = 23;
      debugPrint('Elevated BP');
      value = 'Elevated';
      valeTextColor = Color(0XFFFBED4F);
      if(diastolicBloodPressure < 80){
        bmiLeftSideValue = 9;
        bmiRightSideValue = 23;
        debugPrint('Diastolic Elevated BP');
        value = 'Elevated';
        valeTextColor = Color(0XFFFBED4F);
      }else if(diastolicBloodPressure >= 80 && diastolicBloodPressure <= 89){
        bmiLeftSideValue = 17;
        bmiRightSideValue = 17;
        debugPrint('Diastolic Stage 1 BP');
        value = 'Stage 1';
        valeTextColor = Color(0XFFFBB601);
      }else if(diastolicBloodPressure >= 90 && diastolicBloodPressure <= 120){
        bmiLeftSideValue = 23;
        bmiRightSideValue = 9;
        debugPrint('Diastolic Stage 2 BP');
        value = 'Stage 2';
        valeTextColor = Color(0XFFBA3903);
      }else if(diastolicBloodPressure > 120){
        bmiLeftSideValue = 28;
        bmiRightSideValue = 2;
        debugPrint('Diastolic Crisis BP');
        value = 'Crisis';
        valeTextColor = Color(0XFF991112);
      }
    }else if(sytolicBloodPressure >= 130 && sytolicBloodPressure <= 139 /*|| (diastolicBloodPressure >= 81 && diastolicBloodPressure <= 89)*/){
      bmiLeftSideValue = 17;
      bmiRightSideValue = 17;
      debugPrint('Stage 1 BP');
      value = 'Stage 1';
      valeTextColor = Color(0XFFFBB601);
      if(diastolicBloodPressure >= 80 && diastolicBloodPressure <= 89){
        bmiLeftSideValue = 17;
        bmiRightSideValue = 17;
        debugPrint('Diastolic Stage 1 BP');
        value = 'Stage 1';
        valeTextColor = Color(0XFFFBB601);
      }else if(diastolicBloodPressure >= 90 && diastolicBloodPressure <= 120){
        bmiLeftSideValue = 23;
        bmiRightSideValue = 9;
        debugPrint('Diastolic Stage 2 BP');
        value = 'Stage 2';
        valeTextColor = Color(0XFFBA3903);
      }else if(diastolicBloodPressure > 120){
        bmiLeftSideValue = 28;
        bmiRightSideValue = 2;
        debugPrint('Diastolic Crisis BP');
        value = 'Crisis';
        valeTextColor = Color(0XFF991112);
      }
    }else if(sytolicBloodPressure >= 140 && sytolicBloodPressure <= 180 /*|| (diastolicBloodPressure >= 90 && diastolicBloodPressure <= 120)*/){
      bmiLeftSideValue = 23;
      bmiRightSideValue = 9;
      debugPrint('Stage 2 BP');
      value = 'Stage 2';
      valeTextColor = Color(0XFFBA3903);
      if(diastolicBloodPressure >= 90 && diastolicBloodPressure <= 120){
        bmiLeftSideValue = 23;
        bmiRightSideValue = 9;
        debugPrint('Diastolic Stage 2 BP');
        value = 'Stage 2';
        valeTextColor = Color(0XFFBA3903);
      }else if(diastolicBloodPressure > 120){
        bmiLeftSideValue = 28;
        bmiRightSideValue = 2;
        debugPrint('Diastolic Crisis BP');
        value = 'Crisis';
        valeTextColor = Color(0XFF991112);
      }
    }else if(sytolicBloodPressure > 180 /*&& diastolicBloodPressure > 120*/){
      bmiLeftSideValue = 28;
      bmiRightSideValue = 2;
      debugPrint('Crisis BP');
      value = 'Crisis';
      valeTextColor = Color(0XFF991112);
      /*if(diastolicBloodPressure <= 80){
        bmiLeftSideValue = 2;
        bmiRightSideValue = 28;
        debugPrint('Diastolic Normal BP');
        value = 'Normal';
        valeTextColor = Color(0XFFA6CE39);
      }else if(diastolicBloodPressure <= 80){
        bmiLeftSideValue = 9;
        bmiRightSideValue = 23;
        debugPrint('Diastolic Elevated BP');
        value = 'Elevated';
        valeTextColor = Color(0XFFFBED4F);
      }else if(diastolicBloodPressure >= 80 && diastolicBloodPressure <= 89){
        bmiLeftSideValue = 17;
        bmiRightSideValue = 17;
        debugPrint('Diastolic Stage 1 BP');
        value = 'Stage 1';
        valeTextColor = Color(0XFFFBB601);
      }else if(diastolicBloodPressure >= 90 && diastolicBloodPressure <= 120){
        bmiLeftSideValue = 23;
        bmiRightSideValue = 9;
        debugPrint('Diastolic Stage 2 BP');
        value = 'Stage 2';
        valeTextColor = Color(0XFFBA3903);
      }else{
        bmiLeftSideValue = 28;
        bmiRightSideValue = 2;
        debugPrint('Diastolic Crisis BP');
        value = 'Crisis';
        valeTextColor = Color(0XFF991112);
      }*/
    }
    announceText('Your recent Blood Pressure is $value');

      return Card(
      semanticContainer: false,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage('res/images/ic_blood_pressure.png'),
                      size: 24,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Blood Pressure Category',
                      semanticsLabel: 'BLOOD PRESSURE CATEGORY',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: primaryColor),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  semanticsLabel: value,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: valeTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            value != '' ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: bmiLeftSideValue, child: Container()),
                        Expanded(
                            flex: 1,
                            child: ImageIcon(
                                AssetImage('res/images/triangle.png'),
                            )),
                        Expanded(flex: bmiRightSideValue, child: Container())
                      ],
                    ),
                  ) : Container(),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'res/images/blood_presure_scale.png',
                        semanticLabel: 'Blood Pressure scale',
                      )),
                  SizedBox(height: 16,),
                ],
              )
      )
    );

  }

  Widget historyListFeilds() {
    return Container(
      color: colorF6F6FF,
      constraints: BoxConstraints(
          minHeight: 160, minWidth: double.infinity, maxHeight: 200),
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16, bottom: 16),
      height: 160,
      child: model.busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (records.isEmpty
              ? noHistoryFound()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Date',
                              semanticsLabel: 'Date',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                'Systolic\n(mm Hg)',
                                semanticsLabel: 'Systolic\n(mm Hg)',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                'Diastolic\n(mm Hg)',
                                semanticsLabel: 'Diastolic\n(mm Hg)',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ExcludeSemantics(
                              child: SizedBox(
                                height: 32,
                                width: 32,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Scrollbar(
                          isAlwaysShown: true,
                          controller: _scrollController,
                          child: ListView.separated(
                              itemBuilder: (context, index) =>
                                  _makeWeightList(context, index),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 0,
                                );
                              },
                              itemCount: records.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }

  Widget noHistoryFound() {
    return Center(
      child: Text('No vital history found',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget _makeWeightList(BuildContext context, int index) {
    final Items record = records.elementAt(index);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Card(
        semanticContainer: false,
        elevation: 0,
        child: Container(
          color: colorF6F6FF,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  dateFormatStandard.format(DateTime.parse(record.recordDate!)),
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Semantics(
                    label: 'Systolic Blood Pressure ',
                    child: Text(
                      record.systolic.toString() + ' ',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Semantics(
                    label: 'Diastolic Blood Pressure ',
                    child: Text(
                      record.diastolic.toString(),
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    ConfirmationBottomSheet(
                        context: context,
                        height: 180,
                        onPositiveButtonClickListner: () {
                          //debugPrint('Positive Button Click');
                          deleteVitals(record.id.toString());
                        },
                        onNegativeButtonClickListner: () {
                          //debugPrint('Negative Button Click');
                        },
                        question:
                            'Are you sure you want to delete this record?',
                        tittle: 'Alert!');
                  },
                  icon: Icon(
                    Icons.delete_rounded,
                    color: primaryColor,
                    size: 24,
                    semanticLabel: 'Blood Pressure Delete',
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _systolicgraph() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Semantics(
        label: 'making graph of ',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [primaryLightColor, colorF6F6FF]),
                  border: Border.all(color: primaryLightColor),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              padding: const EdgeInsets.all(16),
              height: 200,
              child: Center(
                child: SimpleTimeSeriesChart(_createSampleDatasystolic()),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Systolic Blood Pressure',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleDatasystolic() {
    final List<TimeSeriesSales> data = <TimeSeriesSales>[];
    /*[
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];*/

    for (int i = 0; i < records.length; i++) {
      data.add(TimeSeriesSales(
          DateTime.parse(records.elementAt(i).recordDate!).toLocal(),
          double.parse(records.elementAt(i).systolic.toString())));
    }

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'BPS',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  Widget _diastolicgraph() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Semantics(
        label: 'making graph of ',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [primaryLightColor, colorF6F6FF]),
                  border: Border.all(color: primaryLightColor),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              padding: const EdgeInsets.all(16),
              height: 200,
              child: Center(
                child: SimpleTimeSeriesChart(_createSampleDataDiastolic()),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Diastolic Blood Pressure',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleDataDiastolic() {
    final List<TimeSeriesSales> data = <TimeSeriesSales>[];
    /*[
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];*/

    for (int i = 0; i < records.length; i++) {
      data.add(TimeSeriesSales(
          DateTime.parse(records.elementAt(i).recordDate!).toLocal(),
          double.parse(records.elementAt(i).diastolic.toString())));
    }

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'BPD',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  Widget allGoal() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Container(
            height: 60,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16,),
                ImageIcon(
                  AssetImage('res/images/ic_dart_goal.png'),
                  size: 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 8,),
                Text(
                  "Your progress with goals",
                  style: TextStyle( color: Colors.white,fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16,),*/
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Systolic',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Diastolic ',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Initial',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '160',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '100',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Target',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '130',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '80',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Latest',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '140',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '90',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Systolic',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    height: 10,
                    color: primaryColor,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 10,
                    color: primaryLightColor,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Diastolic',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 10,
                    color: primaryColor,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 10,
                    color: primaryLightColor,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  addvitals() async {
    try {
      //progressDialog.show(max: 100, msg: 'Loading...');
      final map = <String, dynamic>{};
      map['Systolic'] = _systolicController.text.toString();
      map['Diastolic'] = _diastolicController.text.toString();
      map['PatientUserId'] = "";
      map['Unit'] = "mmHg";
      //map['RecordedByUserId'] = null;

      final BaseResponse baseResponse =
          await model.addMyVitals('blood-pressures', map);
      progressDialog.close();
      if (baseResponse.status == 'success') {
        if(progressDialog.isOpen()) {
          progressDialog.close();
        }
        showToast(baseResponse.message!, context);
        _systolicController.clear();
        _diastolicController.clear();
        //Navigator.pop(context);
        getVitalsHistory();
        model.setBusy(true);
      } else {
        progressDialog.close();
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  deleteVitals(String recordId) async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');

      final BaseResponse baseResponse =
          await model.deleteVitalsRecord('blood-pressures', recordId);

      if (baseResponse.status == 'success') {
        if (progressDialog.isOpen()) {
          progressDialog.close();
        }
        showToast(baseResponse.message!, context);
        //Navigator.pop(context);
        getVitalsHistory();
        model.setBusy(true);
      } else {
        progressDialog.close();
        showToast(baseResponse.message!, context);
      }
    } catch (e) {
      progressDialog.close();
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }

  getVitalsHistory() async {
    try {
      final GetMyVitalsHistory getMyVitalsHistory =
          await model.getMyVitalsHistory('blood-pressures');
      if (getMyVitalsHistory.status == 'success') {
        model.setBusy(false);
        records.clear();
        records.addAll(getMyVitalsHistory.data!.bloodPressureRecords!.items!);
        if(records.isNotEmpty){
          debugPrint('BP Systolic Value ==> $sytolicBloodPressure BP Diastolic Value ==> $diastolicBloodPressure');
          sytolicBloodPressure = int.parse(records.elementAt(0).systolic.toString());
          diastolicBloodPressure = int.parse(records.elementAt(0).diastolic.toString());
          setState(() {

          });
        }

      } else {
        showToast(getMyVitalsHistory.message!, context);
      }
    } catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
