/// Status : "success"
/// Message : "Patient health report settings retrieved successfully!"
/// HttpCode : 200
/// Data : {"Settings":{"id":"8ceb99a3-8b90-4ed5-b69c-1ab280e5c082","PatientUserId":"acd34116-5240-423d-9e96-eb1729729122","Preference":{"HealthJourney":true,"MedicationAdherence":true,"BodyWeight":false,"BloodGlucose":true,"BloodPressure":true,"SleepHistory":true,"LabValues":true,"ExerciseAndPhysicalActivity":true,"FoodAndNutrition":true,"DailyTaskStatus":true,"MoodAndSymptoms":true}}}

class GetHealthReportSettingsPojo {
  GetHealthReportSettingsPojo({
      String? status, 
      String? message, 
      int? httpCode, 
      Data? data,}){
    _status = status;
    _message = message;
    _httpCode = httpCode;
    _data = data;
}

  GetHealthReportSettingsPojo.fromJson(dynamic json) {
    _status = json['Status'];
    _message = json['Message'];
    _httpCode = json['HttpCode'];
    _data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }
  String? _status;
  String? _message;
  int? _httpCode;
  Data? _data;

  String? get status => _status;
  String? get message => _message;
  int? get httpCode => _httpCode;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = _status;
    map['Message'] = _message;
    map['HttpCode'] = _httpCode;
    if (_data != null) {
      map['Data'] = _data?.toJson();
    }
    return map;
  }

}

/// Settings : {"id":"8ceb99a3-8b90-4ed5-b69c-1ab280e5c082","PatientUserId":"acd34116-5240-423d-9e96-eb1729729122","Preference":{"HealthJourney":true,"MedicationAdherence":true,"BodyWeight":false,"BloodGlucose":true,"BloodPressure":true,"SleepHistory":true,"LabValues":true,"ExerciseAndPhysicalActivity":true,"FoodAndNutrition":true,"DailyTaskStatus":true,"MoodAndSymptoms":true}}

class Data {
  Data({
      Settings? settings,}){
    _settings = settings;
}

  Data.fromJson(dynamic json) {
    _settings = json['Settings'] != null ? Settings.fromJson(json['Settings']) : null;
  }
  Settings? _settings;

  Settings? get settings => _settings;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_settings != null) {
      map['Settings'] = _settings?.toJson();
    }
    return map;
  }

}

/// id : "8ceb99a3-8b90-4ed5-b69c-1ab280e5c082"
/// PatientUserId : "acd34116-5240-423d-9e96-eb1729729122"
/// Preference : {"HealthJourney":true,"MedicationAdherence":true,"BodyWeight":false,"BloodGlucose":true,"BloodPressure":true,"SleepHistory":true,"LabValues":true,"ExerciseAndPhysicalActivity":true,"FoodAndNutrition":true,"DailyTaskStatus":true,"MoodAndSymptoms":true}

class Settings {
  Settings({
      String? id, 
      String? patientUserId, 
      Preference? preference,}){
    _id = id;
    _patientUserId = patientUserId;
    _preference = preference;
}

  Settings.fromJson(dynamic json) {
    _id = json['id'];
    _patientUserId = json['PatientUserId'];
    _preference = json['Preference'] != null ? Preference.fromJson(json['Preference']) : null;
  }
  String? _id;
  String? _patientUserId;
  Preference? _preference;

  String? get id => _id;
  String? get patientUserId => _patientUserId;
  Preference? get preference => _preference;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['PatientUserId'] = _patientUserId;
    if (_preference != null) {
      map['Preference'] = _preference?.toJson();
    }
    return map;
  }

}

/// HealthJourney : true
/// MedicationAdherence : true
/// BodyWeight : false
/// BloodGlucose : true
/// BloodPressure : true
/// SleepHistory : true
/// LabValues : true
/// ExerciseAndPhysicalActivity : true
/// FoodAndNutrition : true
/// DailyTaskStatus : true
/// MoodAndSymptoms : true

class Preference {
  Preference({
      bool? healthJourney, 
      bool? medicationAdherence, 
      bool? bodyWeight, 
      bool? bloodGlucose, 
      bool? bloodPressure, 
      bool? sleepHistory, 
      bool? labValues, 
      bool? exerciseAndPhysicalActivity, 
      bool? foodAndNutrition, 
      bool? dailyTaskStatus, 
      bool? moodAndSymptoms,}){
    _healthJourney = healthJourney;
    _medicationAdherence = medicationAdherence;
    _bodyWeight = bodyWeight;
    _bloodGlucose = bloodGlucose;
    _bloodPressure = bloodPressure;
    _sleepHistory = sleepHistory;
    _labValues = labValues;
    _exerciseAndPhysicalActivity = exerciseAndPhysicalActivity;
    _foodAndNutrition = foodAndNutrition;
    _dailyTaskStatus = dailyTaskStatus;
    _moodAndSymptoms = moodAndSymptoms;
}

  Preference.fromJson(dynamic json) {
    _healthJourney = json['HealthJourney'];
    _medicationAdherence = json['MedicationAdherence'];
    _bodyWeight = json['BodyWeight'];
    _bloodGlucose = json['BloodGlucose'];
    _bloodPressure = json['BloodPressure'];
    _sleepHistory = json['SleepHistory'];
    _labValues = json['LabValues'];
    _exerciseAndPhysicalActivity = json['ExerciseAndPhysicalActivity'];
    _foodAndNutrition = json['FoodAndNutrition'];
    _dailyTaskStatus = json['DailyTaskStatus'];
    _moodAndSymptoms = json['MoodAndSymptoms'];
  }
  bool? _healthJourney;
  bool? _medicationAdherence;
  bool? _bodyWeight;
  bool? _bloodGlucose;
  bool? _bloodPressure;
  bool? _sleepHistory;
  bool? _labValues;
  bool? _exerciseAndPhysicalActivity;
  bool? _foodAndNutrition;
  bool? _dailyTaskStatus;
  bool? _moodAndSymptoms;

  bool? get healthJourney => _healthJourney;
  bool? get medicationAdherence => _medicationAdherence;
  bool? get bodyWeight => _bodyWeight;
  bool? get bloodGlucose => _bloodGlucose;
  bool? get bloodPressure => _bloodPressure;
  bool? get sleepHistory => _sleepHistory;
  bool? get labValues => _labValues;
  bool? get exerciseAndPhysicalActivity => _exerciseAndPhysicalActivity;
  bool? get foodAndNutrition => _foodAndNutrition;
  bool? get dailyTaskStatus => _dailyTaskStatus;
  bool? get moodAndSymptoms => _moodAndSymptoms;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['HealthJourney'] = _healthJourney;
    map['MedicationAdherence'] = _medicationAdherence;
    map['BodyWeight'] = _bodyWeight;
    map['BloodGlucose'] = _bloodGlucose;
    map['BloodPressure'] = _bloodPressure;
    map['SleepHistory'] = _sleepHistory;
    map['LabValues'] = _labValues;
    map['ExerciseAndPhysicalActivity'] = _exerciseAndPhysicalActivity;
    map['FoodAndNutrition'] = _foodAndNutrition;
    map['DailyTaskStatus'] = _dailyTaskStatus;
    map['MoodAndSymptoms'] = _moodAndSymptoms;
    return map;
  }

}