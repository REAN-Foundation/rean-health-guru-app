import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/core/viewmodels/views/patients_health_marker.dart';
import 'package:paitent/ui/shared/app_colors.dart';
import 'package:paitent/utils/GetHealthData.dart';

import '../base_widget.dart';

class ViewMyDailyExercise extends StatefulWidget {
  @override
  _ViewMyDailyExerciseState createState() => _ViewMyDailyExerciseState();
}

class _ViewMyDailyExerciseState extends State<ViewMyDailyExercise> {
  var model = PatientHealthMarkerViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GetHealthData data;
  String sleepHours = '';
  String min = '';

  @override
  void initState() {
    if (Platform.isIOS) {
      data = GetIt.instance<GetHealthData>();
    }
    Future.delayed(const Duration(seconds: 3), () => getExerciseMin());
    super.initState();
  }

  getExerciseMin() {
    min = data.getExerciseTimeInMin().toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientHealthMarkerViewModel>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              title: Text(
                'Exercise',
                style: TextStyle(
                    fontSize: 16.0,
                    color: primaryColor,
                    fontWeight: FontWeight.w700),
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    min != ''
                        ? exercise()
                        : Center(
                            child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      primaryColor),
                                )),
                          ),
                    /* SizedBox(
                      height: 16,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [primaryLightColor, colorF6F6FF]),
                            border: Border.all(color: primaryLightColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        padding: const EdgeInsets.all(16),
                        height: 200,
                        child:
                            Container() */ /* Center(
                        child: SimpleTimeSeriesChart(_createSampleData()),
                      ),*/ /*
                        ),*/
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget exercise() {
    return Card(
      semanticContainer: false,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_run,
                      size: 24,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Exercise',
                      semanticsLabel: 'Exercise',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /*  Text(
                      sleepHours,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28.0,
                          color: primaryColor),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'hr',
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),*/
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      min,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28.0,
                          color: primaryColor),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'min',
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

/*static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesSales(DateTime.now(), 6),
      TimeSeriesSales(DateTime.now().subtract(Duration(days: 1)), 7),
      TimeSeriesSales(DateTime.now().subtract(Duration(days: 2)), 6.5),
      TimeSeriesSales(DateTime.now().subtract(Duration(days: 3)), 7.5),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }*/
}
