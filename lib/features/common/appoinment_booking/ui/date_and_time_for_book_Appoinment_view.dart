import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/features/common/appoinment_booking/models/CheckConflictResponse.dart';
import 'package:paitent/features/common/appoinment_booking/models/doctorListApiResponse.dart';
import 'package:paitent/features/common/appoinment_booking/ui/doctorTileWidget.dart';
import 'package:paitent/features/common/appoinment_booking/view_models/book_appoinment_view_model.dart';
import 'package:paitent/features/misc/models/DoctorBookingAppoinmentPojo.dart';
import 'package:paitent/features/misc/models/PatientApiDetails.dart';
import 'package:paitent/features/misc/models/dateStripData.dart';
import 'package:paitent/features/misc/models/getAvailableDoctorSlot.dart';
import 'package:paitent/features/misc/models/user_data.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/infra/utils/SharedPrefUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../../misc/ui/base_widget.dart';

//ignore: must_be_immutable
class DateAndTimeForBookAppoinmentView extends StatefulWidget {
  Doctors doctorDetails;

  DateAndTimeForBookAppoinmentView(this.doctorDetails);

  @override
  _DateAndTimeForBookAppoinmentViewState createState() =>
      _DateAndTimeForBookAppoinmentViewState(doctorDetails);
}

