import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/remainder/view_models/patients_remainder.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AddMyRemainderView extends StatefulWidget {
  @override
  _AddMyRemainderViewState createState() => _AddMyRemainderViewState();
}

class _AddMyRemainderViewState extends State<AddMyRemainderView> {
  var model = PatientRemainderViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormat = DateFormat('MMM dd, yyyy');
  var dateFormatStandard = DateFormat('yyyy-MM-dd');
  late ProgressDialog progressDialog;
  var frequencyValue = 'Once';
  var frequencyList = ['Once', 'Daily', 'Repeat', 'Weekly']; // //'All Weekday',
  var repeatUnit = ['Hour', 'Day', 'Month', 'Quarter', 'Year'];
  var endDateReuiredFrequencyList = ['Daily', 'Repeat', 'Weekly'];
  String displayStartDate = '';
  String displayEndDate = '';
  String startDate = '';
  String endDate = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  var noteController = TextEditingController();
  var durationController = TextEditingController();
  var intervalController = TextEditingController();
  var repeatValue = 'Hour';
  List<bool> weekdaysValues = List.filled(7, true);//[false, false, true, false, false, true, true];// //[false, true,true,false,true,false,false];
  String displayTime = '';

  @override
  void initState() {
    progressDialog = ProgressDialog(context: context);
    //model.setBusy(true);
    displayTime = selectedTime.hour.toString().padLeft(2, '0')+":"+selectedTime.minute.toString().padLeft(2, '0');
    startDate = dateFormatStandard.format(DateTime.now());
    endDate = dateFormatStandard.format(DateTime.now());
    displayStartDate = dateFormat.format(DateTime.now());
    displayEndDate = dateFormat.format(DateTime.now());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientRemainderViewModel?>(
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
              'Add Reminder',
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
                          color: Colors.white,
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


  Widget body(){
    return Scrollbar(
      thumbVisibility: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.start,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: <Widget>[
              noteTextFeild(),
              SizedBox(
                height: 24,
              ),
              selectReminderType(),
              frequencyValue == 'Weekly' ? weekdayList() : SizedBox(),
              frequencyValue == "Repeat" ? repeatAfter() : SizedBox(),
              SizedBox(
                height: 24,
              ),
              dateAndTime(),
              //frequencyValue == 'All Weekday' ? duration() : SizedBox(),

              SizedBox(
                height: 24,
              ),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectReminderType(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Frequency',
              style: TextStyle(
                  color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              '*',
              semanticsLabel: 'required',
              style: TextStyle(
                  color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 48,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Semantics(
                  label: 'Select frequency',
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: frequencyValue,
                    items: frequencyList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(frequencyValue),
                    onChanged: (data) {
                      FirebaseAnalytics.instance.logEvent(name: 'reminder_type_dropdown_selection', parameters: <String, dynamic>{
                        'type': data,
                      },);
                      debugPrint(data);
                      setState(() {
                        frequencyValue = data.toString();
                      });
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }

  Widget dateAndTime(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Start Date',
                          style: TextStyle(
                              color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '*',
                          semanticsLabel: 'required',
                          style: TextStyle(
                              color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Semantics(
                      label: 'Select start date format should be month, date, year ' + displayStartDate,
                      button: true,
                      hint: 'required',
                      child: GestureDetector(
                        child: ExcludeSemantics(
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
                                      displayStartDate,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal, fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Image.asset('res/images/ic_calender.png')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now().subtract(Duration(days: 0)),
                              onChanged: (date) {
                                debugPrint('change $date');
                              }, onConfirm: (date) {
                                setState(() {
                                  displayStartDate = dateFormat.format(date);
                                  startDate = dateFormatStandard.format(date);
                                });
                                debugPrint('displayStartDate $displayStartDate');
                                debugPrint('startDate formated $startDate');
                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                      ),
                    ),
                  ],
                ),),
            SizedBox(width: endDateReuiredFrequencyList.contains(frequencyValue) ? 8 : 0,),
            endDateReuiredFrequencyList.contains(frequencyValue) ?
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'End Date',
                        style: TextStyle(
                            color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '*',
                        semanticsLabel: 'required',
                        style: TextStyle(
                            color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Semantics(
                    label: 'Select end date format should be month, date, year ' + displayEndDate,
                    button: true,
                    hint: 'required',
                    child: GestureDetector(
                      child: ExcludeSemantics(
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
                                    displayEndDate,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal, fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Image.asset('res/images/ic_calender.png')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now().subtract(Duration(days: 0)),
                            onChanged: (date) {
                              debugPrint('change $date');
                            }, onConfirm: (date) {
                              setState(() {
                                displayEndDate = dateFormat.format(date);
                                endDate = dateFormatStandard.format(date);
                              });
                              debugPrint('displayEndDate $displayEndDate');
                              debugPrint('endDate formated $endDate');
                            }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    ),
                  ),
                ],
              ),) : SizedBox()
          ],
        ),
        SizedBox(height: 16,),
        Row(
          children: [
            Text(
              'Time',
              style: TextStyle(
                  color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              '*',
              semanticsLabel: 'required',
              style: TextStyle(
                  color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        SizedBox(height: 4,),
        Semantics(
          label: 'time format should be hour, minutes ' + displayTime,
          button: true,
          hint: 'required',
          child: GestureDetector(
            child: ExcludeSemantics(
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
                          selectedTime.hour.toString().padLeft(2, '0')+":"+selectedTime.minute.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                          height: 24,
                          width: 24,
                          child: Icon(Icons.access_time_sharp, color: Color(0XFF909CAC),)),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () async {
              final TimeOfDay? picked_s = await showTimePicker(
                  context: context,
                  initialTime: selectedTime);

              if (picked_s != null && picked_s != selectedTime )
                setState(() {
                  selectedTime = picked_s;
                  displayTime = selectedTime.hour.toString().padLeft(2, '0') + ':' + selectedTime.minute.toString().padLeft(2, '0');
                });
            },
          ),
        ),
      ],
    );
  }

  Widget noteTextFeild(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reminder Title',
              style: TextStyle(
                  color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
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
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                    minHeight: 100, minWidth: double.infinity, maxHeight: 400),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0XFF909CAC), width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.white),
                child: Semantics(
                  label: 'Event',
                  hint: 'required',
                  child: TextFormField(
                      controller: noteController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: primaryColor),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 14, top: 11, right: 0),
                      )),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
  
  Widget repeatAfter(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 6,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Repeat every',
                      style: TextStyle(
                          color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
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
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0XFF909CAC), width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Colors.white),
                        child: Semantics(
                          label: 'Interval',
                          child: TextFormField(
                              controller: intervalController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    color: primaryColor),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 14, top: 11, right: 0),
                              )),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
            SizedBox(width: 8,),
            Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Unit',
                          style: TextStyle(
                              color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '*',
                          semanticsLabel: 'required',
                          style: TextStyle(
                              color: Color(0XFFEB0C2D), fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Semantics(
                              label: 'Select your repeat frequency',
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: repeatValue,
                                items: repeatUnit.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: Text(repeatValue),
                                onChanged: (data) {
                                  FirebaseAnalytics.instance.logEvent(name: 'reminder_type_dropdown_selection', parameters: <String, dynamic>{
                                    'type': data,
                                  },);
                                  debugPrint(data);
                                  setState(() {
                                    repeatValue = data.toString();
                                  });
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                )
                ),
          ],
        ),
        //duration(),
      ],
    );
  }

  Widget duration(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  frequencyValue == "Weekly" ? "Number of Weeks" :'Ends after '+repeatValue.toLowerCase(),
                  style: TextStyle(
                      color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
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
              height: 4,
            ),
            Container(
              height: 48,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0XFF909CAC), width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Colors.white),
              child: Semantics(
                label: 'Duration',
                child: TextFormField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: primaryColor),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 14, top: 11, right: 0),
                    )),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget weekdayList(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Repeat On',
                  style: TextStyle(
                      color: textBlack, fontSize: 16, fontWeight: FontWeight.w700),
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
              height: 4,
            ),
            Semantics(
              label: 'select Weekday',
              child: WeekdaySelector(
                onChanged: (int day) {
                  setState(() {
                    // Use module % 7 as Sunday's index in the array is 0 and
                    // DateTime.sunday constant integer value is 7.
                    final index = day % 7;
                    // We "flip" the value in this example, but you may also
                    // perform validation, a DB write, an HTTP call or anything
                    // else before you actually flip the value,
                    // it's up to your app's needs.
                    weekdaysValues[index] = !weekdaysValues[index];
                    debugPrint("Weekday ==> $weekdaysValues");
                  });
                },
                values: weekdaysValues,
              ),
            )
          ],
        ),
        //duration(),
      ],
    );
  }

  Widget _submitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        model.busy
            ? Center(
          child: CircularProgressIndicator(),
        )
            : SizedBox(
          width: 160,
          height: 40,
          child: Semantics(
            label: 'Save',
            child:
            ElevatedButton(
                child: Text("Save",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(primaryLightColor),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(primaryColor),
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: primaryColor)))),
                onPressed: () {
                  validate();
                }),
          ),
        ),
      ],
    );
  }

  validate(){
    if(noteController.text.isEmpty || noteController.text.length <= 2){
      showToast("Please enter valid reminder title.", context);
    }else if(frequencyValue == null){
      showToast("Please choose a repeat option.", context);
    }else if(displayStartDate == ""){
      showToast("Please select a start date.", context);
    }else if(endDateReuiredFrequencyList.contains(frequencyValue) && displayEndDate == "" ){
      showToast("Please select a end date.", context);
    }else if(displayTime == ""){
      showToast("Please select a time.", context);
    }else if(frequencyValue == "Repeat" && intervalController.text.isEmpty) {
      showToast("Please enter a interval.", context);
    }else/* if(frequencyValue == "Repeat" && durationController.text.isEmpty) {
      showToast("Please enter a duration.", context);
    }else  if(frequencyValue == "Weekday" && durationController.text.isEmpty) {
      showToast("Please enter a duration.", context);
    }else*/{
        _addPatientremainder();
    }

  }

  _addPatientremainder() async {
    try {
      String path = '';
      List<String> selectedWeekdayList = [];

      if(frequencyValue == 'Once'){
        path = 'one-time';
      }else if(frequencyValue == 'Daily'){
        path = 'repeat-every-day';
      }else if(frequencyValue == 'Repeat'){
        path = 'repeat-after-every-n';
      }else if(frequencyValue == 'All Weekday'){
        path = 'repeat-every-weekday';
      }else if(frequencyValue == 'Weekly'){
        path = 'repeat-every-week-on-days';
        if(weekdaysValues.elementAt(0))
          selectedWeekdayList.add('Sunday');
        if(weekdaysValues.elementAt(1))
          selectedWeekdayList.add('Monday');
        if(weekdaysValues.elementAt(2))
          selectedWeekdayList.add('Tuesday');
        if(weekdaysValues.elementAt(3))
          selectedWeekdayList.add('Wednesday');
        if(weekdaysValues.elementAt(4))
          selectedWeekdayList.add('Thursday');
        if(weekdaysValues.elementAt(5))
          selectedWeekdayList.add('Friday');
        if(weekdaysValues.elementAt(6))
          selectedWeekdayList.add('Saturday');


        if(selectedWeekdayList.isEmpty)
          showToastMsg("Please select from weekdays", context);
      }


      final map = <String, dynamic>{};
      map['UserId'] = patientUserId;
      map['Name'] = noteController.text;
      map['WhenDate'] = startDate;
      map['StartDate'] = startDate;
      if(endDate.isNotEmpty) {
        map['EndDate'] = endDate;
      }
      if(endDate.isNotEmpty) {
        map['EndAfterNRepetitions'] = DateTime
            .parse(endDate)
            .difference(DateTime.parse(startDate))
            .inDays;
      }
      if(frequencyValue == 'Weekly'){
        map['RepeatList'] = selectedWeekdayList;
      }
      map['RepeatAfterEvery'] = intervalController.text;
      map['RepeatAfterEveryNUnit'] = repeatValue;
      if(durationController.text.isNotEmpty) {
        map['EndAfterNRepetitions'] = durationController.text;
      }
      map['WhenTime'] = displayTime+':00';
      //map['NotificationType'] = "SMS";
      map['NotificationType'] = "MobilePush";



      late BaseResponse baseResponse;

        FirebaseAnalytics.instance.logEvent(name: 'add_remainder_save_button_click');
        baseResponse = await model.addRemainder(
            map, path);
      if (baseResponse.status == 'success') {
          showSuccessToast(baseResponse.message.toString(), context);
          Navigator.of(context).pop();
      }else{
        showToastMsg(baseResponse.message!.replaceAll('Input validation errors: [\n  \"', '').replaceAll('\"\n]', '').toString(), context);
      }

    } on FetchDataException catch (e) {
      debugPrint('error caught: $e');
      model.setBusy(false);
      setState(() {});
      showToast(e.toString(), context);
    }
  }


}
