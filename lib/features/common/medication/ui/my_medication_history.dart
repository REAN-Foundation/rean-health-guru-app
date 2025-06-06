
import 'package:flutter/material.dart';
import 'package:patient/features/common/medication/models/my_medication_summary_respose.dart';
import 'package:patient/features/common/medication/view_models/patients_medication.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/services/user_analytics_service.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

class MyMedicationHistoryView extends StatefulWidget {
  @override
  _MyMedicationHistoryViewState createState() =>
      _MyMedicationHistoryViewState();
}

class _MyMedicationHistoryViewState extends State<MyMedicationHistoryView> {
  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<MedicationConsumptionSummary> summarys =
      <MedicationConsumptionSummary>[];
  Color buttonColor = Color(0XFFCFB4FF);

  getMyMedicationSummary() async {
    try {
      final MyMedicationSummaryRespose myMedicationSummaryRespose =
          await model.getMyMedicationSummary();
      debugPrint('Medication ==> ${myMedicationSummaryRespose.toJson()}');
      if (myMedicationSummaryRespose.status == 'success') {
        summarys.clear();
        for (final item
            in myMedicationSummaryRespose.data!.medicationConsumptionSummary!) {
          if (item.summaryForMonth!.isNotEmpty) {
            summarys.add(item);
          }
        }
        debugPrint('Summary Length ==> ${summarys.length}');
      } else {
        showToast(myMedicationSummaryRespose.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  @override
  void initState() {
    if (getAppType() == 'AHA') {
      buttonColor = redLightAha;
    }
    UserAnalyticsServices.registerScreenEntryEvent('medication-history-screen', 'medication-history-flow', 'medication-history-screen-entry', '', null);
    getMyMedicationSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientMedicationViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(0.0),
            child: model!.busy
                ? Center(
                    child: SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator()))
                : (summarys.isEmpty ? noMedicationFound() : listWidget()),
          ),
        ),
      ),
    );
  }

  Widget noMedicationFound() {
    return Center(
      child: Text('No medications history',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: primaryColor)),
    );
  }

  Widget listWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
       /* Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InfoScreen(
                tittle: 'Medications History Information',
                description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                height: 240),
          ],
        ),*/
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    _makeMedicinePrescriptionCard(context, index),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 8,
                  );
                },
                itemCount: summarys.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true),
          ),
        ),

          Card(
            margin: EdgeInsets.zero,
            elevation: 12,
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
              ),
              child: Semantics(
                label: 'Indicators',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'Medication status Taken',
                      child: ExcludeSemantics(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Taken',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textBlack)),
                          ],
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Medication status Missed',
                      child: ExcludeSemantics(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Missed',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textBlack)),
                          ],
                        ),
                      ),
                    ),
                    Semantics(
                      label: 'Medication status unknown',
                      child: ExcludeSemantics(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.help_outline,
                              size: 18,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Unknown',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textBlack)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

        ),
          ),

      ],
    );
  }

  Widget _makeMedicinePrescriptionCard(BuildContext context, int index) {
    final MedicationConsumptionSummary summary = summarys.elementAt(index);
    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryLightColor),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: colorF6F6FF,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Semantics(
                        label: summary.month,
                        readOnly: true,
                        child: ExcludeSemantics(
                          child: Text(summary.month!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textBlack)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.help_outline,
                                size: 18,
                                color: primaryColor,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (final item in summary.summaryForMonth!) ...[
                    MergeSemantics(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Semantics(
                              label: item.drug,
                              readOnly: true,
                              child: ExcludeSemantics(
                                child: Text(item.drug!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: textBlack)),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: MergeSemantics(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          item.summaryForDrug!.taken.toString(),
                                          semanticsLabel: item
                                                  .summaryForDrug!.taken
                                                  .toString() +
                                              ' drug taken',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: textBlack)),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                          item.summaryForDrug!.missed
                                              .toString(),
                                          semanticsLabel: item
                                                  .summaryForDrug!.missed
                                                  .toString() +
                                              ' drug missed',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: textBlack)),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                          item.summaryForDrug!.unknown
                                              .toString(),
                                          semanticsLabel: item
                                                  .summaryForDrug!.unknown
                                                  .toString() +
                                              ' drug unknown',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: textBlack)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
