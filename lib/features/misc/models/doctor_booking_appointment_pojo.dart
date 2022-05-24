import 'package:patient/features/common/appointment_booking/models/doctor_list_api_response.dart';
import 'package:patient/features/common/appointment_booking/models/labs_list_api_response.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/user_data.dart';

class DoctorBookingAppoinmentPojo {
  String whichFlow = '';
  Labs? labs;
  Doctors? doctors;
  late String selectedDate;
  String? slotStart;
  String? slotEnd;
  Patient? patient;
  UserData? userData;
  late String patientNote;
  String? attachmentPath = '';
}
