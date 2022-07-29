import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient/features/common/medication/ui/my_current_medication.dart';
import 'package:patient/features/common/medication/ui/my_medication_history.dart';
import 'package:patient/features/common/medication/ui/my_medication_prescription.dart';
import 'package:patient/features/common/medication/ui/my_medication_refill.dart';
import 'package:patient/features/common/medication/view_models/patients_medication.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';

import 'my_todays_medication.dart';

class MyMedicationView extends StatefulWidget {
  @override
  _MyMedicationViewState createState() => _MyMedicationViewState();
}

class _MyMedicationViewState extends State<MyMedicationView> {
  var model = PatientMedicationViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    late Widget screen;
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

    return BaseWidget<PatientMedicationViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            title: Text(
              'Medication Management',
              style: TextStyle(
                  fontSize: 16.0,
                  color: primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.black),
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
            Expanded(
              flex: 1,
              child: Semantics(
                label: 'Medication Reminder 1 of 3',
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: ExcludeSemantics(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage(
                              'res/images/ic_medication_remainder_selected.png'),
                          size: 24,
                          color:
                              _currentIndex == 0 ? Colors.white : Colors.grey,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Reminders',
                          style: TextStyle(
                              color: _currentIndex == 0
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Semantics(
                label: 'Medication list 2 of 3',
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: ExcludeSemantics(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage('res/images/ic_pharmacy_colored.png'),
                          size: 24,
                          color:
                              _currentIndex == 1 ? Colors.white : Colors.grey,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Medication list',
                          style: TextStyle(
                              color: _currentIndex == 1
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Semantics(
                label: 'Medication History 3 of 3',
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                  child: ExcludeSemantics(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage(
                              'res/images/ic_medication_history_selected.png'),
                          size: 24,
                          color:
                              _currentIndex == 2 ? Colors.white : Colors.grey,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'History',
                          style: TextStyle(
                              color: _currentIndex == 2
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
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