class _DateAndTimeForBookAppoinmentViewState
    extends State<DateAndTimeForBookAppoinmentView> {
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String name = '';
  var value;
  List<Slots> timeSlot = [];
  List<Slots> timeSlotAm = [];
  List<Slots> timeSlotPm = [];
  DateTime selectedMonth;
  DateTime userSelectedDate;
  bool isAmSelected = true;
  Doctors doctorDetails;
  List<String> dayLabels = ['Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat', 'Sun'];
  String auth = '';
  var model = BookAppoinmentViewModel();
  String startTime = '';
  String endTime = '';

  _DateAndTimeForBookAppoinmentViewState(this.doctorDetails);

  var dateFormat = DateFormat('yyyy-MM-dd');
  var timeFormat = DateFormat('hh:mm a');
  List<Slots> timeSlots = <Slots>[];
  var bookingAppoinmentsDetails = DoctorBookingAppoinmentPojo();
  ProgressDialog progressDialog;

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      //debugPrint(user.toJson().toString());
      final Patient patient =
          Patient.fromJson(await _sharedPrefUtils.read('patientDetails'));
      bookingAppoinmentsDetails.patient = patient;
      bookingAppoinmentsDetails.userData = user;
      auth = user.data.accessToken;
      getAvailableDoctorSlot();
      setState(() {
        name = user.data.user.person.firstName;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion);
    }
  }

  getAvailableDoctorSlot() async {
    try {
      final GetAvailableDoctorSlot getAvailableDoctorSlot =
          await model.getAvailableDoctorSlot(
              doctorDetails.userId.toString(),
              dateFormat.format(userSelectedDate),
              dateFormat.format(userSelectedDate),
              'Bearer ' + auth);

      if (getAvailableDoctorSlot.status == 'success') {
        timeSlot.clear();
        timeSlots.clear();
        timeSlotAm.clear();
        timeSlotPm.clear();

        if (getAvailableDoctorSlot.data.slotsByDate.isNotEmpty) {
          timeSlot.addAll(
              getAvailableDoctorSlot.data.slotsByDate.elementAt(0).slots);

          for (int i = 0; i < timeSlot.length; i++) {
            debugPrint(DateFormat.jm()
                .format(timeSlot.elementAt(i).slotStart.toLocal()));
            if (DateFormat.jm()
                .format(timeSlot.elementAt(i).slotStart.toLocal())
                .contains('AM')) {
              timeSlotAm.add(timeSlot.elementAt(i));
            } else {
              timeSlotPm.add(timeSlot.elementAt(i));
            }
          }
          debugPrint('Am ${timeSlotAm.length}  PM ${timeSlotPm.length}');
        }
      } else {
        showToast(getAvailableDoctorSlot.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    debugPrint(selectedMonth.toIso8601String());
    //prepareData();
    _dateAndTimeCalculation();
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
    progressDialog = ProgressDialog(context);
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
                          'AM',
                          style: TextStyle(
                              fontSize: 16,
                              color: isAmSelected
                                  ? primaryColor
                                  : Color(0XFF303030),
                              fontWeight: FontWeight.w600),
                        )),
                    InkWell(
                        onTap: () {
                          setState(() {
                            isAmSelected = false;
                          });
                        },
                        child: Text('PM',
                            style: TextStyle(
                                fontSize: 16,
                                color: isAmSelected
                                    ? Color(0XFF303030)
                                    : primaryColor,
                                fontWeight: FontWeight.w600))),
                    Text(
                      'Cm',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      'Cm',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: model.busy
                      ? Center(
                          child: SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator()))
                      : (timeSlot.isEmpty
                          ? noSlotsFound()
                          : _makeTimeSlotGridView())),
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

  Widget noSlotsFound() {
    return Center(
      child: Text(
        timeSlot.isEmpty
            ? 'Clinic closed,\nPlease select another date'
            : 'No slots found',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          fontFamily: 'Montserrat',
          color: primaryColor,
        ),
        textAlign: TextAlign.center,
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
            child: Text('Next',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal)),
            onPressed: () {
              if (startTime == '') {
                showToast('Please select time slot', context);
              } else {
                bookingAppoinmentsDetails.slotStart = startTime;
                bookingAppoinmentsDetails.slotEnd = endTime;
                bookingAppoinmentsDetails.doctors = doctorDetails;
                bookingAppoinmentsDetails.selectedDate =
                    dateFormat.format(userSelectedDate);

                Navigator.pushNamed(
                    context, RoutePaths.Booking_Appoinment_Info_View,
                    arguments: bookingAppoinmentsDetails);
                debugPrint('Clicked On Proceed');
              }
            },
          ),
        ),
      ],
    );
  }


  Widget _makeTimeSlotGridView() {
    debugPrint('$isAmSelected');
    if (isAmSelected) {
      timeSlots.clear();
      timeSlots.addAll(timeSlotAm);
    } else {
      timeSlots.clear();
      timeSlots.addAll(timeSlotPm);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 16, 40, 16),
      child: timeSlots.isEmpty
          ? noSlotsFound()
          : GridView.builder(
              itemCount: timeSlots.length,
              controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 16 / 6),
              itemBuilder: (BuildContext context, int index) =>
                  _makeTimeSlotBox(context, index)),
    );
  }

  Widget _makeTimeSlotBox(BuildContext context, int index) {
    final Slots slot = timeSlots.elementAt(index);
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
          child: Text(timeFormat.format(slot.slotStart.toLocal()),
              //+" - "+timeFormat.format(slot.slotEnd.toLocal())
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: slot.isSelected ? Colors.white : primaryColor)),
        ),
      ),
      onTap: () {
        debugPrint('Slot Avalibility ${slot.isAvailable}');
        if (slot.isAvailable) {
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
        debugPrint(
            'UTC ${timeSlots.elementAt(i).slotStart.toUtc().toIso8601String()}');
        startTime = timeSlots.elementAt(i).slotStart.toUtc().toIso8601String();
        endTime = timeSlots.elementAt(i).slotEnd.toUtc().toIso8601String();
      } else {
        debugPrint('index click false');
        timeSlots.elementAt(i).isSelected = false;
      }
    }
    setState(() {});
  }


  void handleReadOnlyInputClick(context) {
    debugPrint('In');
    showBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width,
              child: YearPicker(
                lastDate: DateTime.now(),
                selectedDate: DateTime.now(),
                firstDate: DateTime.now(),
                onChanged: (val) {
                  debugPrint(val.toString());
                  Navigator.pop(context);
                },
              ),
            ));
  }


  var dateNtimeStrip = <DateStripDate>[];

  _dateAndTimeCalculation() {
    dateNtimeStrip.clear();

    debugPrint('+++++++++++++++++++ Calculation Start ++++++++++++++++++++++');

    //var dateUtility = DateUtil();
    startDate = selectedMonth;
    /* var daysInMonth =
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
    }*/
    debugPrint('+++++++++++++++++++ Calculation End ++++++++++++++++++++++');
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
    return Container();
    /*Column(
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
              fontWeight: FontWeight.w600,
              fontSize: 14),
          selectedTextStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: primaryColor,
              fontWeight: FontWeight.w600,
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
    );*/
  }

  dateTileBuilderNew(BuildContext context, int index) {
    final DateStripDate dateDetails = dateNtimeStrip.elementAt(index);

    final bool isSelectedDate = dateDetails.isSelected;
    //Color fontColor = isDateOutOfRange ? Colors.black12 : Colors.black87;
    final TextStyle normalStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor);
    final TextStyle selectedStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);
    final TextStyle normalDayNameStyle = TextStyle(
        fontSize: 12, color: primaryColor, fontWeight: FontWeight.w300);
    final TextStyle selectedDayNameStyle = TextStyle(
        fontSize: 12, color: Colors.white, fontWeight: FontWeight.w300);
    final List<Widget> _children = [
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
      final map = <String, dynamic>{};
      map['PatientUserId'] = patientUserId;
      map['StartTime'] = startTime.toString();
      map['EndTime'] = endTime.toString();

      final CheckConflictResponse checkConflictResponse =
          await model.checkSlotConflict(map);
      debugPrint('Conflict ==> ${checkConflictResponse.toJson()}');
      if (checkConflictResponse.status == 'success') {
        progressDialog.hide();
        if (checkConflictResponse.data.result.canBook) {
          selectTimeSlot(index);
        } else {
          showToast('You have already booked an appointment for this time slot',
              context);
        }
      } else {
        progressDialog.hide();
        showToast(checkConflictResponse.error, context);
      }
    } catch (CustomException) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  selectDateSlot(int index) {
    debugPrint('Date & Time Strip click $index');
    for (int i = 0; i < dateNtimeStrip.length; i++) {
      if (i == index) {
        debugPrint('index click true');
        dateNtimeStrip.elementAt(i).isSelected = true;
        userSelectedDate = dateNtimeStrip.elementAt(i).dateTime;
        startTime = '';
        getAvailableDoctorSlot();
      } else {
        debugPrint('index click false');
        dateNtimeStrip.elementAt(i).isSelected = false;
      }
    }
    setState(() {});
  }
}
