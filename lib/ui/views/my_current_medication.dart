import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/constants/app_contstants.dart';
import 'package:paitent/core/models/BaseResponse.dart';
import 'package:paitent/core/models/GetMyMedicationsResponse.dart';
import 'package:paitent/core/models/MyCurrentMedication.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:intl/intl.dart';
import 'package:paitent/utils/CommonUtils.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MyCurrentMedicationView extends StatefulWidget {
  @override
  _MyCurrentMedicationViewState createState() => _MyCurrentMedicationViewState();
}

class _MyCurrentMedicationViewState extends State<MyCurrentMedicationView> {

  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var dateFormatStandard = DateFormat("MMMM dd, yyyy");
  var timeFormat = DateFormat("hh:mm a");
  List<Medications> currentMedicationList = new List<Medications>();
  ProgressDialog progressDialog;
  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  @override
  void initState() {
    getMyMedications();
    // TODO: implement initState
    super.initState();
  }

  getMyMedications() async {
    try {

      MyCurrentMedication currentMedication =
      await model.getMyCurrentMedications();
      debugPrint("Medication ==> ${currentMedication.toJson()}");
      if (currentMedication.status == 'success') {
        currentMedicationList.clear();
        currentMedicationList.addAll(currentMedication.data.medications);
      } else {
        showToast(currentMedication.message);
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
  Widget build(BuildContext context) {
    progressDialog  = new ProgressDialog(context);
    // TODO: implement build
    return BaseWidget<PatientMedicationViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: model.busy
                ? Center(
                child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator()))
                : (currentMedicationList.length == 0
                ? noMedicationFound()
                : listWidget()),
          ),
            floatingActionButton: Semantics(
              label: 'add_my_medication',
              child: new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(Icons.add, color: Colors.white,),
                  backgroundColor: primaryColor,
                  onPressed: (){
                    Navigator.pushNamed(
                        context, RoutePaths.ADD_MY_MEDICATION).then((value) {
                        getMyMedications();
                    });
                  }
              ),
            )
        ),
      ),
    );
  }

  Widget noMedicationFound() {
    return Center(
      child: Text("No medication added",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: Colors.deepPurple)),
    );
  }

  Widget listWidget(){
    return ListView.separated(
        itemBuilder: (context, index) => _makeMedicineCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        itemCount: currentMedicationList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget _makeMedicineCard(BuildContext context, int index) {
    Medications medication = currentMedicationList.elementAt(index);

    return MergeSemantics(
      child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
          decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor, width: 0.8),
          borderRadius: new BorderRadius.all(Radius.circular(8.0))),
          child: ExcludeSemantics(
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        label: medication.drug,
                        child: Text(medication.drug,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700, color: primaryColor)),
                      ),
                      const SizedBox(height: 16,),
                      Text(medication.dose.toString()+' '+medication.dosageUnit,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300, color: Colors.grey)),
                      const SizedBox(height: 8,),
                      Text(medication.frequencyUnit.toString()+' - '+medication.timeSchedule,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300, color: Colors.grey)),
                      Text('Started on '+dateFormatStandard.format(medication.startDate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300, color: Colors.grey)),
                      Text(medication.instructions,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300, color: Colors.grey)),
                      //const SizedBox(height: 16,),
                    ],
                  ),
                ),
                medication.medicationImageResourceId != null ? Expanded(
                    flex: 1,
                    child: Semantics(
                      label : 'medication_image',
                      child: CachedNetworkImage(
                        imageUrl: apiProvider.getBaseUrl()+'/resources/download-public/'+medication.medicationImageResourceId,
                      ),
                    ),
                ) : Container(),
              ],
            ),
          ),
      ),
    );

  }

  /*Widget _makeMedicineCard(BuildContext context, int index) {
    MedConsumptions consumptions = medConsumptions.elementAt(index);
    return Container(
      height: 100,
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryLightColor),
          borderRadius: new BorderRadius.all(Radius.circular(4.0))),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              decoration: new BoxDecoration(
                  color: colorF6F6FF,
                  borderRadius:
                  new BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(width: 8,),
                      ImageIcon(AssetImage('res/images/ic_drug_purpul.png'), size: 16, color: Colors.deepPurple,),
                      SizedBox(width: 4,),
                      Container(
                        width: MediaQuery.of(context).size.width - 200,
                        child: Text(consumptions.drugName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700, color: primaryColor)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Today, "+timeFormat.format(consumptions.timeScheduleStart),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700, color: primaryColor)),
                      SizedBox(width: 8,),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          consumptions.note == null ?
                          Container()
                              :Text(consumptions.note,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200, color: textBlack)),
                          SizedBox(height: 4,),
                          if(!consumptions.isTaken)...[
                          Text('Consume before : '+timeFormat.format(consumptions.timeScheduleEnd),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0XFF909CAC))),
                        ],
                        if(consumptions.isTaken)...[
                          Text('Consumed at : '+timeFormat.format(DateTime.parse(consumptions.takenAt).toLocal()),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0XFF909CAC))),
                        ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  if(!consumptions.isTaken)...[
                  Visibility(
                    visible: !consumptions.timeScheduleStart.isAfter(new DateTime.now()),
                    child: Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: (){
                          markMedicationsAsTaken(consumptions.id);
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(4)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.check, size: 24, color: Colors.white,),
                              SizedBox(height: 0,),
                              Text(
                                'Mark As\nTaken',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ],
                  if(consumptions.isTaken)...[
                    Visibility(
                      visible: !consumptions.timeScheduleStart.isAfter(new DateTime.now()),
                      child: Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: (){

                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(4)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.done_all, size: 32, color: Colors.green,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                  *//*Visibility(
                    visible: index != 0 ? true : false,
                    child: Expanded(
                      flex: 3,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text("Due in 13 hours",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),*//*
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  markMedicationsAsTaken(String consumptionId) async {
    try {
      progressDialog.show();
      BaseResponse baseResponse =
      await model.markMedicationsAsTaken(consumptionId);
      debugPrint("Medication ==> ${baseResponse.toJson()}");
      if (baseResponse.status == 'success') {
        progressDialog.hide();
        getMyMedications();
      } else {
        progressDialog.hide();
        showToast(baseResponse.message);
      }
    } catch (CustomException) {
      progressDialog.hide();
      model.setBusy(false);
      showToast(CustomException.toString());
      debugPrint("Error " + CustomException.toString());
    } catch (Exception) {
      debugPrint(Exception.toString());
    }
  }

}