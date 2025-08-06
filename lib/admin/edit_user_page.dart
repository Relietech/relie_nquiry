import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:image_cropper/image_cropper.dart' show CropStyle;
import 'package:relie_nquiry/constants/funtions/auth_services.dart';
import 'package:relie_nquiry/constants/text_fields.dart';
import 'package:relie_nquiry/constants/uppercase_formatter.dart';

import '../constants/app_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_funtion.dart';
import '../constants/app_popups.dart';
import '../constants/app_text_styles.dart';
import '../routes/app_routes.dart';

class EditUserPage extends StatefulWidget {
  EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final mobileController = TextEditingController();
  final employeeIdController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final designationController = TextEditingController();

  String _imageFile = "";

  List<String> roleList = ['Admin', 'Employee'];

  String? createdUserName;
  String? createdUserRole;
  File? createdUserImage;

  String? selectedRole;
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    userData = Map<String, dynamic>.from(Get.arguments ?? {});

    nameController.text = userData['name'] ?? '';
    mobileController.text = userData['mobile'] ?? '';
    employeeIdController.text = userData['employee_id'] ?? '';
    addressController.text = userData['address'] ?? '';
    designationController.text = userData['designation'] ?? '';
    selectedRole = userData['role'] ?? null;
    _imageFile = userData['image_path'] ?? '';
    passwordController.text = userData["password"] ?? "";
    // or 'imageFile' depending on your field name
  }

  Future<void> editUserProfile() async {
    AppPopups.circularProgressIndicator(context);

    final docRef = FirebaseFirestore.instance
        .collection("subscription")
        .doc(AppConstants.companyName)
        .collection("users")
        .doc(userData['uid']);

    final doc = await docRef.get();
    final oldData = doc.data();

    String oldImageUrl = oldData?['image_path'] ?? "";
    String newImageUrl = _imageFile;

    if (newImageUrl.isEmpty) {
      newImageUrl = oldImageUrl;
    }

    final newName = nameController.text.trim();
    final newMobile = mobileController.text.trim();
    final newAddress = addressController.text.trim();
    final newDesignation = designationController.text.trim();
    final newPassword = passwordController.text.trim();
    final newRole = selectedRole;

    // Compare with existing values
    final noChanges =
        (oldData?['name'] ?? "") == newName &&
        (oldData?['mobile'] ?? "") == newMobile &&
        (oldData?['address'] ?? "") == newAddress &&
        (oldData?['designation'] ?? "") == newDesignation &&
        (oldData?['password'] ?? "") == newPassword &&
        (oldData?['role'] ?? "") == newRole && // <-- fixed here
        oldImageUrl == newImageUrl;

    // final noChanges =
    //     (oldData?['name'] ?? "") == newName &&
    //     (oldData?['mobile'] ?? "") == newMobile &&
    //     (oldData?['address'] ?? "") == newAddress &&
    //     (oldData?['designation'] ?? "") == newDesignation &&
    //     (oldData?['password'] ?? "") == newPassword &&
    //     (oldData?['Role'] ?? "") == newRole &&
    //     oldImageUrl == newImageUrl;

    if (noChanges) {
      Navigator.pop(context);
      AppPopups.infoPopup(context: context, title: "No changes made");
      return;
    }

    // Build only changed fields
    Map<String, dynamic> updates = {};

    if ((oldData?['name'] ?? "") != newName) updates['name'] = newName;
    if ((oldData?['mobile'] ?? "") != newMobile) updates['mobile'] = newMobile;
    if ((oldData?['address'] ?? "") != newAddress)
      updates['address'] = newAddress;

    if ((oldData?['designation'] ?? "") != newDesignation)
      updates['designation'] = newDesignation;
    if ((oldData?['role'] ?? "") != newRole) updates['role'] = newRole;
    if ((oldData?['password'] ?? "") != newPassword) {
      await AuthService.updateUserPassword(
        company: AppConstants.companyName,
        email: oldData?['email'],
        newPassword: newPassword,
      );
    }

    if (oldImageUrl != newImageUrl) updates['image_path'] = newImageUrl;

    if (updates.isNotEmpty) {
      await docRef
          .update(updates)
          .then((_) {
            Navigator.pop(context);
            AppPopups.infoPopupWithOnPressed(
              context: context,
              onPressed: () {
                Get.toNamed(Routes.adminEmployeeListing);
              },
              title: "Updated Successfully",
            );
          })
          .catchError((error) {
            Navigator.pop(context);
            AppPopups.infoPopup(context: context, title: "Update failed");
          });
    } else {
      Navigator.pop(context);
      AppPopups.infoPopupWithOnPressed(
        context: context,
        onPressed: () {
          Get.toNamed(Routes.adminEmployeeListing);
        },
        title: "Password updated successfully",
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
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
                  //  gradient: AppColors.themGradient,
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
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      // Title centered at the top
                      const Text(
                        "Edit Employee Info.",
                        style: AppTextStyles.appBarWhite21bold,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              /// Form Body
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              /// Image Picker
                              GestureDetector(
                                // onTap: () async {
                                //   String? imageUrl =
                                //       await AppFunctions.pickImageWithoutCrop(
                                //         pathName: 'UserImages',
                                //         context: context,
                                //       );
                                //
                                //   if (imageUrl != null) {
                                //     print("Image uploaded: $imageUrl");
                                //     setState(
                                //       () => _imageFile = imageUrl,
                                //     ); // if you need to show it
                                //   } else {
                                //     print(
                                //       "Image selection canceled or failed.",
                                //     );
                                //   }
                                //   setState(() {});
                                // },
                                onTap: () async {
                                  String? croppedFile =
                                  await AppFunctions.pickImageWithImageCropper(
                                    pathName: "MemberImage",
                                    context: context,
                                    cropStyle: CropStyle.rectangle,
                                  );
                                  setState(() => _imageFile = croppedFile!);
                                  setState(() {});
                                },
                                child: Container(
                                  height: 140,
                                  width: 140,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child:
                                      _imageFile == ""
                                          ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.cloud_upload,
                                                color: Colors.grey.shade500,),
                                              Text(textAlign: TextAlign.center,
                                                "Upload image",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          )
                                          : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.network(
                                              _imageFile,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                ),
                              ),
                              const SizedBox(height: 25),

                              /// Name
                              AppTextFields.textFormFieldHeading(
                                context: context,
                                controller: nameController,
                                headingText: "Name *",
                                inputFormatters: [UpperCaseTextFormatter()],
                                hintText: "Enter name",
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter name"
                                            : null,
                              ),
                              const SizedBox(height: 20),

                              /// Mobile
                              AppTextFields.textFormFieldHeading(
                                context: context,
                                controller: mobileController,
                                headingText: "Phone *",
                                hintText: "Enter phone number",

                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter phone";
                                  }
                                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                    return "Enter valid 10-digit number";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Role *",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              DropdownButtonFormField<String>(
                                value: selectedRole,
                                hint: const Text("Select role"),
                                dropdownColor: Colors.white,
                                // Ensures dropdown menu is white
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  // Makes the field background white
                                  isDense: true,
                                  // Removes extra vertical padding
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.appColor,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.appColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                items:
                                    roleList
                                        .map(
                                          (role) => DropdownMenuItem<String>(
                                            value: role,
                                            child: Text(
                                              role,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedRole = value;
                                  });
                                },
                                validator:
                                    (value) =>
                                        value == null
                                            ? "Please select  role"
                                            : null,
                              ),

                              const SizedBox(height: 25),

                              /// Designation
                              AppTextFields.textFormFieldHeading(
                                context: context,
                                controller: designationController,
                                headingText: "Designation *",
                                hintText: "Enter designation",
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter designation"
                                            : null,
                              ),
                              const SizedBox(height: 20),

                              /// Address
                              AppTextFields.textFormFieldHeading(
                                context: context,
                                controller: addressController,
                                headingText: "Address *",
                                hintText: "Enter address",
                                maxLines: 3,
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter address"
                                            : null,
                              ),
                              const SizedBox(height: 20),
                              //
                              // /// Status Title
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //       vertical: 10,
                              //     ),
                              //     child: Text(
                              //       "Status *",
                              //       style: TextStyle(
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              // Row(
                              //   children: [
                              //     Radio<String>(
                              //       value: "Active",
                              //       groupValue: _status,
                              //       activeColor: AppColors.appColor,
                              //       // 👈 Set your custom color
                              //       onChanged: (value) {
                              //         setState(() {
                              //           _status = value!;
                              //         });
                              //       },
                              //     ),
                              //     const Text(
                              //       "Active",
                              //       style: TextStyle(fontSize: 18),
                              //     ),
                              //
                              //     const SizedBox(width: 30),
                              //
                              //     Radio<String>(
                              //       value: "Inactive",
                              //       groupValue: _status,
                              //       activeColor: AppColors.appColor,
                              //       // 👈 Set your custom color
                              //       onChanged: (value) {
                              //         setState(() {
                              //           _status = value!;
                              //         });
                              //       },
                              //     ),
                              //     const Text(
                              //       "Inactive",
                              //       style: TextStyle(fontSize: 18),
                              //     ),
                              //   ],
                              // ),

                              /// Radio Buttons
                              const SizedBox(height: 20),

                              /// Employee ID
                              AppTextFields.textFormFieldHeading(
                                context: context,
                                readOnly: true,
                                controller: employeeIdController,
                                headingText: "Employee ID *",
                                hintText: "Enter employee ID",
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter employee ID"
                                            : null,
                              ),
                              const SizedBox(height: 20),

                              /// Password
                              AppTextFields.textFormFieldHeading(
                                context: context,
                                controller: passwordController,
                                headingText: "Password *",
                                hintText: "Enter Xyz@123",
                                // obscureText: true,
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter password (Xyz@123)"
                                            : null,
                              ),

                              // const SizedBox(height: 20),
                              //
                              // /// Confirm Password
                              // AppTextFields.textFormFieldHeading(
                              //   context: context,
                              //   controller: confirmPasswordController,
                              //   headingText: "Confirm Password *",
                              //   hintText: "Re-enter password",
                              //   // obscureText: true,
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty)
                              //       return "Please confirm password";
                              //     if (value != passwordController.text)
                              //       return "Passwords do not match";
                              //     return null;
                              //   },
                              // ),
                              const SizedBox(height: 25),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 80),
                                  child: AppButton.AppCustomButton(
                                   // width: 100,
                                    paddingVertical: 8,
                                    paddingHorizontal: 20,
                                    onTap: () {
                                      editUserProfile();
                                    },
                                    text: "Update",
                                    style: AppTextStyles.white18bold,
                                    color: AppColors.appColor,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
