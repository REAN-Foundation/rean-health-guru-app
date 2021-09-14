import 'package:get_it/get_it.dart';
import 'package:paitent/networking/ApiProvider.dart';
import 'package:paitent/utils/SharedPrefUtils.dart';
import 'package:paitent/utils/StringUtility.dart';

class GetAllConfigrations {
  //ApiProvider apiProvider = new ApiProvider();

  ApiProvider apiProvider = GetIt.instance<ApiProvider>();

  var _sharedPrefUtils = new SharedPrefUtils();

  GetAllConfigrations() {
    _getMedicationDosageUnits();
    _getMedicationFrequencies();
    _getMedicationDurationUnits();
    //_getAllLabSamples();
    //_getAllSymptoms();
    //_getAllDygnoses();
  }

  _getMedicationDosageUnits() async {
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;
    var response =
        await apiProvider.get('/types/medication-dosage-units', header: map);
    print('Medication Dosage Units ==> $response');
    _sharedPrefUtils.save("MedicationDosageUnits", response);
    // Convert and return
  }

  _getMedicationFrequencies() async {
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;
    var response =
        await apiProvider.get('/types/medication-frequency-units', header: map);
    print("Medication Frequencies ==> $response");
    _sharedPrefUtils.save("MedicationFrequencies", response);
    // Convert and return
  }

  _getMedicationDurationUnits() async {
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;
    var response =
        await apiProvider.get('/types/medication-duration-units', header: map);
    print('Medication Duration Units ==> $response');
    _sharedPrefUtils.save("MedicationDurationUnits", response);
    // Convert and return
  }

  _getAllLabSamples() async {
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;
    var response =
        await apiProvider.get('/types/pathology-samples', header: map);
    print(response);
    _sharedPrefUtils.save("LabSamples", response);
    // Convert and return
  }

  _getAllSymptoms() async {
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;
    var response = await apiProvider.get('/types/symptoms', header: map);
    print(response);
    _sharedPrefUtils.save("Symptoms", response);
    // Convert and return
  }

  _getAllDygnoses() async {
    var map = new Map<String, String>();
    map["Content-Type"] = "application/json";
    map["authorization"] = 'Bearer ' + auth;
    var response = await apiProvider.get('/types/ailments', header: map);
    print(response);
    _sharedPrefUtils.save("Dygnoses", response);
    // Convert and return
  }
}
