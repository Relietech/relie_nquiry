import 'package:flutter/material.dart';

class AppConstants {
  static const String companyName = "Relietech"; // Fixed company
  static const double kPadding = 10.0;
  static const String poppins = "Poppins";

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static const String kGoogleApiKey = "AIzaSyBp_LotALPZ3Tgsqh1MlkcPzF5u74WtC0U";

  /// 👇 Add this line
  static const String baseUrl = "http://192.168.1.63/relie_enquiry";

  /// ScreenSize
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Navigate
  static changeScreen(BuildContext context, page) {
    return Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    ));
  }

  /// AppSizedBox
  static const appSizedBoxHeight = SizedBox(height: 15);
  static const appSizedBoxWidth = SizedBox(width: 15);
}
