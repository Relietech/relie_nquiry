import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:relie_nquiry/add_enquiry/new_form_page.dart';
import 'package:relie_nquiry/add_enquiry/schedule_form_page.dart';
import 'package:relie_nquiry/admin/admin_dashboard_page.dart';
import 'package:relie_nquiry/admin/admin_enquiry_page.dart';
import 'package:relie_nquiry/admin/admin_followp_page.dart';
import 'package:relie_nquiry/admin/admin_employee_page.dart';
import 'package:relie_nquiry/admin/edit_user_page.dart';
import 'package:relie_nquiry/admin/new_emp_create_page.dart';
import 'package:relie_nquiry/admin/user_details_page.dart';
import 'package:relie_nquiry/followup/status_page.dart';
import 'package:relie_nquiry/pages/profile_edit_page.dart';
import 'package:relie_nquiry/pages/profile_page.dart';
import 'package:relie_nquiry/screen/bottombar.dart';
import '../followup/followup_details.dart';
import '../followup/followup_screen.dart';
import '../pages/login_page.dart';
import '../pages/quotation_page.dart';
import '../pages/register.dart';
import '../screen/notification_page.dart';
import '../screen/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    //  GetPage(name: Routes.selectEnquiry, page: () => SelectEnquiryPage()),
    GetPage(
      name: Routes.addEnquiryForm,
      page: () => NewFormPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: Routes.followUpScreen,
      page: () => FollowupScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.logInPage,
      page: () => LoginPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    // GetPage(name: Routes.logInTech, page: () => LoginTech()),
    GetPage(
      name: Routes.homeScreen,
      page: () => BottomBarPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.adminpage,
      page: () => AdminDashboardPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.scheduleFormPage,
      page: () => ScheduleFormPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),

    /// admin Add Employee Page
    GetPage(
      name: Routes.adminEmployeeListing,
      page: () => AdminEmployeePage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.statusPage,
      page: () => StatusPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.splashScreen,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.registerPage,
      page: () => RegisterPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.adminpage,
      page: () => AdminDashboardPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.userProfile,
      page: () => AdminEmployeeDetailsPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.followUpDetailsScreen,
      page: () => FollowDetailsPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfilePage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.profileEdit,
      page: () => ProfileEditPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.userEdit,
      page: () => EditUserPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.notificationScreen,
      page: () => NotificationPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.adminEnquiry,
      page: () => AdminEnquiryPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.adminFollowup,
      page: () => AdminFollowupPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.addEmployee,
      page: () => EmployeeCreatePage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
    GetPage(
      name: Routes.quotationPage,
      page: () => QuotationPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 100),
    ),
  ];
}
