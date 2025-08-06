import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:relie_nquiry/constants/app_button.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:relie_nquiry/constants/app_popups.dart';
import 'package:relie_nquiry/constants/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart' show AppColors;
import '../routes/app_routes.dart' show Routes;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder<DocumentSnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection("subscription")
                    .doc(AppConstants.companyName)
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                final userDoc = snapshot.data!;
                final imagePath = userDoc["image_path"];
                final name = userDoc["name"];
                final employeeId = userDoc["employee_id"];
                final designation = userDoc["designation"];
                final mobile = userDoc["mobile"];
                final address = userDoc["address"];

                return Column(
                  children: [
                    Container(
                      //height: 300,
                      decoration: const BoxDecoration(
                        color: AppColors.themeBlue,
                        // gradient: LinearGradient(
                        //   colors: [
                        //     Color(0xFF229CB8),
                        //     Color(0xFF2098B3),
                        //     Color(0xFF13859f),
                        //     Color(0xFF066a81),
                        //   ],
                        //   begin: Alignment.centerRight,
                        //   end: Alignment.centerLeft,
                        // ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed('/homeScreen');
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                  Text(
                                    "Personal Info.",
                                    style: AppTextStyles.appBarWhite21bold,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      AppPopups.conformationPopup(
                                        context: context,
                                        title:
                                            "Are you sure you want to logout?",
                                        onPressed: () async {
                                          Get.back();
                                          await FirebaseAuth.instance.signOut();
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          await prefs.remove('user_role');
                                          Get.offAllNamed(Routes.logInPage);
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.power_settings_new_sharp,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 3,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child:
                                          imagePath != null && imagePath != ""
                                              ? Image.network(
                                                imagePath,
                                                fit: BoxFit.cover,
                                              )
                                              : Container(
                                                color: Colors.grey[200],
                                                child: Icon(
                                                  Icons.person,
                                                  size: 60,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      employeeId,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            _buildDetailCard(
                              icon: Icons.work,
                              title: "Designation",
                              value: designation,
                            ),
                            _buildDetailCard(
                              icon: Icons.phone,
                              title: "Phone Number",
                              value: mobile,
                            ),
                            _buildDetailCard(
                              icon: Icons.location_on,
                              title: "Address",
                              value: address,
                              isMultiLine: true,
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 80),
                                child: AppButton.AppCustomButton(
                                 // width: 100,
                                  paddingVertical: 8,
                                  paddingHorizontal: 20,
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.profileEdit,
                                      arguments: userDoc,
                                    );
                                  },
                                  text: "Edit",
                                  style: AppTextStyles.white20bold,
                                  color: AppColors.appColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: Text("Data not found"));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    bool isMultiLine = false,
    Color? statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.appColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: statusColor ?? AppColors.appColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: statusColor ?? Colors.black87,
                  ),
                  maxLines: isMultiLine ? null : 1,
                  overflow: isMultiLine ? null : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
