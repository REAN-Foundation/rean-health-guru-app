
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paitent/core/viewmodels/views/book_appoinment_view_model.dart';
import 'package:paitent/core/viewmodels/views/patients_medication.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/ui/views/base_widget.dart';
import 'package:paitent/ui/views/my_current_medication.dart';
import 'package:paitent/ui/views/my_medication_history.dart';
import 'package:paitent/ui/views/my_medication_prescription.dart';
import 'package:paitent/ui/views/my_medication_refill.dart';
import 'package:paitent/ui/views/my_medication_remainder.dart';

import 'my_todays_medication.dart';

class MyMedicationView extends StatefulWidget {
  @override
  _MyMedicationViewState createState() => _MyMedicationViewState();
}

class _MyMedicationViewState extends State<MyMedicationView> {
  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (_currentIndex) {
      case 0:
        screen = MyTodaysMedicationView();
        break;
      case 1:
        screen = MyCurrentMedicationView();
        break;
      case 2:
        screen = MyMedicationHistoryView();
        break;
      case 3:
        screen = MyMedicationPrescrptionView();
        break;
      case 4:
        screen = MyMedicationRefillView();
        break;

    }

    return BaseWidget<PatientMedicationViewModel>(
      model: model,
      builder: (context, model, child) =>
          Container(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                title: Text(
                  'My Medications',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                iconTheme: new IconThemeData(color: Colors.black),
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
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _buildTabDesign(),
                  ),
                  Expanded(child: screen)
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildTabDesign() {
    return Card(
      elevation: 16,

      child: Container(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage(
                        'res/images/ic_medication_remainder_selected.png'),
                    size: 24,
                    color: _currentIndex == 0 ? Colors.white : Colors.grey,
                  ),
                  SizedBox(height: 4,),
                  Text(
                    'Reminders',
                    style: TextStyle(
                        color: _currentIndex == 0 ? Colors.white : Colors.grey,
                        fontSize: 10),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('res/images/ic_pharmacy_colored.png'),
                    size: 24,
                    color: _currentIndex == 1 ? Colors.white : Colors.grey,
                  ),
                  SizedBox(height: 4,),
                  Text(
                    'Add Medication',
                    style: TextStyle(
                        color: _currentIndex == 1 ? Colors.white : Colors.grey,
                        fontSize: 10),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('res/images/ic_medication_history_selected.png'),
                    size: 24,
                    color: _currentIndex == 2 ? Colors.white : Colors.grey,
                  ),
                  SizedBox(height: 4,),
                  Text(
                    'History',
                    style: TextStyle(
                        color: _currentIndex == 2 ? Colors.white : Colors.grey,
                        fontSize: 10),
                  ),
                ],
              ),
            ),
            /*InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage(
                        'res/images/ic_medication_prescription_selected.png'),
                    size: 24,
                    color: _currentIndex == 2 ? Colors.white : Colors.grey,
                  ),
                  SizedBox(height: 4,),
                  Text(
                    'Prescriptions',
                    style: TextStyle(
                        color: _currentIndex == 2 ? Colors.white : Colors.grey,
                        fontSize: 10),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('res/images/ic_medication_refill_selected.png'),
                    size: 24,
                    color: _currentIndex == 3 ? Colors.white : Colors.grey,
                  ),
                  SizedBox(height: 4,),
                  Text(
                    'Refills',
                    style: TextStyle(
                        color: _currentIndex == 3 ? Colors.white : Colors.grey,
                        fontSize: 10),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}