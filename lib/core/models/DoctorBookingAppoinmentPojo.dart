import 'package:json_annotation/json_annotation.dart';
@JsonSerializable(nullable: true)
import 'package:paitent/core/models/PatientApiDetails.dart';
import 'package:paitent/core/models/doctorListApiResponse.dart';
import 'package:paitent/core/models/labsListApiResponse.dart';
import 'package:paitent/core/models/user_data.dart';

class DoctorBookingAppoinmentPojo {
  String whichFlow = "";
  Labs labs;
  Doctors doctors;
  String selectedDate;
  String slotStart;
  String slotEnd;
  Patient patient;
  UserData userData;
  String patientNote;
  String attachmentPath = "";
}
