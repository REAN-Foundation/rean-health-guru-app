
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

class RemoteConfigValues{
  static var sample_string_value = "REAN HealthGuru Dev App";
  static List<String> homeScreenTile = [ "Medications", "Nutrition", "Physical Activity", "Mental Well-Being",  "Vitals",  "Symptoms",  "Lab Values",  "Knowledge"  ];
  static List<String> vitalScreenTile = [ "Weight", "Blood Pressure", "Blood Glucose", "Blood Oxygen Sturation",  "Pulse Rate",  "Body Temprature" ];
  static List<String> carePlanCode = []; //[ "Cholesterol", "Stroke", "HeartFailure"]
  static int carePlanTaskDurationInDays = 0;
  static bool dashboardSymptomsVisibility = true;
  static bool dashboardVitalsVisibility = true;


  static getValues(FirebaseRemoteConfig remoteConfig){
    dashboardSymptomsVisibility = remoteConfig.getBool('dashboard_vitals_visibility');
    dashboardVitalsVisibility = remoteConfig.getBool('dashboard_symptoms_visibility');
    carePlanTaskDurationInDays = remoteConfig.getInt('careplan_task_duration_in_days');

    var dashboardTileJsonArray =  remoteConfig.getValue('home_screen_tile');
    homeScreenTile = List<String>.from(jsonDecode(dashboardTileJsonArray.asString()));
    var vitalTileJsonArray =  remoteConfig.getValue('vital_screen_tile');
    vitalScreenTile = List<String>.from(jsonDecode(vitalTileJsonArray.asString()));
    var carePlanCodeJsonArray =  remoteConfig.getValue('careplan_code');
    carePlanCode = List<String>.from(jsonDecode(carePlanCodeJsonArray.asString()));
    debugPrint('############################################################################################');
    debugPrint('$carePlanCode');
    debugPrint('############################################################################################');
  }





}