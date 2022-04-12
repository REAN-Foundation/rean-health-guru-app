import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:paitent/infra/networking/ApiProvider.dart';
import 'package:paitent/infra/utils/SharedPrefUtils.dart';
import 'package:paitent/infra/utils/StringUtility.dart';

class GetAllConfigrations {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();

  final _sharedPrefUtils = SharedPrefUtils();

  GetAllConfigrations() {
    _getMedicationDosageUnits();
    _getMedicationFrequencies();
    _getMedicationDurationUnits();
    //_getAllLabSamples();
    //_getAllSymptoms();
    //_getAllDygnoses();
  }

  _getMedicationDosageUnits() async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;
    final response = await apiProvider!
        .get('/clinical/medications/dosage-units', header: map);
    debugPrint('Medication Dosage Units ==> $response');
    _sharedPrefUtils.save('MedicationDosageUnits', response);
    // Convert and return
  }

  _getMedicationFrequencies() async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;
    final response = await apiProvider!
        .get('/clinical/medications/frequency-units', header: map);
    debugPrint('Medication Frequencies ==> $response');
    _sharedPrefUtils.save('MedicationFrequencies', response);
    // Convert and return
  }

  _getMedicationDurationUnits() async {
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;
    final response = await apiProvider!
        .get('/clinical/medications/duration-units', header: map);
    debugPrint('Medication Duration Units ==> $response');
    _sharedPrefUtils.save('MedicationDurationUnits', response);
    // Convert and return
  }
}
