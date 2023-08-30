
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

class RemoteConfigValues{
  static var sample_string_value = "REAN HealthGuru Dev App";
  static List<String> homeScreenTile = [ "Medications", "Nutrition", "Physical Activity", "Mental Well-Being",  "Vitals",  "Symptoms",  "Lab Values",  "Knowledge"  ];
  static List<String> vitalScreenTile = [ "Weight", "Blood Pressure", "Blood Glucose", "Blood Oxygen Sturation",  "Pulse Rate",  "Body Temprature" ];
  static List<String> carePlanCode = []; //[ "Cholesterol", "Stroke", "HeartFailure"]
  static int carePlanTaskDurationInDays = 0;
  static bool hospitalSystemVisibility = true;
  static bool downloadReportButtonVisibility = false;
  static bool dashboardSymptomsVisibility = true;
  static bool dashboardVitalsVisibility = true;
  static bool healthDeviceConnectionVisibility = false;
  static bool healthDataSync = false;
  static String minimumAppVersionRequired = '1.0.0';
  static String softUpdateNewAppVersion = '1.0.0';
  static int healthAppDataSyncTimer = 60;


  static getValues(FirebaseRemoteConfig remoteConfig){
    dashboardSymptomsVisibility = remoteConfig.getBool('dashboard_vitals_visibility');
    dashboardVitalsVisibility = remoteConfig.getBool('dashboard_symptoms_visibility');
    downloadReportButtonVisibility = remoteConfig.getBool('download_report_button_visibility');
    carePlanTaskDurationInDays = remoteConfig.getInt('careplan_task_duration_in_days');
    hospitalSystemVisibility = remoteConfig.getBool('hospital_system_visibility');
    minimumAppVersionRequired = remoteConfig.getString('minimum_app_version_required');
    softUpdateNewAppVersion = remoteConfig.getString('soft_update_new_app_version');
    healthDeviceConnectionVisibility = remoteConfig.getBool('health_device_connection_visibility');
    healthDataSync = remoteConfig.getBool('health_data_sync');
    healthAppDataSyncTimer = remoteConfig.getInt('health_app_data_sync_timer');

    var dashboardTileJsonArray =  remoteConfig.getValue('home_screen_tile');
    homeScreenTile = List<String>.from(jsonDecode(dashboardTileJsonArray.asString()));
    var vitalTileJsonArray =  remoteConfig.getValue('vital_screen_tile');
    vitalScreenTile = List<String>.from(jsonDecode(vitalTileJsonArray.asString()));
    var carePlanCodeJsonArray =  remoteConfig.getValue('careplan_code');
    carePlanCode = List<String>.from(jsonDecode(carePlanCodeJsonArray.asString()));
    debugPrint('############################################################################################');
    debugPrint('$downloadReportButtonVisibility');
    debugPrint('############################################################################################');
  }





}