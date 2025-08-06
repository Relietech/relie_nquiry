import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:relie_nquiry/constants/app_button.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/constants/app_funtion.dart';
import 'package:relie_nquiry/constants/app_popups.dart';
import 'package:relie_nquiry/constants/app_text_styles.dart';
import 'package:relie_nquiry/constants/text_fields.dart';
import 'package:relie_nquiry/constants/uppercase_formatter.dart';

import '../constants/funtions/auth_services.dart';

class EmployeeCreatePage extends StatefulWidget {
  const EmployeeCreatePage({super.key});

  @override
  State<EmployeeCreatePage> createState() => _EmployeeCreatePageState();
}

class _EmployeeCreatePageState extends State<EmployeeCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final employeeIdController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final designationController = TextEditingController();

  String _imageFile = "";
  String? selectedRole;
  String? createdUserName;
  String? createdUserRole;
  File? createdUserImage;
  List<String> roleList = ['Admin', 'Employee'];




  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text.trim();

      final password = passwordController.text.trim();
      final designation = designationController.text.trim();
      final mobile = mobileController.text.trim();
      final employeeId = employeeIdController.text.trim();
      final address = addressController.text.trim();
      final role = selectedRole;

      if (_imageFile == "") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload a profile image")),
        );
        return;
      }
      final authService = AuthService();
      final result = await authService.employee(
        name: name,
        role: role!,
        imageFile: _imageFile,
        password: password,
        designation: designation,
        mobile: mobile,
        employeeId: employeeId,
        address: address,
      );
      print("Done : ${result}");
      if (result == null) {
        AppPopups.infoPopup(
          context: context,
          title: "Employee Added Successfully.",
        );

        setState(() {
          createdUserName = nameController.text.trim();
          createdUserRole = selectedRole;
          createdUserImage = null;

          nameController.clear();
          mobileController.clear();
          passwordController.clear();
          designationController.clear();
          employeeIdController.clear();
          addressController.clear();
          selectedRole = null;
          _imageFile = "";
        });

        _formKey.currentState!.reset();
      } else {
        print("faild : ${result}");
        AppPopups.infoPopup(context: context, title: "Failed to add employee");
      }
    }
  }

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
                  //  gradient: AppColors.themGradient,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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
                    Center(
                      child: const Text(
                        "Add Employee",
                        style: AppTextStyles.appBarWhite21bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Form(
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
                        //     print("Image selection canceled or failed.");
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
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: _imageFile == ""
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      color: Colors.grey.shade500,
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "Upload image",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
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
                        validator: (value) => value == null || value.isEmpty
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

                      // const SizedBox(height: 20),
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
                              color: Colors.grey,
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
                            borderSide: BorderSide(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        items: roleList
                            .map(
                              (role) => DropdownMenuItem<String>(
                                value: role,
                                child: Text(
                                  role,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? "Please select  role" : null,
                      ),

                      const SizedBox(height: 25),

                      /// Designation
                      AppTextFields.textFormFieldHeading(
                        context: context,
                        controller: designationController,
                        headingText: "Designation *",
                        hintText: "Enter designation",
                        validator: (value) => value == null || value.isEmpty
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
                        validator: (value) => value == null || value.isEmpty
                            ? "Please enter address"
                            : null,
                      ),
                      //const SizedBox(height: 20),
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
                        controller: employeeIdController,
                        headingText: "Employee ID *",
                        hintText: "Enter employee ID",
                        validator: (value) => value == null || value.isEmpty
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
                        validator: (value) => value == null || value.isEmpty
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
                            //width: 100,
                            paddingVertical: 8,
                            paddingHorizontal: 20,
                            onTap: () {
                              AppPopups.conformationPopup(
                                context: context,
                                title:
                                    "Are you sure want to add this employee?",
                                onPressed: () {
                                  Get.back(); // Close the popup
                                  submitForm(); // Proceed with form submission
                                },
                              );
                            },

                            text: "Create",
                            style: AppTextStyles.white18bold,
                            color: AppColors.appColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
