import 'package:paitent/features/common/appoinment_booking/models/doctorListApiResponse.dart';
import 'package:paitent/features/common/appoinment_booking/models/labsListApiResponse.dart';
import 'package:paitent/features/misc/models/PatientApiDetails.dart';
import 'package:paitent/features/misc/models/user_data.dart';

class DoctorBookingAppoinmentPojo {
  String whichFlow = '';
  Labs labs;
  Doctors doctors;
  String selectedDate;
  String slotStart;
  String slotEnd;
  Patient patient;
  UserData userData;
  String patientNote;
  String attachmentPath = '';
}
