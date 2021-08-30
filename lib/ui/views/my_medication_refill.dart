

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';

class MyMedicationRefillView extends StatefulWidget {
  @override
  _MyMedicationRefillViewState createState() => _MyMedicationRefillViewState();
}

class _MyMedicationRefillViewState extends State<MyMedicationRefillView> {

  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<PatientMedicationViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: listWidget(),
          ),
        ),
      ),
    );
  }

  Widget listWidget(){
    return ListView.separated(
        itemBuilder: (context, index) => _makeMedicineRefillCard(context, index),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 8,
          );
        },
        itemCount: 2,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }

  Widget _makeMedicineRefillCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Container(
            height: 160,
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
                            Text("Vitamin B-12",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700, color: primaryColor)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Due in 7 days",
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
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Prescription #MED-32434244",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200, color: primaryColor,)),
                              Text("90 Tablets",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200, color: primaryColor)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Last fulfilled by ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200, color: primaryColor,)),
                              Text("MedHealth Pharmacies",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200, color: primaryColor)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Refills left",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200, color: primaryColor,)),
                              Text("2",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200, color: primaryColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                            Text("Reorder?",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700, color: primaryColor)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple,),
                            SizedBox(width: 8,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}