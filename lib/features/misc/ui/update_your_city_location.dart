import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';

//ignore: must_be_immutable
class UpdateYourCityLocation extends StatefulWidget {

  late String city;

  UpdateYourCityLocation(this.city);


  @override
  _UpdateYourCityLocation createState() => _UpdateYourCityLocation();
}

class _UpdateYourCityLocation extends State<UpdateYourCityLocation> {
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();
  bool busy = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 220,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 4,
                ),
                Semantics(
                  focused: true,
                  child: Text(
                    "Do you want to update your location?",
                    semanticsLabel: "Do you want to update your location?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: primaryColor),//Color(0XFF383739)
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SingleChildScrollView(
                  child: Text(
                    "Your current location is ${widget.city}. By updating your current location it will make sure you get medication reminders adjusted to your timezone.",
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: textGrey),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                busy ? Center(child: CircularProgressIndicator()) : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Semantics(
                        button: true,
                        label: 'Cancel update location',
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'cancel_update_location_button_click');
                              Navigator.pop(context);
                              //Future.delayed(const Duration(seconds: 2), () => showDailyCheckIn());
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width - 32,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border:
                                  Border.all(color: primaryColor, width: 1),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: Semantics(
                        button: true,
                        label: 'Update your current location',
                        child: ExcludeSemantics(
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(name: 'update_location_button_click');
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width - 32,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border:
                                  Border.all(color: primaryColor, width: 1),
                                  color: primaryColor),
                              child: Center(
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  updateLocation() async {
    setBusy(true);
    final map = <String, String>{};
    map['Content-Type'] = 'application/json';
    map['authorization'] = 'Bearer ' + auth!;

    final body = <String, dynamic>{};
    final address = <String, String?>{};
    address['City'] = widget.city.trim();
    body['Address'] = address;

    try {
      final BaseResponse updateProfileSuccess = await apiProvider!.put('/patients/' + patientUserId!, body: body, header: map);

      if (updateProfileSuccess.status == 'success') {
        getPatientDetails();
      } else {
        setBusy(false);
      }
    } on FetchDataException catch (e) {
      setBusy(false);
      debugPrint('error caught: $e');
    }
  }

  getPatientDetails() async {
    try {

      final map = <String, String>{};
      map['Content-Type'] = 'application/json';
      map['authorization'] = 'Bearer ' + auth!;

      final response =
      await apiProvider!.get('/patients/' + patientUserId!, header: map);

      final PatientApiDetails apiResponse =
      PatientApiDetails.fromJson(response);

      if (apiResponse.status == 'success') {
        debugPrint("Patient User Details ==> ${apiResponse.data!.patient!.user!.person!
            .toJson()
            .toString()}");
        await _sharedPrefUtils.save(
            'patientDetails', apiResponse.data!.patient!.toJson());
        Navigator.pop(context);
      } else {
        setBusy(false);
      }
    } catch (CustomException) {
      setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

  setBusy(bool flag){
    busy = flag;
    setState(() {});
  }

}
