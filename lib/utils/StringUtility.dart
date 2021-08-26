

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paitent/core/models/AddTeamMemberResponse.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/pharmacyListApiResponse.dart';

String auth = "";
String patientUserId= "";
String patientGender= "";
int assrotedUICount = 1;
var doctorSearchListGlobe = new List<Doctors>();
var parmacySearchListGlobe = new List<Pharmacies>();
var nurseMemberListGlobe = new List<TeamMember>();
var familyMemberListGlobe = new List<TeamMember>();

/*
void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}*/
