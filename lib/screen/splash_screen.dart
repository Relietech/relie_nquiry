import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relie_nquiry/constants/funtions/asset_image.dart';
import '../constants/app_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is logged in → navigate to home
        Get.offAllNamed(Routes.homeScreen);
      } else {
        // Not logged in → navigate to login
        Get.offAllNamed(Routes.logInPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssetImages.appLogo, height: 120),
            const SizedBox(height: 20),
            const Text(
              'NQuiry',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Smart Way to Manage Your Enquiries',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
           // const Spacer(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: AppButton.AppCustomButton(
            //       paddingVertical: 12,
            //       onTap: () {
            //         final user = FirebaseAuth.instance.currentUser;
            //
            //         if (user != null) {
            //           Get.offAllNamed(Routes.homeScreen);
            //         } else {
            //           Get.offAllNamed(Routes.logInPage);
            //         }
            //       },
            //       text: 'Continue',
            //       style: AppTextStyles.white16bold,
            //       color: AppColors.appColor,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
