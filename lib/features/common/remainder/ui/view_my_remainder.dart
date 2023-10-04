
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/remainder/models/get_my_all_remainders.dart';
import 'package:patient/features/common/remainder/view_models/patients_remainder.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../../../../infra/widgets/confirmation_bottom_sheet.dart';

class ViewMyRemainderView extends StatefulWidget {
  @override
  _ViewMyRemainderViewState createState() => _ViewMyRemainderViewState();
}

class _ViewMyRemainderViewState extends State<ViewMyRemainderView> {
  var model = PatientRemainderViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormat = DateFormat('MMM dd, yyyy');
  var dateFormatStandard = DateFormat('yyyy-MM-dd');
  late ProgressDialog progressDialog;
  List<Items> reminderList = <Items>[];
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 50.0);
  Color buttonColor = primaryLightColor;

  @override
  void initState() {
    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }
    model.setBusy(true);
    getAllRecords();

    super.initState();
  }
  
  getAllRecords() async {
    try {
      final GetMyAllRemainders allRecordResponse =
      await model.getAllRemainders();
      debugPrint('REmainders ==> ${allRecordResponse.toJson()}');
      if (allRecordResponse.status == 'success') {
        reminderList.clear();
        if (allRecordResponse.data!.reminders!.items!.isNotEmpty) {
          reminderList.clear();
          reminderList.addAll(allRecordResponse.data!.reminders!.items!);
        }
        //showToast(startCarePlanResponse.message);
      } else {
        showSuccessToast(allRecordResponse.message.toString(), context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showSuccessToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientRemainderViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: primaryColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              'Reminders',
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
                      child: model!.busy
                          ? Center(
                        child: CircularProgressIndicator(),
                      )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: model.busy
                                          ? Center(child: CircularProgressIndicator())
                                          : reminderList.isEmpty
                                          ? noRecordsFound()
                                          : listWidget()),
                                ),
                                registerFooter(),
                              ],
                            ),
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

  Widget registerFooter() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Add Reminder',
                  button: true,
                  child: ExcludeSemantics(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.Add_Remainder)
                            .then((value) {
                          getAllRecords();
                          //showToast('Task completed successfully');
                        });
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width - 32,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: primaryColor, width: 1),
                            color: primaryColor),
                        child: Center(
                          child: Text(
                            'Add Reminder',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget noRecordsFound() {
    return Center(
      child: Text('No reminder found',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget listWidget() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.separated(
          itemBuilder: (context, index) => _myReports(context, index),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8,
            );
          },
          itemCount: reminderList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true),
    );
  }

  Widget _myReports(BuildContext context, int index) {
    final Items reminderItem = reminderList.elementAt(index);
    //debugPrint("Type ==> ${reminderItem.reminderType.toString()}");
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Card(
        elevation: 0,
        semanticContainer: false,
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: buttonColor),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reminderItem.name.toString(),
                            semanticsLabel: reminderItem.name.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textBlack)),
                        SizedBox(height: 4,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(reminderItem.whenDate == null ? "Since " +dateFormat.format(DateTime.parse(reminderItem.startDate.toString())) : "On " + dateFormat.format(DateTime.parse(reminderItem.whenDate.toString())),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textBlack)),
                            SizedBox(width: 4,),
                            reminderItem.endDate == null ? SizedBox() : Icon(Icons.arrow_forward, color: primaryColor, size: 16, semanticLabel: 'to',),
                            SizedBox(width: 8,),
                            reminderItem.endDate == null ? SizedBox() : Text("Till " + dateFormat.format(DateTime.parse(reminderItem.endDate.toString())),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textBlack)),
                          ],
                        ),
                        SizedBox(height: 4,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text("At "+DateFormat("hh:mm a").format(DateTime.parse('2023-09-26T'+reminderItem.whenTime.toString())),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: textBlack)),
                            ),

                            Container(
                              height: 20,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: buttonColor,
                                  border: Border.all(color: buttonColor),
                                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
                              child: Center(
                                child: Text(getRemainderTag(reminderItem.reminderType.toString()),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8,),
              Container(height: 60, width: 0.2, color: textGrey,),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){_removeConfirmation(reminderItem);}, icon: Icon(Icons.delete, color: primaryColor, size: 24, semanticLabel: 'Delete '+reminderItem.name.toString(),))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _removeConfirmation(Items document) {

    ConfirmationBottomSheet(
        context: context,
        height: 180,
        onPositiveButtonClickListner: () {
          //debugPrint('Positive Button Click');
          deleteDocument(document.id!);
        },
        onNegativeButtonClickListner: () {
          //debugPrint('Negative Button Click');
        },
        question: 'Are you sure you want to delete this reminder?',
        tittle: 'Alert!');
  }

  deleteDocument(String documentId) async {
    try {
      final BaseResponse baseResponse = await model.deleteRemainder(documentId);
      debugPrint('Records ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        getAllRecords();
        showSuccessToast(baseResponse.message!, context);
      } else {
        showToast(baseResponse.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  String getRemainderTag(String type){
    if(type == 'Repeat-Every-Day')
      return 'Daily';
    if(type == 'OneTime')
      return 'One Time';
    if(type == 'Repeat-Every-Weekday')
      return 'All Weekdays';
    if(type == 'Repeat-Every-Week-On-Days')
      return 'Weekdays';
    if(type == 'Repeat-After-Every-N')
      return 'After Every';
    return '';
  }


}
