import 'package:date_util/date_util.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/CheckConflictResponse.dart';
import 'package:paitent/core/models/DoctorBookingAppoinmentPojo.dart';
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/dateStripData.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/getAvailableDoctorSlot.dart';
import 'package:paitent/core/models/time_slot.dart';
import 'package:paitent/core/models/user_data.dart';
import 'package:paitent/core/viewmodels/views/appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/login_view_model.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/shared/text_styles.dart';
import 'package:paitent/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:paitent/ui/views/doctorTileWidget.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';
import 'package:paitent/widgets/app_drawer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'base_widget.dart';

class DateAndTimeForBookAppoinmentView extends StatefulWidget {
  Doctors doctorDetails;

  DateAndTimeForBookAppoinmentView(@required this.doctorDetails);

  @override
  _DateAndTimeForBookAppoinmentViewState createState() =>
      _DateAndTimeForBookAppoinmentViewState(doctorDetails);
}

class _DateAndTimeForBookAppoinmentViewState
    extends State<DateAndTimeForBookAppoinmentView> {
  SharedPrefUtils _sharedPrefUtils = new SharedPrefUtils();
  String name = "";
  var value;
  List<Slots> timeSlot = new List();
  List<Slots> timeSlotAm = new List();
  List<Slots> timeSlotPm = new List();
  List _myActivities;
  String _myActivitiesResult;

  DateTime selectedMonth;
  DateTime userSelectedDate;
  bool isAmSelected = true;
  Doctors doctorDetails;
  List<String> dayLabels = ["Mon", "Tue", "Wed", "Thr", "Fri", "Sat", "Sun"];
  String auth = "";
  var model = new BookAppoinmentViewModel();
  String startTime = "";
  String endTime = "";
  _DateAndTimeForBookAppoinmentViewState(@required this.doctorDetails);
  var dateFormat = DateFormat("yyyy-MM-dd");
  var timeFormat = DateFormat("hh:mm a");
  List<Slots> timeSlots = new List<Slots>();
  var bookingAppoinmentsDetails = DoctorBookingAppoinmentPojo();
  ProgressDialog progressDialog;

  loadSharedPrefs() async {
    try {
      UserData user = UserData.fromJson(await _sharedPrefUtils.read("user"));
      //debugPrint(user.toJson().toString());
      Patient patient = Patient.fromJson(await _sharedPrefUtils.read("patientDetails"));
      bookingAppoinmentsDetails.patient = patient;
      bookingAppoinmentsDetails.userData = user;
      auth = user.data.accessToken;
      getAvailableDoctorSlot();
      setState(() {
        name = user.data.user.firstName;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  getAvailableDoctorSlot() async {
    try {
      GetAvailableDoctorSlot getAvailableDoctorSlot = await model.getAvailableDoctorSlot(doctorDetails.userId.toString(), dateFormat.format(userSelectedDate),dateFormat.format(userSelectedDate), 'Bearer '+auth);

      if (getAvailableDoctorSlot.status == 'success') {
        timeSlot.clear();
        timeSlots.clear();
        timeSlotAm.clear();
        timeSlotPm.clear();

        if(getAvailableDoctorSlot.data.slotsByDate.length!=0) {
          timeSlot.addAll(getAvailableDoctorSlot.data.slotsByDate
              .elementAt(0)
              .slots);

          for(int i = 0 ; i < timeSlot.length ; i++){
            print(DateFormat.jm().format(timeSlot.elementAt(i).slotStart.toLocal()));
            if(DateFormat.jm().format(timeSlot.elementAt(i).slotStart.toLocal()).contains("AM")){
              timeSlotAm.add(timeSlot.elementAt(i));
            }else{
              timeSlotPm.add(timeSlot.elementAt(i));
            }
          }
          print("Am ${timeSlotAm.length}  PM ${timeSlotPm.length}");
        }
      } else {
        showToast(getAvailableDoctorSlot.message);
      }

    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error "+CustomException.toString());
    } catch (Exception){
      debugPrint(Exception.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedMonth = new DateTime(new DateTime.now().year, DateTime.now().month);
    debugPrint(selectedMonth.toIso8601String());
    //prepareData();
    _dateAndTimeCalculation();
    _myActivities = [];
    _myActivitiesResult = '';
    loadSharedPrefs();
  }

  /*void prepareData() {
    TimeSlot slot0 = new TimeSlot(
        id: 1, title: '9.00', isSelected: false, isAvaliable: true);
    TimeSlot slot01 = new TimeSlot(
        id: 1, title: '9.30', isSelected: false, isAvaliable: false);
    TimeSlot slot1 = new TimeSlot(
        id: 1, title: '10.00', isSelected: false, isAvaliable: true);
    TimeSlot slot2 = new TimeSlot(
        id: 1, title: '10.30', isSelected: false, isAvaliable: false);
    TimeSlot slot3 = new TimeSlot(
        id: 1, title: '11.00', isSelected: false, isAvaliable: true);
    TimeSlot slot4 = new TimeSlot(
        id: 1, title: '11.30', isSelected: false, isAvaliable: true);

    TimeSlot slot5 = new TimeSlot(
        id: 1, title: '12.00', isSelected: false, isAvaliable: false);
    TimeSlot slot6 = new TimeSlot(
        id: 1, title: '12.30', isSelected: false, isAvaliable: true);
    TimeSlot slot7 = new TimeSlot(
        id: 1, title: '04.00', isSelected: false, isAvaliable: true);
    TimeSlot slot8 = new TimeSlot(
        id: 1, title: '04.30', isSelected: false, isAvaliable: true);
    TimeSlot slot9 = new TimeSlot(
        id: 1, title: '05.00', isSelected: false, isAvaliable: true);
    TimeSlot slot10 = new TimeSlot(
        id: 1, title: '05.30', isSelected: false, isAvaliable: true);
    TimeSlot slot11 = new TimeSlot(
        id: 1, title: '06.00', isSelected: false, isAvaliable: true);
    TimeSlot slot12 = new TimeSlot(
        id: 1, title: '06.30', isSelected: false, isAvaliable: false);

    timeSlotAm.clear();
    timeSlotAm.add(slot0);
    timeSlotAm.add(slot01);
    timeSlotAm.add(slot1);
    timeSlotAm.add(slot2);
    timeSlotAm.add(slot3);
    timeSlotAm.add(slot4);

    timeSlotPm.clear();
    timeSlotPm.add(slot5);
    timeSlotPm.add(slot6);
    timeSlotPm.add(slot7);
    timeSlotPm.add(slot8);
    timeSlotPm.add(slot9);
    timeSlotPm.add(slot10);
    timeSlotPm.add(slot11);
    timeSlotPm.add(slot12);
  }*/

  @override
  Widget build(BuildContext context) {
    //loadSharedPrefs();
    //UserData data = UserData.fromJson(_sharedPrefUtils.read("user"));
    //debugPrint(_sharedPrefUtils.read("user"));
    progressDialog  = new ProgressDialog(context);
    return BaseWidget<BookAppoinmentViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Book A Visit',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: new IconThemeData(color: Colors.black),
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
          //drawer: AppDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DoctorTileView(doctorDetails),
              ),
              //_makeDoctorListCard(),
              //_addMultiSelectService(),
              //_makeHeaderDivider('Select date of Appoinment'),
              Container(
                  height: 140,
                  color: colorF6F6FF,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _monthNameWidget(),
                      Expanded(
                        child: _dateSelection(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              // _makeHeaderDivider('Select time slot'),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 0, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          setState(() {
                            isAmSelected = true;
                          });
                        },
                        child: Text(
                          "AM",
                          style: TextStyle(
                              fontSize: 16,
                              color: isAmSelected
                                  ? primaryColor
                                  : Color(0XFF303030),
                              fontWeight: FontWeight.w700),
                        )),
                    InkWell(
                        onTap: () {
                          setState(() {
                            isAmSelected = false;
                          });
                        },
                        child: Text("PM",
                            style: TextStyle(
                                fontSize: 16,
                                color: isAmSelected
                                    ? Color(0XFF303030)
                                    : primaryColor,
                                fontWeight: FontWeight.w700))),
                    Text(
                      "Cm",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      "Cm",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(child: model.busy ? Center(child: SizedBox( height : 32, width: 32 ,child: CircularProgressIndicator())) : (timeSlot.length == 0 ? noSlotsFound() : _makeTimeSlotGridView())),
              SizedBox(
                height: 16,
              ),
              _continueButton(),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noSlotsFound(){
    return Center(
      child: Text( timeSlot.length == 0 ? "Clinic closed,\nPlease select another date" : "No slots found", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14,fontFamily: 'Montserrat', color: primaryColor, ), textAlign:TextAlign.center,),
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
            child: new Text('Next',
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {

              if(startTime == ""){
                showToast("Please select time slot");
              }else {
                bookingAppoinmentsDetails.slotStart = startTime;
                bookingAppoinmentsDetails.slotEnd = endTime;
                bookingAppoinmentsDetails.doctors = doctorDetails;
                bookingAppoinmentsDetails.selectedDate =
                    dateFormat.format(userSelectedDate);

                Navigator.pushNamed(
                    context, RoutePaths.Booking_Appoinment_Info_View,
                    arguments: bookingAppoinmentsDetails);
                debugPrint("Clicked On Proceed");
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _addMultiSelectService() {
    return MultiSelectFormField(
      autovalidate: false,
      validator: (value) {
        if (value == null || value.length == 0) {
          return 'Please select one or more options';
        }
        return '';
      },
      dataSource: [
        {
          "display": "General CheckUp",
          "value": "Climbing",
        },
        {
          "display": "Sonography",
          "value": "Sonography",
        },
      ],
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      // required: true,
      //hintText: 'Please choose one or more',
      onSaved: (value) {
        if (value == null) return;
        setState(() {
          _myActivities = value;
        });
      },
    );
  }

  Widget _makeTimeSlotGridView() {
    print("${isAmSelected}");
    if (isAmSelected) {
      timeSlots.clear();
      timeSlots.addAll(timeSlotAm);
    } else {
      timeSlots.clear();
      timeSlots.addAll(timeSlotPm);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 16, 40, 16),
      child: timeSlots.length == 0 ? noSlotsFound() : GridView.builder(
          itemCount: timeSlots.length,
          controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 16 / 6),
          itemBuilder: (BuildContext context, int index) =>
              _makeTimeSlotBox(context, index)),);
  }

  Widget _makeTimeSlotBox(BuildContext context, int index) {
    Slots slot = timeSlots.elementAt(index);
    Color selcetedColor = Colors.white;
    //debugPrint("isAvailable ${slot.isAvailable} isSelected ${slot.isSelected}, Time Slot ${slot.slotStart.substring(0,5)+" - "+slot.slotEnd.substring(0,5)}");
    if (slot.isAvailable) {
      if (slot.isSelected) {
        selcetedColor = primaryColor;
      }
    } else {
      selcetedColor = primaryLightColor;
    }

    return InkWell(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: selcetedColor,
          border: Border.all(
            color: slot.isSelected ? primaryColor : primaryLightColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(timeFormat.format(slot.slotStart.toLocal()),//+" - "+timeFormat.format(slot.slotEnd.toLocal())
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: slot.isSelected ? Colors.white : primaryColor)),
        ),
      ),
      onTap: () {
        debugPrint('Slot Avalibility ${slot.isAvailable}');
        if(slot.isAvailable) {
          checkSlotConflict(slot.slotStart, slot.slotEnd, index);
        }
        //selectTimeSlot(index);
      },
    );
  }

  selectTimeSlot(int index) {
    debugPrint('index click $index');
    for (int i = 0; i < timeSlots.length; i++) {
      if (i == index && timeSlots.elementAt(i).isAvailable) {
        debugPrint('index click true');
        timeSlots.elementAt(i).isSelected = true;
        print("UTC ${timeSlots.elementAt(i).slotStart.toUtc().toIso8601String()}");
        startTime = timeSlots.elementAt(i).slotStart.toUtc().toIso8601String();
        endTime = timeSlots.elementAt(i).slotEnd.toUtc().toIso8601String();
      } else {
        debugPrint('index click false');
        timeSlots.elementAt(i).isSelected = false;
      }
    }
    setState(() {});
  }

  Widget _makeHeaderDivider(String text) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      color: Color(0xFFE8E7E7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 16,
          ),
          Text(text, style: subHeaderStyle),
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

  void handleReadOnlyInputClick(context) {
    debugPrint("In");
    showBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width,
              child: YearPicker(
                selectedDate: DateTime.now(),
                firstDate: DateTime.now(),
                onChanged: (val) {
                  print(val);
                  Navigator.pop(context);
                },
              ),
            ));
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

  var dateNtimeStrip = List<DateStripDate>();

  _dateAndTimeCalculation() {
    dateNtimeStrip.clear();

    debugPrint("+++++++++++++++++++ Calculation Start ++++++++++++++++++++++");

    var dateUtility = DateUtil();
    startDate = selectedMonth;
    var daysInMonth =
        dateUtility.daysInMonth(selectedMonth.month, selectedMonth.year);
    endDate = startDate.add(Duration(days: daysInMonth - 1));

    int totalDaysInMonth = daysInMonth;

    if (startDate.month == DateTime.now().month) {
      selectedDate = DateTime.now();
      int remainingDays = totalDaysInMonth - DateTime.now().day;
      debugPrint("Remaining Days  ${remainingDays}");
      userSelectedDate = selectedDate;
      startTime = "";
      for (int i = 0; i <= remainingDays; i++) {
        DateStripDate date = new DateStripDate(
            i == 0 ? true : false, DateTime.now().add(Duration(days: i)));
        debugPrint(
            "Remaining Date  ${DateTime.now().add(Duration(days: i)).toIso8601String()}");
        dateNtimeStrip.add(date);
      }
    } else {
      selectedDate = startDate;
      userSelectedDate = selectedDate;
      startTime = "";
      int remainingDays = totalDaysInMonth - 1;
      for (int i = 0; i <= remainingDays; i++) {
        DateStripDate date = new DateStripDate(
            i == 0 ? true : false, startDate.add(Duration(days: i)));
        debugPrint(
            "Remaining Date  ${startDate.add(Duration(days: i)).toIso8601String()}");
        dateNtimeStrip.add(date);
      }
    }
    debugPrint("+++++++++++++++++++ Calculation End ++++++++++++++++++++++");
  }

  _dateSelection() {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 16),
      child: ListView.separated(
          itemBuilder: (context, index) => dateTileBuilderNew(context, index),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8,
              width: 8,
            );
          },
          itemCount: dateNtimeStrip.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: false),
    );

    /*debugPrint("Start date ${startDate.toIso8601String()}");
    debugPrint("end date ${endDate.toIso8601String()}");
    debugPrint("selected date ${startDate.toIso8601String()}");*/
  }

  DateTime startDate;
  DateTime endDate;
  DateTime selectedDate;
  List<DateTime> markedDates = [
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 2)),
    DateTime.now().add(Duration(days: 4))
  ];

  Widget _monthNameWidget() {
    debugPrint(selectedMonth.toIso8601String());
    return Column(
      children: <Widget>[
        new Divider(
          height: 1.0,
        ),
        new MonthStrip(
          format: 'MMM yyyy',
          from: new DateTime.now(),
          to: new DateTime.now().add(Duration(days: 365)),
          initialMonth: selectedMonth,
          height: 48.0,
          viewportFraction: 0.25,
          normalTextStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: textBlack,
              fontWeight: FontWeight.w500,
              fontSize: 14),
          selectedTextStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 14),
          onMonthChanged: (v) {
            setState(() {
              selectedMonth = v;
              _dateAndTimeCalculation();
              debugPrint(selectedMonth.toIso8601String());
              getAvailableDoctorSlot();
            });
          },
        ),
      ],
    );
  }

  dateTileBuilderNew(BuildContext context, int index) {
    DateStripDate dateDetails = dateNtimeStrip.elementAt(index);

    bool isSelectedDate = dateDetails.isSelected;
    //Color fontColor = isDateOutOfRange ? Colors.black12 : Colors.black87;
    TextStyle normalStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);
    TextStyle normalDayNameStyle = TextStyle(
        fontSize: 12, color: primaryColor, fontWeight: FontWeight.w300);
    TextStyle selectedDayNameStyle = TextStyle(
        fontSize: 12, color: Colors.white, fontWeight: FontWeight.w300);
    List<Widget> _children = [
      Text(dayLabels[dateDetails.dateTime.weekday - 1],
          style: !isSelectedDate ? normalDayNameStyle : selectedDayNameStyle),
      Text(dateDetails.dateTime.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    return InkWell(
      onTap: () {
        selectDateSlot(index);
      },
      child: Container(
        width: 56,
        height: 52,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        decoration: BoxDecoration(
          color: !isSelectedDate ? Colors.white : primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: primaryLightColor,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _children,
        ),
      ),
    );
  }

  checkSlotConflict(DateTime startTime, DateTime endTime, int index) async {
    try {
      progressDialog.show();
      var map = new Map<String, dynamic>();
      map['PatientUserId'] = patientUserId;
      map['StartTime'] = startTime.toString();
      map['EndTime'] = endTime.toString();

      CheckConflictResponse checkConflictResponse =
      await model.checkSlotConflict(map);
      debugPrint("Conflict ==> ${checkConflictResponse.toJson()}");
      if (checkConflictResponse.status == 'success') {
        progressDialog.hide();
        if(checkConflictResponse.data.result.canBook){
          selectTimeSlot(index);
        }else {
          showToast('You have already booked an appointment for this time slot');
        }
      } else {
        progressDialog.hide();
        showToast(checkConflictResponse.error);
      }
    } catch (CustomException) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      progressDialog.hide();
      debugPrint(Exception.toString());
    }
  }

  selectDateSlot(int index) {
    debugPrint('Date & Time Strip click $index');
    for (int i = 0; i < dateNtimeStrip.length; i++) {
      if (i == index) {
        debugPrint('index click true');
        dateNtimeStrip.elementAt(i).isSelected = true;
        userSelectedDate = dateNtimeStrip.elementAt(i).dateTime;
        startTime = "";
        getAvailableDoctorSlot();
      } else {
        debugPrint('index click false');
        dateNtimeStrip.elementAt(i).isSelected = false;
      }
    }
    setState(() {});
  }
}
