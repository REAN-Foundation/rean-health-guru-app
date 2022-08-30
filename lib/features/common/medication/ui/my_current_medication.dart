import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/medication/models/my_current_medication.dart';
import 'package:patient/features/common/medication/view_models/patients_medication.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';
import 'package:patient/infra/widgets/info_screen.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class MyCurrentMedicationView extends StatefulWidget {
  @override
  _MyCurrentMedicationViewState createState() =>
      _MyCurrentMedicationViewState();
}

class _MyCurrentMedicationViewState extends State<MyCurrentMedicationView> {
  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dateFormatStandard = DateFormat('MMM dd, yyyy');
  var timeFormat = DateFormat('hh:mm a');
  List<Items> currentMedicationList = <Items>[];
  late ProgressDialog progressDialog;
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  @override
  void initState() {
    getMyMedications();
    super.initState();
  }

  getMyMedications() async {
    try {
      final MyCurrentMedication currentMedication =
          await model.getMyCurrentMedications();
      debugPrint('Medication ==> ${currentMedication.toJson()}');
      if (currentMedication.status == 'success') {
        currentMedicationList.clear();
        filterData(currentMedication.data!.medications!.items!);
        //currentMedicationList.addAll(currentMedication.data.medications.items);
      } else {
        showToast(currentMedication.message!, context);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  filterData(List<Items> medicationList) {
    for (int i = 0; i < medicationList.length; i++) {
      if (medicationList.elementAt(i).endDate!.isAfter(DateTime.now())) {
        currentMedicationList.add(medicationList.elementAt(i));
        debugPrint('End Data ==> ${medicationList.elementAt(i).endDate}');
      }else if(medicationList.elementAt(i).frequencyUnit == 'Other' ){
        currentMedicationList.add(medicationList.elementAt(i));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context: context);
    return BaseWidget<PatientMedicationViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: model!.busy
                  ? Center(
                      child: SizedBox(
                          height: 32,
                          width: 32,
                          child: CircularProgressIndicator()))
                  : (currentMedicationList.isEmpty
                      ? noMedicationFound()
                      : listWidget()),
            ),
            floatingActionButton: Semantics(
              label: 'Add new medication',
              button: true,
              container: true,
              child: FloatingActionButton(
                  elevation: 0.0,
                  tooltip: 'Add new medication',
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: primaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.ADD_MY_MEDICATION)
                        .then((value) {
                      getMyMedications();
                    });
                  }),
            )),
      ),
    );
  }

  Widget noMedicationFound() {
    return Center(
      child: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('No medication added',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: primaryColor)),
            InfoScreen(
                tittle: 'Medication Information',
                description: 'Add your medications by pressing the + sign.',
                height: 180)
            ],
          ),
      ),
    );
  }

  Widget listWidget() {
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
    final Items medication = currentMedicationList.elementAt(index);

    return Card(
      semanticContainer: false,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryColor, width: 0.8),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        child: Text(medication.drugName!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryColor)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                          medication.dose.toString() + ' ' + medication.dosageUnit!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey)),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                          medication.frequencyUnit.toString() +
                              ' - ' +
                              medication.timeSchedules!.join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey)),
                      Text(
                          'Started on ' +
                              dateFormatStandard
                                  .format(medication.startDate!.toLocal()),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey)),
                      Text(
                          medication.instructions ?? ' ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey)),
                      //const SizedBox(height: 16,),
                    ],
                  ),
                ),
                if (medication.imageResourceId != null)
                  Expanded(
                    flex: 1,
                    child: Semantics(
                      label: 'Medication ',
                      child: CachedNetworkImage(
                        imageUrl: apiProvider!.getBaseUrl()! +
                            '/file-resources/' +
                            medication.imageResourceId! +
                            '/download-by-version-name/1',
                      ),
                    ),
                  )
                else
                  Container(),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      ConfirmationBottomSheet(
                          context: context,
                          height: 180,
                          onPositiveButtonClickListner: () {
                            //debugPrint('Positive Button Click');
                            deleteMedication(medication.id.toString());
                          },
                          onNegativeButtonClickListner: () {
                            //debugPrint('Negative Button Click');
                          },
                          question: 'Are you sure you want to delete this medication?',
                          tittle: 'Alert!');
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: primaryColor,
                      size: 24,
                      semanticLabel: medication.drugName!+' Delete',
                    )))
          ],
        ),
      ),
    );
  }

  //http://localhost:7272/api/v1/file-resources/05e911d6-b0bd-4bc7-b495-973d2d67d39c/download-by-version-name/1

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
                      ImageIcon(AssetImage('res/images/ic_drug_purpul.png'), size: 16, color: primaryColor,),
                      SizedBox(width: 4,),
                      Container(
                        width: MediaQuery.of(context).size.width - 200,
                        child: Text(consumptions.drugName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600, color: primaryColor)),
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
                              fontWeight: FontWeight.w600, color: primaryColor)),
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
                  */ /*Visibility(
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
                  ),*/ /*
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
      progressDialog.show(max: 100, msg: 'Loading...');
      progressDialog.show(max: 100, msg: 'Loading...');
      final BaseResponse baseResponse =
          await model.markMedicationsAsTaken(consumptionId);
      debugPrint('Medication ==> ${baseResponse.toJson()}');
      if (baseResponse.status == 'success') {
        progressDialog.close();
        getMyMedications();
      } else {
        progressDialog.close();
        showToast(baseResponse.message!, context);
      }
    } catch (CustomException) {
      progressDialog.close();
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint('Error ' + CustomException.toString());
    }
  }

  deleteMedication(String recordId) async {
    try {
      progressDialog.show(max: 100, msg: 'Loading...');

      final BaseResponse baseResponse =
      await model.deleteMedication(recordId);

      if (baseResponse.status == 'success') {
        if (progressDialog.isOpen()) {
          progressDialog.close();
        }
        showToast(baseResponse.message!, context);
        //Navigator.pop(context);
        getMyMedications();
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
}
