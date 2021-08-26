

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';

class MyMedicationPrescrptionView extends StatefulWidget {
  @override
  _MyMedicationPrescrptionViewState createState() => _MyMedicationPrescrptionViewState();
}

class _MyMedicationPrescrptionViewState extends State<MyMedicationPrescrptionView> {

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
          body:  Padding(
            padding: EdgeInsets.all(16.0),
            child: listWidget(),
          ),
        ),
      ),
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
        itemCount: 2,
        scrollDirection: Axis.vertical,
        shrinkWrap: true);
  }



  Widget _makeMedicinePrescriptionCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Text(index == 0 ? "Current" : "Past",
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor)),
          SizedBox(
            height: 8,
          ),

          Container(
            height: 100,
            decoration: new BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryLightColor),
                borderRadius: new BorderRadius.all(Radius.circular(4.0))),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: new BoxDecoration(
                        color: colorF6F6FF,
                        borderRadius:
                        new BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("#MED-32434244",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200, color: textBlack,)),
                              Text("August 2, 2020",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200, color: textBlack)),
                            ],
                          ),
                          SizedBox(height: 8,),
                          RichText(
                            text: TextSpan(
                              text: 'Dr. Abhijeet Mule, ',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  color: textBlack,
                                  fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'MBBS, MD, Pune',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textBlack, fontFamily: 'Montserrat')),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
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
                                Text("MedHealth Pharmacies",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w200, color: textBlack)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepPurple,),
                            ],
                          ),
                        ),
                        SizedBox(width: 8,),
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
