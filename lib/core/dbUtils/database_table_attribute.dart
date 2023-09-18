

class DataBaseTableAttribute {


  final databaseName = "health_app.db";
  final databaseVersion = 1;

  final weightTable = 'weight';


  final columnId = 'id';
  final columnWeightInKg = 'weightInKg';
  final columnRecordedDate = 'recodedDate';
  final columnPlatformName = 'platformName';

  final heightTable = 'height';
  final columnheightInCm = 'heightInCm';

  final bloodPressureTable = 'bloodPressure';
  final columnSystolicBP = 'systolicBP';
  final columnDiastolicBP = 'diastolicBP';

  final pulseTable = 'pulse';
  final columnPulseRate = 'pulseRate';

  final bloodGlucoseTable = 'bloodGlucose';
  final columnBloodGlucose = 'glucoseValue';

  final bloodOxygenTable = 'bloodOxygen';
  final columnBloodSPO2Level = 'bloodSPO2Level';

}