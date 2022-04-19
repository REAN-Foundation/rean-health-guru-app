import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/appointment_booking/models/my_appointment_api_response.dart';
import 'package:patient/features/common/appointment_booking/view_models/book_appointment_view_model.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/pdf_viewer.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:path_provider/path_provider.dart';

import '../../../misc/ui/base_widget.dart';

class ViewMyAppointment extends StatefulWidget {
  @override
  _ViewMyAppoinmentState createState() => _ViewMyAppoinmentState();
}

class _ViewMyAppoinmentState extends State<ViewMyAppointment> {
  bool isUpCompletedSelected = true;
  var model = BookAppoinmentViewModel();
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String? auth;
  List<Appointments> appointments = <Appointments>[];
  var dateFormat = DateFormat('dd MMM, yyyy');
  var dateFormatFull = DateFormat('yyyy-MM-dd');
  var timeFormat = DateFormat('hh:mm a');
  String pathPDF = '';
  bool isUpCommingSelected = true;
  late UserData user;

  loadSharedPrefs() async {
    try {
      user = UserData.fromJson(await _sharedPrefUtils.read('user'));
      //debugPrint(user.toJson().toString());
      auth = user.data!.accessToken;
      _getMyAppointments(auth!);
      setState(() {});
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }
  }

  @override
  void initState() {
    createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        debugPrint(pathPDF);
      });
    });
    model.setBusy(true);
    loadSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<BookAppoinmentViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Appointments ',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  Container(
                    color: colorF6F6FF,
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              _getMyAppointments(auth!);
                              isUpCommingSelected = true;
                            },
                            child: Center(
                              child: Text(
                                'Upcoming',
                                style: TextStyle(
                                    color: isUpCommingSelected
                                        ? primaryColor
                                        : textBlack,
                                    fontWeight: isUpCommingSelected
                                        ? FontWeight.w600
                                        : FontWeight.w300,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              _getMyCompletedAppointments(auth!);
                              isUpCommingSelected = false;
                            },
                            child: Center(
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                    color: isUpCommingSelected
                                        ? textBlack
                                        : primaryColor,
                                    fontWeight: isUpCommingSelected
                                        ? FontWeight.w300
                                        : FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: model!.busy
                              ? Center(child: CircularProgressIndicator())
                              : appointments.isEmpty
                                  ? noAppointmentFound()
                                  : listWidget())),
                ],
              ),
            )),
      ),
    );
  }

  Widget listWidget() {
    return ListView.separated(
        itemBuilder: (context, index) => isUpCommingSelected
            ? _makeUpcommingAppointmentCard(context, index)
            : _makeCompletedAppointmentCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        itemCount: appointments.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget noAppointmentFound() {
    return Center(
      child: Text('No appointment found',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryLightColor)),
    );
  }

  Widget _makeUpcommingAppointmentCard(BuildContext context, int index) {
    final Appointments appointment = appointments.elementAt(index);

    bool isDateVisible = true;

    if (index != 0) {
      if (dateFormat.format(appointment.startTimeUtc!.toLocal()) ==
          dateFormat.format(
              appointments.elementAt(index - 1).startTimeUtc!.toLocal())) {
        isDateVisible = false;
      } else {
        isDateVisible = true;
      }
    }

    /* if (index.isEven) {
      isDateVisible = true;
    } else {
      isDateVisible = false;
    }
*/
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: isDateVisible,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Text(dateFormat.format(appointment.startTimeUtc!.toLocal()),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          Container(
            height: 108,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryLightColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: <Widget>[
                Card(
                  elevation: 0,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 60,
                                width: 60,
                                child: Image(
                                  image: AssetImage(
                                      'res/images/profile_placeholder.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 18.0),
                                    child: Text(appointment.businessNodeName!,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor)),
                                  ),
                                  Text(appointment.businessUserName!,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0XFF909CAC))),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          timeFormat.format(appointment
                                              .startTimeUtc!
                                              .toLocal()),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          'ID: ' +
                                              appointment.displayId!
                                                  .substring(15),
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w300,
                                              color: primaryColor)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset(
                          'res/images/ic_appointment_confirmed.png')),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeCompletedAppointmentCard(BuildContext context, int index) {
    final Appointments appointment = appointments.elementAt(index);
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          Text(dateFormat.format(appointment.startTimeUtc!.toLocal()),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryLightColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 60,
                            width: 60,
                            child: Image(
                              image: AssetImage(
                                  'res/images/profile_placeholder.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(appointment.businessUserName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor)),
                              Text('',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0XFF909CAC))),
                              Text(
                                  'ID: ' + appointment.displayId!.substring(15),
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: primaryColor)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  timeFormat.format(
                                      appointment.startTimeUtc!.toLocal()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Visibility(
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PDFScreen(pathPDF)));
                                          },
                                          child: SizedBox(
                                              height: 32,
                                              width: 32,
                                              child: Image.asset(
                                                  'res/images/ic_pharmacy_report.png')))),
                                  Visibility(
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PDFScreen(pathPDF)));
                                          },
                                          child: SizedBox(
                                              height: 32,
                                              width: 32,
                                              child: Image.asset(
                                                  'res/images/ic_lab_report.png'))))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        color: colorF6F6FF,
                        border: Border.all(color: primaryLightColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 16,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Patient: ',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: user.data!.user!.person!.firstName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<File> createFileOfPdfUrl() async {
    //final url = "http://africau.edu/images/default/sample.pdf";
    const url = 'https://www.lalpathlabs.com/SampleReports/Z614.pdf';
    final filename = url.substring(url.lastIndexOf('/') + 1);
    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  _getMyAppointments(String auth) async {
    try {
      final MyAppointmentApiResponse bookingAppoinmentForDoctor =
          await model.getMyAppoinmentByDateList(
              'Bearer ' + auth,
              dateFormatFull.format(DateTime.now()),
              dateFormatFull.format(DateTime.now().add(Duration(days: 90))));

      if (bookingAppoinmentForDoctor.status == 'success') {
        appointments.clear();
        setState(() {
          appointments.addAll(bookingAppoinmentForDoctor.data!.appointments!);
        });
      } else {}
    } catch (CustomException) {
      model.setBusy(false);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  _getMyCompletedAppointments(String auth) async {
    try {
      //cancelled, completed, confirmed
      appointments.clear();
      final MyAppointmentApiResponse bookingAppoinmentForDoctor =
          await model.getMyAppoinmentByDateLisAndStatus(
              'Bearer ' + auth,
              'completed',
              dateFormatFull
                  .format(DateTime.now().subtract(Duration(days: 90))),
              dateFormatFull.format(DateTime.now()));

      if (bookingAppoinmentForDoctor.status == 'success') {
        appointments.clear();
        setState(() {
          appointments.addAll(bookingAppoinmentForDoctor.data!.appointments!);
        });
      } else {}
    } catch (CustomException) {
      model.setBusy(false);
      debugPrint('Error ' + CustomException.toString());
    }
  }
}
