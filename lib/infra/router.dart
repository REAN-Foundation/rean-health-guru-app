import 'package:flutter/material.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/common/achievement/ui/all_achivement_view.dart';
import 'package:patient/features/common/activity/ui/activity_meditation.dart';
import 'package:patient/features/common/activity/ui/activity_sleep.dart';
import 'package:patient/features/common/activity/ui/all_mental_well_being_view.dart';
import 'package:patient/features/common/activity/ui/all_movements_view.dart';
import 'package:patient/features/common/activity/ui/meditation_timmer_view.dart';
import 'package:patient/features/common/activity/ui/view_my_all_daily_activity.dart';
import 'package:patient/features/common/activity/ui/view_my_all_daily_stress.dart';
import 'package:patient/features/common/appointment_booking/ui/booking_appointment_confirmation.dart';
import 'package:patient/features/common/appointment_booking/ui/booking_confirm_screen.dart';
import 'package:patient/features/common/appointment_booking/ui/booking_info_view.dart';
import 'package:patient/features/common/appointment_booking/ui/date_and_time_for_book_appointment_view.dart';
import 'package:patient/features/common/appointment_booking/ui/date_and_time_for_labs_book_appointment_view.dart';
import 'package:patient/features/common/appointment_booking/ui/doctor_detail_view.dart';
import 'package:patient/features/common/appointment_booking/ui/lab_detail_view.dart';
import 'package:patient/features/common/appointment_booking/ui/payment_confirmation.dart';
import 'package:patient/features/common/appointment_booking/ui/search_doctor_list_view.dart';
import 'package:patient/features/common/appointment_booking/ui/search_lab_list_view.dart';
import 'package:patient/features/common/careplan/models/assorted_view_configs.dart';
import 'package:patient/features/common/careplan/models/create_health_priority_response.dart';
import 'package:patient/features/common/careplan/models/get_user_task_details.dart';
import 'package:patient/features/common/careplan/ui/add_goals_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/approve_doctor_for_goal_careplan.dart';
import 'package:patient/features/common/careplan/ui/assessment_final_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/assessment_question_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/assessment_question_two_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/assessment_score_plan.dart';
import 'package:patient/features/common/careplan/ui/assessment_start_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/assessment_task_navigator.dart';
import 'package:patient/features/common/careplan/ui/biometric_task.dart';
import 'package:patient/features/common/careplan/ui/challenge_careplan.dart';
import 'package:patient/features/common/careplan/ui/goals/add_blood_pressure_goals_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/goals/add_cholesterol_goals_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/goals/add_glucose_level_goals_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/goals/add_nutrition_goals_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/goals/add_physical_activity_goals_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/goals/add_quit_smoking_goals_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/goals/add_weight_goals_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/goals/determine_action_careplan_goals.dart';
import 'package:patient/features/common/careplan/ui/goals/select_goal_set_careplan_goals.dart';
import 'package:patient/features/common/careplan/ui/goals/set_priorities_set_careplan_goals.dart';
import 'package:patient/features/common/careplan/ui/lean_more_careplan.dart';
import 'package:patient/features/common/careplan/ui/mindfulness_moment_careplan.dart';
import 'package:patient/features/common/careplan/ui/my_careplan.dart';
import 'package:patient/features/common/careplan/ui/quiz_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/rss_feild_display.dart';
import 'package:patient/features/common/careplan/ui/select_careplan.dart';
import 'package:patient/features/common/careplan/ui/self_reflection_week_1.dart';
import 'package:patient/features/common/careplan/ui/set_goals_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/set_up_doctor_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/set_up_family_member_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/set_up_nurse_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/set_up_pharmacy_for_careplan.dart';
import 'package:patient/features/common/careplan/ui/start_careplan.dart';
import 'package:patient/features/common/careplan/ui/status_past_check_task.dart';
import 'package:patient/features/common/careplan/ui/successfully_setup_careplan.dart';
import 'package:patient/features/common/careplan/ui/video_more_careplan.dart';
import 'package:patient/features/common/careplan/ui/word_of_the_week_careplan.dart';
import 'package:patient/features/common/chat_bot/ui/faq_chat_screen.dart';
import 'package:patient/features/common/health_device/ui/connect_health_devices.dart';
import 'package:patient/features/common/lab_management/ui/biometric_cholesterol_trends_view.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_a1clevel.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_hdl.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_ldl.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_total_cholesterol.dart';
import 'package:patient/features/common/lab_management/ui/lipid_profile_triglycerides.dart';
import 'package:patient/features/common/medication/ui/add_my_medication.dart';
import 'package:patient/features/common/medication/ui/my_medication.dart';
import 'package:patient/features/common/nutrition/ui/nutrition_questionnaire_view.dart';
import 'package:patient/features/common/remainder/ui/add_my_remainder.dart';
import 'package:patient/features/common/vitals/ui/abnormal_reading_bp.dart';
import 'package:patient/features/common/vitals/ui/biometric_blood_glucose_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_blood_oxygen_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_blood_pressure_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_body_temperature_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_pulse_vitals.dart';
import 'package:patient/features/common/vitals/ui/biometric_vitals_trends_view.dart';
import 'package:patient/features/common/vitals/ui/biometric_weight_vitals.dart';
import 'package:patient/features/misc/models/patient_medical_profile_pojo.dart';
import 'package:patient/features/misc/ui/about_rean_care.dart';
import 'package:patient/features/misc/ui/after_splash_screen.dart';
import 'package:patient/features/misc/ui/create_profile_view.dart';
import 'package:patient/features/misc/ui/customize_health_report.dart';
import 'package:patient/features/misc/ui/edit_patient_medical_profile.dart';
import 'package:patient/features/misc/ui/edit_profile_view.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/features/misc/ui/login_with_otp_view.dart';
import 'package:patient/features/misc/ui/my_reports_upload.dart';
import 'package:patient/features/misc/ui/on_boarding_aha_page.dart';
import 'package:patient/features/misc/ui/on_boarding_page.dart';
import 'package:patient/features/misc/ui/otp_screen_view.dart';
import 'package:patient/features/misc/ui/patient_medical_profile.dart';
import 'package:patient/features/misc/ui/splash_screen.dart';
import 'package:patient/features/misc/ui/support_network_view.dart';
import 'package:patient/features/misc/ui/support_view.dart';
import 'package:patient/features/misc/ui/symptoms_view.dart';
import 'package:patient/infra/services/user_analytics_service.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

