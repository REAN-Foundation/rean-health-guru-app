import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paitent/core/constants/route_paths.dart';
import 'package:paitent/core/models/post.dart';
import 'package:paitent/features/common/appoinment_booking/ui/bookingAppoinmentConformation.dart';
import 'package:paitent/features/common/appoinment_booking/ui/booking_confirm_screen.dart';
import 'package:paitent/features/common/appoinment_booking/ui/booking_info_view.dart';
import 'package:paitent/features/common/appoinment_booking/ui/date_and_time_for_book_Appoinment_view.dart';
import 'package:paitent/features/common/appoinment_booking/ui/date_and_time_for_labs_book_Appoinment_view.dart';
import 'package:paitent/features/common/appoinment_booking/ui/doctor_detail_view.dart';
import 'package:paitent/features/common/appoinment_booking/ui/lab_detail_view.dart';
import 'package:paitent/features/common/appoinment_booking/ui/payment_conformation.dart';
import 'package:paitent/features/common/appoinment_booking/ui/search_doctor_list_view.dart';
import 'package:paitent/features/common/appoinment_booking/ui/search_lab_list_view.dart';
import 'package:paitent/features/common/careplan/ui/BiomatricTask.dart';
import 'package:paitent/features/common/careplan/ui/add_goals_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/approve_doctor_for_goal_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/assement_task_navigator.dart';
import 'package:paitent/features/common/careplan/ui/assessment_final_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/assessment_question_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/assessment_question_two_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/assessment_start_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/challenge_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/goals/add_blood_presure_goals_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/goals/add_cholesterol_goals_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/goals/add_glucose_level_goals_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/goals/add_nutrition_goals_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/goals/add_physical_activity_goals_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/goals/add_quit_smoking_goals_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/goals/add_weight_goals_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/goals/determine_action_care_plan_goals.dart';
import 'package:paitent/features/common/careplan/ui/goals/select_goal_set_care_plan_goals.dart';
import 'package:paitent/features/common/careplan/ui/goals/set_priorities_set_care_plan_goals.dart';
import 'package:paitent/features/common/careplan/ui/lean_more_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/mind_full_moment_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/my_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/quiz_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/select_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/self_reflection_week_1.dart';
import 'package:paitent/features/common/careplan/ui/set_goals_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/set_up_doctor_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/set_up_family_member_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/set_up_nurse_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/set_up_pharmacy_for_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/start_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/statusPastCheckTask.dart';
import 'package:paitent/features/common/careplan/ui/successfully_setup_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/video_more_care_plan.dart';
import 'package:paitent/features/common/careplan/ui/word_of_the_week_care_plan.dart';
import 'package:paitent/features/common/medication/ui/add_my_medication.dart';
import 'package:paitent/features/common/medication/ui/my_medication.dart';
import 'package:paitent/features/common/nutrition/ui/my_daily_nutrition_view.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricBloodOxygenVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricBloodPresureVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricBloodSugartVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricBodyTempratureVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricPulseVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiomatricWeightVitals.dart';
import 'package:paitent/features/common/vitals/ui/BiometricVitalsTrendsView.dart';
import 'package:paitent/infra/themes/app_colors.dart';
import 'package:paitent/infra/utils/CommonUtils.dart';
import 'package:paitent/ui/views/AfterSplashScreen.dart';
import 'package:paitent/ui/views/OnBoardingAhaPage.dart';
import 'package:paitent/ui/views/OnBoardingPage.dart';
import 'package:paitent/ui/views/about_rean_care.dart';
import 'package:paitent/ui/views/chat/FAQChatScreen.dart';
import 'package:paitent/ui/views/create_profile_view.dart';
import 'package:paitent/ui/views/edit_patient_medical_profile.dart';
import 'package:paitent/ui/views/edit_profile_view.dart';
import 'package:paitent/ui/views/home_view.dart';
import 'package:paitent/ui/views/login_with_otp_view.dart';
import 'package:paitent/ui/views/myReportsUpload.dart';
import 'package:paitent/ui/views/otp_screen_view.dart';
import 'package:paitent/ui/views/patient_medical_profile.dart';
import 'package:paitent/ui/views/post_view.dart';
import 'package:paitent/ui/views/splashScreen.dart';
import 'package:paitent/ui/views/support_view.dart';
import 'package:paitent/ui/views/symptoms_view.dart';
import 'package:paitent/ui/views/userActivity/MeditationTimmerView.dart';
import 'package:paitent/ui/views/userActivity/view_my_daily_activity.dart';
import 'package:paitent/ui/views/userActivity/view_my_daily_sleep.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Splash_Screen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(
            seconds: 3,
            navigateAfterSeconds: AfterSplashScreen(getSessionFlag()),
            title: Text('REAN HealthGuru\n\nDev-Build',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            image: Image.asset('res/images/app_logo_tranparent.png'),
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
            builder: (_) => OTPScreenView(settings.arguments));
      case RoutePaths.CREATE_PROFILE:
        return MaterialPageRoute(builder: (_) => CreateProfile());
      case RoutePaths.ABOUT_REAN_CARE:
        return MaterialPageRoute(builder: (_) => AboutREANCareView());
      case RoutePaths.CONTACT_US:
        return MaterialPageRoute(builder: (_) => SupportView());
      case RoutePaths.Payment_Confirmation_View:
        return MaterialPageRoute(builder: (_) => PaymentConfirmationView());
      case RoutePaths.Booking_Appoinment_Confirmation_View:
        return MaterialPageRoute(
            builder: (_) =>
                BookingAppoinmentConfirmationView(settings.arguments));
      case RoutePaths.Lab_Details_View:
        return MaterialPageRoute(
            builder: (_) => LabDetailsView(settings.arguments));
      case RoutePaths.Search_Lab_List_View:
        return MaterialPageRoute(builder: (_) => SearchLabListView());
      case RoutePaths.Doctor_Details_View:
        return MaterialPageRoute(
            builder: (_) => DoctorDetailsView(settings.arguments));
      case RoutePaths.Search_Doctor_List_View:
        return MaterialPageRoute(builder: (_) => SearchDoctorListView());
      case RoutePaths.Booking_Appoinment_Done_View:
        return MaterialPageRoute(
            builder: (_) => BookingConfirmedView(settings.arguments));
      case RoutePaths.Booking_Appoinment_Info_View:
        return MaterialPageRoute(
            builder: (_) => BookingInfoView(settings.arguments));
      case RoutePaths.Select_Date_And_Time_Lab_Book_Appoinment:
        return MaterialPageRoute(
            builder: (_) =>
                DateAndTimeForLabsBookAppoinmentView(settings.arguments));
      case RoutePaths.Select_Date_And_Time_Book_Appoinment:
        return MaterialPageRoute(
            builder: (_) =>
                DateAndTimeForBookAppoinmentView(settings.arguments));
      case RoutePaths.Edit_Profile:
        return MaterialPageRoute(builder: (_) => EditProfile());
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => HomeView(0));
      case RoutePaths.Symptoms:
        return MaterialPageRoute(
            builder: (_) => SymptomsView(settings.arguments));
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginWithOTPView());
      case RoutePaths.My_Vitals:
        //return MaterialPageRoute(builder: (_) => BiometricVitalsView());
        return MaterialPageRoute(builder: (_) => BiometricVitalsTrendsView());
      case RoutePaths.My_Activity:
        return MaterialPageRoute(builder: (_) => ViewMyDailyActivity());
      case RoutePaths.MySleepData:
        return MaterialPageRoute(builder: (_) => ViewMyDailySleep());
      case RoutePaths.My_Nutrition:
        return MaterialPageRoute(
            builder: (_) => MyDailyNutritionView(settings.arguments));
      case RoutePaths.Meditation:
        return MaterialPageRoute(builder: (_) => MeditationTimmerView());
      /*case RoutePaths.My_Vitals_By_Device_Framework:
        return MaterialPageRoute(builder: (_) => BiomatricVitalsByDeviceFrameWork());*/
      case RoutePaths.Biometric_Weight_Vitals_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => BiometricWeightVitalsView(true));
      case RoutePaths.Biometric_Blood_Presure_Vitals_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => BiometricBloodPresureVitalsView(true));
      case RoutePaths.Biometric_Blood_Glucose_Vitals_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => BiometricBloodSugarVitalsView(true));
      case RoutePaths.Biometric_Blood_Oxygen_Vitals_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => BiometricBloodOxygenVitalsView());
      case RoutePaths.Biometric_Pulse_Vitals_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => BiometricPulseVitalsView(true));
      case RoutePaths.Biometric_Temperature_Vitals_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => BiometricBodyTemperatureVitalsView());
      case RoutePaths.My_Medical_Profile:
        return MaterialPageRoute(builder: (_) => PatientMedicalProfileView());
      case RoutePaths.Patient_EDIT_MEDIACL_PROFILE:
        return MaterialPageRoute(
            builder: (_) => EditPatientMedicalProfileView(settings.arguments));
      case RoutePaths.My_Medications:
        return MaterialPageRoute(builder: (_) => MyMedicationView());
      case RoutePaths.ADD_MY_MEDICATION:
        return MaterialPageRoute(builder: (_) => AddMyMedicationView());
      case RoutePaths.My_Care_Plan:
        return MaterialPageRoute(builder: (_) => MyCarePlanView());
      case RoutePaths.Select_Care_Plan:
        return MaterialPageRoute(builder: (_) => SelectCarePlanView());
      case RoutePaths.Start_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => StartCarePlanView(settings.arguments));
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
            builder: (_) => LearnMoreCarePlanView(settings.arguments));
      case RoutePaths.Video_More_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => VideoMoreCarePlanView(settings.arguments));
      case RoutePaths.Mindfull_Moment_Care_Plan:
        return MaterialPageRoute(builder: (_) => MindFullMomentCarePlanView());
      case RoutePaths.Challenge_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => ChallengeCarePlanView(settings.arguments));
      case RoutePaths.Word_Of_The_Week_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => WordOfTheWeekCarePlanView(settings.arguments));
      case RoutePaths.Quiz_Care_Plan:
        return MaterialPageRoute(builder: (_) => QuizForCarePlanView());
      case RoutePaths.Assessment_Navigator:
        return MaterialPageRoute(
            builder: (_) => AssesmentTaskNavigatorView(settings.arguments));
      case RoutePaths.Biometric_Care_Plan_Line:
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
        return MaterialPageRoute(
            builder: (_) => SetPrioritiesGoalsForCarePlanView());
      case RoutePaths.Select_Goals_Care_Plan:
        return MaterialPageRoute(builder: (_) => SelectGoalsForCarePlanView());
      case RoutePaths.Determine_Action_For_Care_Plan:
        return MaterialPageRoute(
            builder: (_) => DeterminActionPlansForCarePlanView());
      case RoutePaths.Set_Goals_Care_Plan:
        return MaterialPageRoute(builder: (_) => SetGoalPlanCarePlanView());
      case RoutePaths.Self_Reflection_For_Goals_Care_Plan:
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
        return MaterialPageRoute(builder: (_) => MyReportsView());
      case RoutePaths.FAQ_BOT:
        return MaterialPageRoute(builder: (_) => FAQChatScreen());
      /* case RoutePaths.Order_Medicine:
        return MaterialPageRoute(builder: (_) =>
      case RoutePaths.Order_Ambulance:
        return MaterialPageRoute(builder: (_) => ;*/
      case RoutePaths.Post:
        final post = settings.arguments as Post;
        return MaterialPageRoute(builder: (_) => PostView(post: post));
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
