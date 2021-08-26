

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/models/MyMedicationSummaryRespose.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/utils/CommonUtils.dart';

class MyMedicationHistoryView extends StatefulWidget {
  @override
  _MyMedicationHistoryViewState createState() => _MyMedicationHistoryViewState();
}

class _MyMedicationHistoryViewState extends State<MyMedicationHistoryView> {

  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Summary> summarys = new List<Summary>();

  getMyMedicationSummary() async {
    try {

      MyMedicationSummaryRespose myMedicationSummaryRespose =
      await model.getMyMedicationSummary();
      debugPrint("Medication ==> ${myMedicationSummaryRespose.toJson()}");
      if (myMedicationSummaryRespose.status == 'success') {
        summarys.clear();
        for(var item in myMedicationSummaryRespose.data.summary){
          if(item.summaryForMonth.length > 0){
            summarys.add(item);
          }
        }
        debugPrint("Summary Length ==> ${summarys.length}");
      } else {
        showToast(myMedicationSummaryRespose.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

  @override
  void initState() {
    getMyMedicationSummary();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<PatientMedicationViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body:  Padding(
            padding: EdgeInsets.all(16.0),
            child: model.busy
                ? Center(
                child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator()))
                : (summarys.length == 0
                ? noMedicationFound()
                : listWidget()),
          ),
        ),
      ),
    );
  }

  Widget noMedicationFound() {
    return Center(
      child: Text("No medication history",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: Colors.deepPurple)),
    );
  }

  Widget listWidget(){
    return ListView.separated(
        itemBuilder: (context, index) => _makeMedicinePrescriptionCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        itemCount: summarys.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }



  Widget _makeMedicinePrescriptionCard(BuildContext context, int index) {
    Summary summary = summarys.elementAt(index);
    return Container(

          decoration: new BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryLightColor),
              borderRadius: new BorderRadius.all(Radius.circular(4.0))),
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                decoration: new BoxDecoration(
                    color: colorF6F6FF,
                    borderRadius:
                    new BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Text(summary.month,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700, color: textBlack)),
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
                                  decoration: new BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8,),
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: new BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8,),
                                Icon(Icons.help_outline, size: 16, color: Colors.deepPurple,)
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
                    for(var item in summary.summaryForMonth)...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Text(item.drug,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500, color: textBlack)),
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
                                    Text(item.drugSummary.taken.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500, color: textBlack)),
                                    SizedBox(width: 8,),
                                    Text(item.drugSummary.missed.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500, color: textBlack)),
                                    SizedBox(width: 8,),
                                    Text(item.drugSummary.unknown.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500, color: textBlack)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
  }
}
