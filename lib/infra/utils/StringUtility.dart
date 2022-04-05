import 'package:paitent/features/common/appoinment_booking/models/doctorListApiResponse.dart';
import 'package:paitent/features/common/appoinment_booking/models/pharmacyListApiResponse.dart';
import 'package:paitent/features/common/careplan/models/AddTeamMemberResponse.dart';

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
