import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/appointment_booking/models/pharmacy_list_api_response.dart';
import 'package:patient/features/common/careplan/models/add_team_member_response.dart';

String? auth = '';
String? patientUserId = '';
String? patientGender = '';
int assrotedUICount = 1;
var doctorSearchListGlobe = <Doctors>[];
var parmacySearchListGlobe = <Pharmacies>[];
var nurseMemberListGlobe = <TeamMember?>[];
var familyMemberListGlobe = <TeamMember?>[];

/*
void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}*/
