import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:relie_nquiry/routes/app_routes.dart';

import '../constants/app_text_styles.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            ClipPath(
              // clipper: ArcClipper(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.themeBlue,
                 // gradient: AppColors.themGradient,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back icon aligned to top-left
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.homeScreen);
                          },
                          child: const Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    // Title centered at the top
                    const Text(
                      "Admin Dashboard",
                      style: AppTextStyles.appBarWhite21bold,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column (higher position)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cards(
                            alignmentBegin: Alignment.bottomRight,
                            alignmentEnd: Alignment.topLeft,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            title: "Add Employee",
                            icon: Icons.account_circle_outlined,
                            // imagePath: "asset/image/add-friend.png",
                            onTap:
                                () => Get.toNamed(Routes.adminEmployeeListing),
                          ),
                          const SizedBox(height: 18),
                          cards(
                            alignmentBegin: Alignment.topRight,
                            alignmentEnd: Alignment.bottomLeft,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            title: "Enquiry",
                            icon: Icons.note_alt_outlined,
                            // imagePath: "asset/image/users-svgrepo-com (1).png",
                            onTap: () => Get.toNamed(Routes.adminEnquiry),
                          ),
                        ],
                      ),
                      const SizedBox(width: 18),
                      // Right Column (lower position)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cards(
                            alignmentBegin: Alignment.bottomLeft,
                            alignmentEnd: Alignment.topRight,
                            title: "Followup",
                            icon: Icons.follow_the_signs,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            // imagePath: "asset/image/add-friend.png",
                            onTap: () => Get.toNamed(Routes.adminFollowup),
                          ),
                          const SizedBox(height: 18),
                          cards(
                            title: "Quotation",
                            icon: Icons.all_inbox,
                            alignmentBegin: Alignment.topLeft,
                            alignmentEnd: Alignment.bottomRight,
                            onTap: () {
                              Get.toNamed(Routes.quotationPage);
                            },
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget cards({
  required String title,
  // required String imagePath,
  required IconData icon,
  required VoidCallback onTap,
  required BorderRadius borderRadius,
  //required Gradient gradient,
  required AlignmentGeometry alignmentBegin,
  required AlignmentGeometry alignmentEnd,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 100,
      width: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: AppColors.themeBlue,
        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xFF229CB8),
        //     Color(0xFF2098B3),
        //     Color(0xFF13859f),
        //     Color(0xFF066a81),
        //   ],
        //   begin: alignmentBegin,
        //   end: alignmentEnd,
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
    // Container(
    //   width: 150,
    //   height: 200,
    //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    //   decoration: const BoxDecoration(
    //     color: AppColors.appColor,
    //     borderRadius: BorderRadius.all(Radius.circular(5)),
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: [
    //       Icon(icon, size: 60, color: Colors.white),
    //       Text(
    //         title,
    //         style: const TextStyle(
    //           fontSize: 20,
    //           color: Colors.white,
    //           fontWeight: FontWeight.bold,
    //         ),
    //         textAlign: TextAlign.center,
    //       ),
    //     ],
    //   ),
    // ),
  );
}
