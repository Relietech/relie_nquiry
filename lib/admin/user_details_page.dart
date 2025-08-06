import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:relie_nquiry/constants/app_text_styles.dart';
import 'package:relie_nquiry/constants/text_fields.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../routes/app_routes.dart' show Routes;

class AdminEmployeeDetailsPage extends StatefulWidget {
  final Map<String, dynamic> user = Map<String, dynamic>.from(
    Get.arguments ?? {},
  );

  AdminEmployeeDetailsPage({super.key});

  @override
  State<AdminEmployeeDetailsPage> createState() =>
      _AdminEmployeeDetailsPageState();
}

class _AdminEmployeeDetailsPageState extends State<AdminEmployeeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
               // height: 300,
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Back button aligned to the start (left)
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.offNamed('/adminEmployeeListing');
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                          // Centered text
                          const Center(
                            child: Text(
                              "Employee Info.",
                              style: AppTextStyles.appBarWhite21bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Column(
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
                                widget.user["image_path"] != null
                                    ? (widget.user["image_path"] is File
                                        ? Image.file(
                                          widget.user["image_path"] as File,
                                          fit: BoxFit.cover,
                                        )
                                        : Image.network(
                                          widget.user["image_path"].toString(),
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return _defaultPlaceholder();
                                          },
                                        ))
                                    : _defaultPlaceholder(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Name and Role
                        Text(
                          widget.user["name"]?.toString() ?? "No Name",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:  Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.user["role"]?.toString() ?? "No Role",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // User Details Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image and Basic Info Card
                      //const SizedBox(height: 20),

                      // Details Cards
                      _buildDetailCard(
                        icon: Icons.work,
                        title: "Designation",
                        value:
                            widget.user["designation"]?.toString() ??
                            "Not specified",
                      ),

                      _buildDetailCard(
                        icon: Icons.phone,
                        title: "Phone Number",
                        value:
                            widget.user["mobile"]?.toString() ?? "Not provided",
                      ),

                      _buildDetailCard(
                        icon: Icons.badge,
                        title: "Employee ID",
                        value:
                            widget.user["employee_id"]?.toString() ??
                            "Not assigned",
                      ),

                      _buildDetailCard(
                        icon: Icons.location_on,
                        title: "Address",
                        value:
                            widget.user["address"]?.toString() ??
                            "No address provided",
                        isMultiLine: true,
                      ),

                      _buildDetailCard(
                        icon:
                            (widget.user["status"]?.toString() ?? "Inactive") ==
                                    "Active"
                                ? Icons.check_circle
                                : Icons.cancel,
                        title: "Status",
                        value: widget.user["status"]?.toString() ?? "Inactive",
                        statusColor:
                            (widget.user["status"]?.toString() ?? "Inactive") ==
                                    "Active"
                                ? Colors.green
                                : Colors.red,
                      ),

                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.toNamed(
                                  Routes.userEdit,
                                  arguments: widget.user,
                                );
                                // Edit functionality
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text(
                                "Edit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(

                                backgroundColor: AppColors.appColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (widget.user["status"] == "Active") {
                                  _showStatusDialog(
                                    context,
                                    false,
                                  ); // deactivate
                                } else {
                                  _showStatusDialog(context, true); // activate
                                }
                              },
                              icon: Icon(
                                widget.user["status"] == "Active"
                                    ? Icons.delete
                                    : Icons.check,
                                color: Colors.white,
                              ),
                              label: Text(
                                widget.user["status"] == "Active"
                                    ? "Inactive"
                                    : "Active",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    widget.user["status"] == "Active"
                                        ? Colors.red
                                        : Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),

                          // Expanded(
                          //   child: ElevatedButton.icon(
                          //     onPressed: () {
                          //       if (widget.user["status"] == "active") {
                          //         _showDeleteDialog(context); // Show popup to deactivate
                          //       } else {
                          //         _activateUser(); // Call your activate function
                          //       }
                          //     },
                          //     icon: Icon(
                          //       widget.user["status"] == "active" ? Icons.delete : Icons.check,
                          //       color: Colors.white,
                          //     ),
                          //     label: Text(
                          //       widget.user["status"] == "active" ? "Inactive" : "Active",
                          //       style: const TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: widget.user["status"] == "active" ? Colors.red : Colors.green,
                          //       padding: const EdgeInsets.symmetric(vertical: 12),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8),
                          //       ),
                          //       foregroundColor: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
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
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
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

  void _showStatusDialog(BuildContext context, bool activate) {
    final userName = widget.user["name"]?.toString() ?? "this user";
    final userId = widget.user["id"]?.toString();

    final newStatus = activate ? "Active" : "Inactive";
    final title = activate ? "Activate User" : "Inactive User";
    final message =
        activate
            ? "Are you sure you want to activate $userName?"
            : "Are you sure you want to inactivate $userName?";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "No",
                style: TextStyle(color: AppColors.appColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                if (userId != null && userId.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection("subscription")
                        .doc(AppConstants.companyName)
                        .collection("users")
                        .doc(userId)
                        .update({"status": newStatus});

                    // Optional navigation or UI refresh
                    Get.offNamed(Routes.adminEmployeeListing);
                  } catch (e) {
                    debugPrint("Error updating user status: $e");
                  }
                }
              },
              child: Text(
                "Yes",
                style: TextStyle(color: activate ? Colors.green : Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _showDeleteDialog(BuildContext context) {
  //   final userName = widget.user["name"]?.toString() ?? "this user";
  //   final userId =
  //       widget.user["id"]
  //           ?.toString(); // Make sure this is the correct user document ID
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         surfaceTintColor: Colors.white,
  //         backgroundColor: Colors.white,
  //         title: const Text("Inactive User"),
  //         content: Text("Are you sure you want to inactive $userName?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text(
  //               "No",
  //               style: TextStyle(color: AppColors.appColor),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop(); // Close the confirmation dialog
  //
  //               if (userId != null && userId.isNotEmpty) {
  //                 try {
  //                   await FirebaseFirestore.instance
  //                       .collection("subscription")
  //                       .doc(AppConstants.companyName)
  //                       .collection("users")
  //                       .doc(userId)
  //                       .update({"status": "inactive"});
  //
  //                   Get.offNamed(
  //                     Routes.createuser,
  //                   ); // Navigate without showing snackbar
  //                 } catch (e) {
  //                   // Optional: You can log the error or handle it silently
  //                   debugPrint("Error while marking user inactive: $e");
  //                 }
  //               }
  //             },
  //             child: const Text("Yes", style: TextStyle(color: Colors.red)),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
