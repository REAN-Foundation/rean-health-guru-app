import 'package:paitent/core/models/AddTeamMemberResponse.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/pharmacyListApiResponse.dart';

String auth = '';
String patientUserId = '';
String patientGender = '';
int assrotedUICount = 1;
var doctorSearchListGlobe = <Doctors>[];
var parmacySearchListGlobe = <Pharmacies>[];
var nurseMemberListGlobe = <TeamMember>[];
var familyMemberListGlobe = <TeamMember>[];

/*
void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}*/