import '../features/common/remainder/ui/view_my_remainder.dart';

class Routers {


  static Route<dynamic> generateRoute(RouteSettings settings) {
    String eventType = '';
    String eventCategory = '';
    String eventSubject = '';
    switch (settings.name) {
      case RoutePaths.Splash_Screen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(
            seconds: 5,
            navigateAfterSeconds: AfterSplashScreen(getSessionFlag()),
            title: Text('REAN HealthGuru\n\nDev-Build',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            image: Image.asset('res/images/app_logo_transparent.png'),
            backgroundColor: primaryColor,
            styleTextUnderTheLoader: TextStyle(),
            photoSize: 100.0,
            loaderColor: Colors.transparent,
            baseUrl: getBaseUrl(),
          ),
        );
      case RoutePaths.On_Boarding:
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
      case RoutePaths.On_Boarding_AHA:
        return MaterialPageRoute(builder: (_) => OnBoardingAhaPage());
      case RoutePaths.OTP_Screen:
        return MaterialPageRoute(
            builder: (_) => OTPScreenView(settings.arguments as String?));
      case RoutePaths.CREATE_PROFILE:
        eventType = 'create-profile-screen';
        eventCategory = 'create-profile';
        eventSubject = 'create-profile-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => CreateProfile());
      case RoutePaths.ABOUT_REAN_CARE:
        eventType = 'about-screen';
        eventCategory = 'about';
        eventSubject = 'about-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => AboutREANCareView());
      case RoutePaths.CONTACT_US:
        eventType = 'contact-us-screen';
        eventCategory = 'contact-us';
        eventSubject = 'contact-us-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => SupportView());
      case RoutePaths.SUPPORT_NETWORK:
        eventType = 'support-network-screen';
        eventCategory = 'support-network';
        eventSubject = 'support-network-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => SupportNetworkView());
      case RoutePaths.Remainder:
        eventType = 'reminder-screen';
        eventCategory = 'reminder';
        eventSubject = 'reminder-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => ViewMyRemainderView());
      case RoutePaths.Add_Remainder:
        eventType = 'add-reminder-screen';
        eventCategory = 'reminder';
        eventSubject = 'add-reminder-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => AddMyRemainderView());
      case RoutePaths.Payment_Confirmation_View:
        return MaterialPageRoute(builder: (_) => PaymentConfirmationView());
      case RoutePaths.Booking_Appoinment_Confirmation_View:
        return MaterialPageRoute(
            builder: (_) => BookingAppoinmentConfirmationView(
                settings.arguments.runtimeType));
      case RoutePaths.Lab_Details_View:
        return MaterialPageRoute(
            builder: (_) => LabDetailsView(settings.arguments.runtimeType));
      case RoutePaths.Search_Lab_List_View:
        return MaterialPageRoute(builder: (_) => SearchLabListView());
      case RoutePaths.Doctor_Details_View:
        return MaterialPageRoute(
            builder: (_) => DoctorDetailsView(settings.arguments.runtimeType));
      case RoutePaths.Search_Doctor_List_View:
        return MaterialPageRoute(builder: (_) => SearchDoctorListView());
      case RoutePaths.Booking_Appoinment_Done_View:
        return MaterialPageRoute(
            builder: (_) =>
                BookingConfirmedView(settings.arguments.runtimeType));
      case RoutePaths.Booking_Appoinment_Info_View:
        return MaterialPageRoute(
            builder: (_) => BookingInfoView(settings.arguments.runtimeType));
      case RoutePaths.Select_Date_And_Time_Lab_Book_Appoinment:
        return MaterialPageRoute(
            builder: (_) => DateAndTimeForLabsBookAppoinmentView(
                settings.arguments.runtimeType));
      case RoutePaths.Select_Date_And_Time_Book_Appoinment:
        return MaterialPageRoute(
            builder: (_) => DateAndTimeForBookAppoinmentView(
                settings.arguments.runtimeType));
      case RoutePaths.Abnormal_Reading:
        eventType = 'abnormal-bp_reading-screen';
        eventCategory = 'abnormal-bp_reading';
        eventSubject = 'abnormal-bp_reading-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => AbnormalReadingBpView());
      case RoutePaths.Edit_Profile:
        eventType = 'edit-profile-screen';
        eventCategory = 'edit-profile';
        eventSubject = 'edit-profile-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => EditProfile());
      case RoutePaths.Home:
        eventType = 'home-screen';
        eventCategory = 'home';
        eventSubject = 'home-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => HomeView(0));
      case RoutePaths.Symptoms:
        eventType = 'symptoms-screen';
        eventCategory = 'symptoms';
        eventSubject = 'symptoms-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => SymptomsView(settings.arguments as String?));
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginWithOTPView());
      case RoutePaths.My_Vitals:
        eventType = 'vitals-screen';
        eventCategory = 'vitals';
        eventSubject = 'vitals-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        //return MaterialPageRoute(builder: (_) => BiometricVitalsView());
        return MaterialPageRoute(builder: (_) => BiometricVitalsTrendsView());
      case RoutePaths.MY_STRESS:
        eventType = 'stress-screen';
        eventCategory = 'stress';
        eventSubject = 'stress-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => ViewMyAllDailyStress(true));
      case RoutePaths.My_Activity:
        eventType = 'activity-screen';
        eventCategory = 'activity';
        eventSubject = 'activity-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => //ViewMyDailyActivity());
                ViewMyAllDailyActivity(settings.arguments as String?));
      case RoutePaths.My_Activity_Trends:
        eventType = 'activity-trends-screen';
        eventCategory = 'activity-trends';
        eventSubject = 'activity-trends-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => AllMovementsView(settings.arguments as int));
      case RoutePaths.My_Activity_Mindfullness:
        eventType = 'activity-mindfulness-screen';
        eventCategory = 'activity-mindfulness';
        eventSubject = 'activity-mindfulness-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => AllMentalWellBeingView(settings.arguments as int));
      case RoutePaths.MySleepData:
        eventType = 'sleep-screen';
        eventCategory = 'sleep';
        eventSubject = 'sleep-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => ActivitySleepView(true,(){}));
      case RoutePaths.My_Nutrition:
        eventType = 'nutrition-screen';
        eventCategory = 'nutrition';
        eventSubject = 'nutrition-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) =>
                NutritionQuestionnaireView(settings.arguments as String?));
      case RoutePaths.Meditation:
        eventType = 'meditation-screen';
        eventCategory = 'meditation';
        eventSubject = 'meditation-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => MeditationTimmerView());
      case RoutePaths.Meditation_Trends:
        eventType = 'meditation-trends-screen';
        eventCategory = 'meditation';
        eventSubject = 'meditation-trends-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => ActivityMeditationView(true,(){}));
      /*case RoutePaths.My_Vitals_By_Device_Framework:
        return MaterialPageRoute(builder: (_) => BiomatricVitalsByDeviceFrameWork());*/
      case RoutePaths.Biometric_Weight_Vitals_Care_Plan:
        eventType = 'vitals-weight-screen';
        eventCategory = 'vitals-weight';
        eventSubject = 'vitals-weight-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => BiometricWeightVitalsView(true));
      case RoutePaths.Biometric_Blood_Presure_Vitals_Care_Plan:
        eventType = 'vitals-blood-pressure-screen';
        eventCategory = 'vitals-blood-pressure';
        eventSubject = 'vitals-blood-pressure-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => BiometricBloodPresureVitalsView(true));
      case RoutePaths.Biometric_Blood_Glucose_Vitals_Care_Plan:
        eventType = 'vitals-blood-glucose-screen';
        eventCategory = 'vitals-blood-glucose';
        eventSubject = 'vitals-blood-glucose-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => BiometricBloodSugarVitalsView(true));
      case RoutePaths.Biometric_Blood_Oxygen_Vitals_Care_Plan:
        eventType = 'vitals-blood-oxygen';
        eventCategory = 'vitals-blood-oxygen';
        eventSubject = 'vitals-blood-oxygen-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => BiometricBloodOxygenVitalsView());
      case RoutePaths.Biometric_Pulse_Vitals_Care_Plan:
        eventType = 'vitals-pulse-screen';
        eventCategory = 'vitals-pulse';
        eventSubject = 'vitals-pulse-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => BiometricPulseVitalsView(true));
      case RoutePaths.Biometric_Temperature_Vitals_Care_Plan:
        eventType = 'vitals-temperature-screen';
        eventCategory = 'vitals-temperature';
        eventSubject = 'vitals-temperature-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => BiometricBodyTemperatureVitalsView());
      case RoutePaths.Lipid_Profile_LDL:
        eventType = 'lab-values-ldl-screen';
        eventCategory = 'lab-values-ldl';
        eventSubject = 'lab-values-ldl-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => LipidProfileLDLView(true));
      case RoutePaths.Lipid_Profile_HDL:
        eventType = 'lab-values-hdl-screen';
        eventCategory = 'lab-values-hdl';
        eventSubject = 'lab-values-hdl-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => LipidProfileHdlView(true));
      case RoutePaths.Lipid_Profile_Total_Cholesterol:
        eventType = 'lab-values-total-cholesterol-screen';
        eventCategory = 'lab-values-total-cholesterol';
        eventSubject = 'lab-values-total-cholesterol-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => LipidProfileTotalCholesterolView(true));
      case RoutePaths.Lipid_Profile_Triglyceroid:
        eventType = 'lab-values-triglyceroid-screen';
        eventCategory = 'lab-values-triglyceroid';
        eventSubject = 'lab-values-triglyceroid-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => LipidProfileTriglyceridesView(true));
      case RoutePaths.Lipid_Profile_A1CLevel:
        eventType = 'lab-values-a1c-screen';
        eventCategory = 'lab-values-a1c';
        eventSubject = 'lab-values-a1c-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => LipidProfileA1CLevelView(true));
      case RoutePaths.Lipid_Profile:
        eventType = 'lab-values-screen';
        eventCategory = 'lab-values';
        eventSubject = 'lab-values-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => BiometricCholesterolTrendsView());
      case RoutePaths.My_Medical_Profile:
        eventType = 'medical-profile-screen';
        eventCategory = 'medical-profile';
        eventSubject = 'medical-profile-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => PatientMedicalProfileView());
      case RoutePaths.Patient_EDIT_MEDIACL_PROFILE:
        eventType = 'edit-medical-profile-screen';
        eventCategory = 'edit-medical-profile';
        eventSubject = 'edit-medical-profile-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            settings: RouteSettings(name: "mProfile"),
            builder: (_) => EditPatientMedicalProfileView(
                settings.arguments as HealthProfile));
      case RoutePaths.My_Medications:
        eventType = 'medication-screen';
        eventCategory = 'medication';
        eventSubject = 'medication-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => MyMedicationView(settings.arguments as int));
      case RoutePaths.ADD_MY_MEDICATION:
        eventType = 'add-medication-screen';
        eventCategory = 'add-medication';
        eventSubject = 'add-medication-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => AddMyMedicationView(settings.arguments as String?));
      case RoutePaths.My_Care_Plan:
        eventType = 'view-health-journey-status-screen';
        eventCategory = 'health-journey-status';
        eventSubject = 'view-health-journey-status-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => MyCarePlanView());
      case RoutePaths.Select_Care_Plan:
        eventType = 'select-health-journey-screen';
        eventCategory = 'select-health-journey';
        eventSubject = 'select-health-journey-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => SelectCarePlanView());
      case RoutePaths.Start_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => StartCarePlanView(settings.arguments as String?));
      case RoutePaths.Setup_Doctor_For_Care_Plan:
        return MaterialPageRoute(builder: (_) => SetUpDoctorForCarePlanView());
      case RoutePaths.Setup_Pharmacies_For_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => SetUpPharmacyForCarePlanView());
      case RoutePaths.Setup_Nurse_For_Care_Plan:
        return MaterialPageRoute(builder: (_) => SetUpNurseForCarePlanView());
      case RoutePaths.Setup_Family_Member_For_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => SetUpFamilyMemberForCarePlanView());
      case RoutePaths.Successfully_Setup_For_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => SuccessfullySetupCarePlanView());
      case RoutePaths.Learn_More_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => LearnMoreCarePlanView(
                settings.arguments as AssortedViewConfigs));
      case RoutePaths.RSS_FEED_LIST:
        return MaterialPageRoute(
            builder: (_) =>
                RSSFeildDisplayView(settings.arguments as AssortedViewConfigs));
      case RoutePaths.Video_More_Care_Plan:
        eventType = 'video-task-screen';
        eventCategory = 'video-task';
        eventSubject = 'video-task-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) =>
                VideoMoreCarePlanView(settings.arguments.runtimeType));
      case RoutePaths.Mindfull_Moment_Care_Plan:
        return MaterialPageRoute(builder: (_) => MindFullMomentCarePlanView());
      case RoutePaths.Challenge_Care_Plan:
        eventType = 'challenge-task-screen';
        eventCategory = 'challenge-task';
        eventSubject = 'challenge-task-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) =>
                ChallengeCarePlanView(settings.arguments as UserTask));
      case RoutePaths.Word_Of_The_Week_Care_Plan:
        eventType = 'word-bank-task-screen';
        eventCategory = 'word-bank-task';
        eventSubject = 'word-bank-task-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) =>
                WordOfTheWeekCarePlanView(settings.arguments.runtimeType));
      case RoutePaths.Quiz_Care_Plan:
        return MaterialPageRoute(builder: (_) => QuizForCarePlanView());
      case RoutePaths.Assessment_Navigator:
        return MaterialPageRoute(
            builder: (_) =>
                AssesmentTaskNavigatorView(settings.arguments as UserTask));
      case RoutePaths.Assessment_Score_Navigator:
        eventType = 'assessment-score-screen';
        eventCategory = 'assessment-score';
        eventSubject = 'assessment-score-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) =>
                AssessmentScorePlanView(settings.arguments as String));
      case RoutePaths.Biometric_Care_Plan_Line:
        eventType = 'biometric-task-screen';
        eventCategory = 'biometric-task';
        eventSubject = 'biometric-task-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => BiomatricTask(settings.arguments));
      case RoutePaths.Assessment_Start_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => AssessmentStartCarePlanView(settings.arguments));
      case RoutePaths.Assessment_Question_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => AssessmentQuestionCarePlanView(settings.arguments));
      case RoutePaths.Assessment_Question_Two_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => AssessmentQuestionTwoCarePlanView());
      case RoutePaths.Assessment_Final_Care_Plan:
        return MaterialPageRoute(builder: (_) => AssessmentFinalCarePlanView());
      case RoutePaths.Set_Prority_For_Goals_Care_Plan:
        eventType = 'set-priority-goals-task-screen';
        eventCategory = 'set-priority-goals-task';
        eventSubject = 'set-priority-goals-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => SetPrioritiesGoalsForCarePlanView());
      case RoutePaths.Select_Goals_Care_Plan:
        eventType = 'select-goals-task-screen';
        eventCategory = 'select-goals-task';
        eventSubject = 'select-goals-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => SelectGoalsForCarePlanView(
                settings.arguments as CreateHealthPriorityResponse));
      case RoutePaths.Determine_Action_For_Care_Plan:
        eventType = 'action-goals-task-screen';
        eventCategory = 'action-goals-task';
        eventSubject = 'action-goals-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => DeterminActionPlansForCarePlanView());
      case RoutePaths.Set_Goals_Care_Plan:
        eventType = 'set-goals-task-screen';
        eventCategory = 'set-goals-task';
        eventSubject = 'set-goals-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => SetGoalPlanCarePlanView());
      case RoutePaths.Self_Reflection_For_Goals_Care_Plan:
        eventType = 'self-reflection-goals-task-screen';
        eventCategory = 'self-reflection-goals-task';
        eventSubject = 'self-reflection-goals-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(
            builder: (_) => SelfReflactionWeek_1_View(settings.arguments));
      case RoutePaths.Care_Plan_Status_Check:
        return MaterialPageRoute(
            builder: (_) => StatusPastCheckTask(settings.arguments));
      case RoutePaths.Add_Goals_Care_Plan:
        return MaterialPageRoute(builder: (_) => AddGoalsForCarePlanView());
      case RoutePaths.Approve_Doctor_Goals_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => ApproveDoctorForGoalCarePlanView());
      case RoutePaths.ADD_BLOOD_PRESURE_GOALS:
        return MaterialPageRoute(
            builder: (_) => AddBloodPresureeGoalsForCarePlanView());
      case RoutePaths.ADD_CHOLESTEROL_GOALS:
        return MaterialPageRoute(
            builder: (_) => AddCholesterolGoalsForCarePlanView());
      case RoutePaths.ADD_GLUCOSE_GOALS:
        return MaterialPageRoute(
            builder: (_) => AddGlucoseLevelGoalsForCarePlanView());
      case RoutePaths.ADD_NUTRITION_GOALS:
        return MaterialPageRoute(
            builder: (_) => AddNutritionGoalsForCarePlanView());
      case RoutePaths.ADD_PHYSICAL_ACTIVITY_GOALS:
        return MaterialPageRoute(
            builder: (_) => AddPhysicalActivityGoalsForCarePlanView());
      case RoutePaths.ADD_QUIT_SMOKING_GOALS:
        return MaterialPageRoute(
            builder: (_) => AddQuitSmokingGoalsForCarePlanView());
      case RoutePaths.ADD_WEIGHT_GOALS:
        return MaterialPageRoute(
            builder: (_) => AddWeightGoalsForCarePlanView());
      case RoutePaths.Doctor_Appoinment:
        return MaterialPageRoute(builder: (_) => SearchDoctorListView());
      case RoutePaths.Lab_Appoinment:
        return MaterialPageRoute(builder: (_) => SearchLabListView());
      case RoutePaths.My_Reports:
        eventType = 'reports-screen';
        eventCategory = 'reports';
        eventSubject = 'reports-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => MyReportsView());
      case RoutePaths.FAQ_BOT:
        eventType = 'faq-bot-screen';
        eventCategory = 'faq';
        eventSubject = 'faq-bot-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => FAQChatScreen());
      case RoutePaths.Connect_Health_Device:
        eventType = 'connect-health-device-screen';
        eventCategory = 'connect-health-device';
        eventSubject = 'connect-health-device-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => ConnectHealthDevicesView());
      case RoutePaths.Customize_Health_Report:
        eventType = 'customize-health-report-screen';
        eventCategory = 'customize-health-report';
        eventSubject = 'customize-health-report-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => CustomizeHealthReportView());
      case RoutePaths.ACHIEVEMENT:
        eventType = 'achievement-screen';
        eventCategory = 'achievement';
        eventSubject = 'achievement-screen-entry';
        UserAnalyticsServices.registerScreenEntryEvent(eventType, eventCategory, eventSubject, '', null);
        return MaterialPageRoute(builder: (_) => AllAchievementView());
      /* case RoutePaths.Order_Medicine:
        return MaterialPageRoute(builder: (_) =>
      case RoutePaths.Order_Ambulance:
        return MaterialPageRoute(builder: (_) => ;*/
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
