import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paitent/core/models/GetCarePlanSummaryResponse.dart';
import 'package:paitent/core/viewmodels/views/patients_care_plan.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';

class SummaryOfMyCarePlanView extends StatefulWidget {
  @override
  _SummaryOfMyCarePlanViewState createState() =>
      _SummaryOfMyCarePlanViewState();
}

class _SummaryOfMyCarePlanViewState extends State<SummaryOfMyCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GetCarePlanSummaryResponse _getCarePlanSummaryResponse;
  var dateFormat = DateFormat('MMMM, dd yyyy');
  int currentWeek = 0;

  getAHACarePlanSummary() async {
    try {
      _getCarePlanSummaryResponse = await model.getAHACarePlanSummary(
          startCarePlanResponseGlob.data.carePlan.id.toString());

      if (_getCarePlanSummaryResponse.status == 'success') {
        debugPrint('AHA Care Plan ==> ${_getCarePlanSummaryResponse.toJson()}');
        currentWeek =
            _getCarePlanSummaryResponse.data.carePlanSummary.currentWeek;
      } else {
        showToast(_getCarePlanSummaryResponse.message, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  @override
  void initState() {
    getAHACarePlanSummary();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorF6F6FF,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            startCarePlanResponseGlob
                                .data.carePlan.carePlanName,
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w200),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          startCarePlanResponseGlob.data.carePlan.displayId,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w200),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: model.busy
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Stack(
                                children: <Widget>[
                                  if (_getCarePlanSummaryResponse
                                          .data.carePlanSummary.currentWeek
                                          .toString() ==
                                      '-1')
                                    Container()
                                  else
                                    currentWeekCount(),
                                  _buildCarePlanView(),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget currentWeekCount() {
    return Positioned(
      left: 40,
      top: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                border: Border.all(
                    width: 5, color: Colors.grey, style: BorderStyle.solid)),
            child: Center(
              child: Text(
                currentWeek.toString(),
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 48,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Week',
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCarePlanView() {
    return MergeSemantics(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 12,
                child: Container(),
              ),
              Expanded(
                flex: 2,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 12
                          ? Colors.green
                          : currentWeek > 12
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'text color change after 3 month',
                          readOnly: true,
                          child: Text(
                            '12',
                            style: TextStyle(
                                color: currentWeek == 12
                                    ? primaryLightColor
                                    : currentWeek > 12
                                        ? Colors.white
                                        : primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 11,
                child: Container(),
              ),
              Expanded(
                flex: 3,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 11
                          ? Colors.green
                          : currentWeek > 11
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'text color change afetr 11 week',
                          readOnly: true,
                          child: Text(
                            '11',
                            style: TextStyle(
                                color: currentWeek == 11
                                    ? primaryLightColor
                                    : currentWeek > 11
                                        ? Colors.white
                                        : primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: Container(),
              ),
              Expanded(
                flex: 4,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 10
                          ? Colors.green
                          : currentWeek > 10
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '10',
                          style: TextStyle(
                              color: currentWeek == 10
                                  ? primaryLightColor
                                  : currentWeek > 10
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 9,
                child: Container(),
              ),
              Expanded(
                flex: 5,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 9
                          ? Colors.green
                          : currentWeek > 9
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '9',
                          style: TextStyle(
                              color: currentWeek == 9
                                  ? primaryLightColor
                                  : currentWeek > 9
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Container(),
              ),
              Expanded(
                flex: 6,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 8
                          ? Colors.green
                          : currentWeek > 8
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '8',
                          style: TextStyle(
                              color: currentWeek == 8
                                  ? primaryLightColor
                                  : currentWeek > 8
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 7,
                child: Container(),
              ),
              Expanded(
                flex: 7,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 7
                          ? Colors.green
                          : currentWeek > 7
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '7',
                          style: TextStyle(
                              color: currentWeek == 7
                                  ? primaryLightColor
                                  : currentWeek > 7
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Container(),
              ),
              Expanded(
                flex: 8,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 6
                          ? Colors.green
                          : currentWeek > 6
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '6',
                          style: TextStyle(
                              color: currentWeek == 6
                                  ? primaryLightColor
                                  : currentWeek > 6
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Container(),
              ),
              Expanded(
                flex: 9,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 5
                          ? Colors.green
                          : currentWeek > 5
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '5',
                          style: TextStyle(
                              color: currentWeek == 5
                                  ? primaryLightColor
                                  : currentWeek > 5
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Container(),
              ),
              Expanded(
                flex: 10,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 4
                          ? Colors.green
                          : currentWeek > 4
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '4',
                          style: TextStyle(
                              color: currentWeek == 4
                                  ? primaryLightColor
                                  : currentWeek > 4
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(),
              ),
              Expanded(
                flex: 11,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 3
                          ? Colors.green
                          : currentWeek > 3
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '3',
                          style: TextStyle(
                              color: currentWeek == 3
                                  ? primaryLightColor
                                  : currentWeek > 3
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                flex: 12,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 2
                          ? Colors.green
                          : currentWeek > 2
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '2',
                          style: TextStyle(
                              color: currentWeek == 2
                                  ? primaryLightColor
                                  : currentWeek > 2
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 13,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentWeek == 1
                          ? Colors.green
                          : currentWeek > 1
                              ? Colors.deepPurple
                              : primaryLightColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border.all(color: primaryLightColor, width: 0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: Text(
                            dateFormat.format(_getCarePlanSummaryResponse
                                .data.carePlanSummary.carePlanStartDate
                                .toLocal()),
                            style: TextStyle(
                                color: primaryLightColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          '1',
                          style: TextStyle(
                              color: currentWeek == 1
                                  ? primaryLightColor
                                  : currentWeek > 1
                                      ? Colors.white
                                      : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
