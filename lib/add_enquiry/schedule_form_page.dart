import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:relie_nquiry/constants/app_button.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:relie_nquiry/constants/app_funtion.dart';
import 'package:relie_nquiry/constants/app_popups.dart';
import 'package:relie_nquiry/constants/app_text_styles.dart';
import 'package:relie_nquiry/constants/funtions/enquiry_funtions.dart';
import 'package:relie_nquiry/constants/text_fields.dart';
import 'package:relie_nquiry/constants/uppercase_formatter.dart';

import '../routes/app_routes.dart';

class ScheduleFormPage extends StatefulWidget {
  const ScheduleFormPage({super.key});

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> enquiryTypes = ['Schedule'];
  String selectedEnquiryType = 'Schedule';

  @override
  void initState() {
    super.initState();

    // Set 'Schedule' as default (or the first element of enquiryTypes)
    selectedEnquiryType = 'Schedule';
  }
  /// New
  final TextEditingController emailController = TextEditingController();
  final TextEditingController collageController = TextEditingController();
  // Schedule specific controllers
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();

  // Common form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nextMeetingDateController =
      TextEditingController();
  final TextEditingController nextMeetingTimeController =
      TextEditingController();

  DateTime? nextMeetingDate;
  DateTime? eventDate;
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            width: AppConstants.screenWidth(context),
            color: Colors.white,
            height: AppConstants.screenHeight(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                ClipPath(
                  // clipper: ArcClipper(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 80,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.themeBlue,
                      //gradient: AppColors.themGradient,
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
                                Navigator.of(context).pop();
                                // Get.off(Routes.followUpScreen);
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
                          "Schedule Form",
                          style: AppTextStyles.appBarWhite21bold,
                        ),
                      ],
                    ),
                  ),
                ),

                // Form Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),

                          // Schedule specific fields
                          scheduleFields(context),

                          const SizedBox(height: 20),

                          // Common fields
                          commonForm(context),

                          const SizedBox(height: 25),

                          // Submit Button
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 80),
                              child: AppButton.AppCustomButton(
                                paddingVertical: 10,
                                paddingHorizontal: 20,
                              //  width: 100,
                                onTap:
                                    isLoading.value
                                        ? null
                                        : () async {
                                          bool isValid =
                                              _formKey.currentState!.validate();
                                          if (!isValid) return;

                                          await Future.delayed(Duration.zero);

                                          if (_formKey.currentState!
                                              .validate()) {
                                            FocusScope.of(context).unfocus();
                                            final confirm =
                                                await AppPopups.conformationPopup(
                                                  context: context,
                                                  title:
                                                      "Are you sure want to Submit?",
                                                  onPressed: () {
                                                    Navigator.of(
                                                      context,
                                                    ).pop(true);
                                                  },
                                                );
                                            if (confirm != true) return;

                                            isLoading.value = true;
                                            final result =
                                                await EnquiryService.addEnquiry(
                                                  email:  emailController.text
                                                      .trim(),
                                                  collage:  collageController.text
                                                      .trim(),
                                                  name:
                                                      nameController.text
                                                          .trim(),
                                                  mobile:
                                                      mobileController.text
                                                          .trim(),
                                                  description:
                                                      descriptionController.text
                                                          .trim(),
                                                  address:
                                                      addressController.text
                                                          .trim(),
                                                  formType: 'Schedule',
                                                  followUpDate:
                                                      nextMeetingDate!,
                                                  followUpTime:
                                                      nextMeetingTimeController
                                                          .text
                                                          .trim(),
                                                  //serviceTitle: '',
                                                  otherTitle: '',
                                                  productName: '',
                                                  productPrice: '',
                                                  productModel: '',
                                                  eventName:
                                                      eventNameController.text
                                                          .trim(),
                                                  eventDate: eventDate, selectedEnquiryType: '',
                                                );

                                            isLoading.value = false;

                                            if (result == null) {
                                              // Success
                                              Get.snackbar(
                                                "Success",
                                                "Schedule enquiry added successfully",
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                                duration: Duration(seconds: 2),
                                              );

                                              // Clear all fields
                                              _clearAllFields();
                                            } else {
                                              Get.snackbar(
                                                "Error",
                                                result,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                            }
                                          }
                                        },
                                text: "Submit",
                                style: AppTextStyles.white18bold,
                                color:
                                    isLoading.value
                                        ? Colors.grey
                                        : AppColors.appColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 45),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget scheduleFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFields.textFormFieldHeading(
          context: context,
          controller: eventNameController,
          headingText: "Event Name *",
          hintText: "Enter Event Name",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter event name";
            }
            return null;
          },
          inputFormatters: [UpperCaseTextFormatter()],
        ),
        const SizedBox(height: 20),

        AppTextFields.textFormFieldHeading(
          context: context,
          controller: eventDateController,
          suffixIcon: Icon(Icons.calendar_month_outlined),
          readOnly: true,
          onChanged: (value) {
            setState(() {});
          },
          headingText: "Event Date *",
          hintText: "Select Event Date",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select event date";
            }
            return null;
          },
          onTap: () async {
            DateTime? pickedDate = await AppFunctions.pickDate(context);
            if (pickedDate != null) {
              setState(() {
                eventDate = pickedDate;
                eventDateController.text = DateFormat.yMMMd().format(
                  eventDate!,
                );
              });
            }
          },
        ),
      ],
    );
  }

  Widget commonForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFields.textFormFieldHeading(
          context: context,
          controller: nameController,
          headingText: "Name *",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter name";
            }
            return null;
          },
          inputFormatters: [UpperCaseTextFormatter()],
          hintText: "Enter name",
        ),
        const SizedBox(height: 20),

        AppTextFields.textFormFieldHeading(
          context: context,
          controller: mobileController,
          headingText: "Mobile number *",
          hintText: "Enter mobile number",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter mobile number";
            } else if (value.length != 10) {
              return "Mobile number must be 10 digits";
            }
            return null;
          },
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),

        AppTextFields.textFormFieldHeading(
          context: context,
          controller: addressController,
          headingText: "Address *",
          hintText: "Enter address",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter address";
            }
            return null;
          },
          maxLines: 3,
        ),
        const SizedBox(height: 20),

        AppTextFields.textFormFieldHeading(
          context: context,
          controller: descriptionController,
          headingText: "Description",
          hintText: "Enter description",
          maxLines: 3,
        ),
        const SizedBox(height: 20),

        AppTextFields.textFormFieldHeading(
          context: context,
          controller: nextMeetingDateController,
          suffixIcon: Icon(Icons.calendar_month_outlined),
          readOnly: true,
          onChanged: (value) {
            setState(() {});
          },
          hintText: "Select Meeting Date",
          headingText: "Next Meeting Date *",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select next meeting date";
            }
            return null;
          },
          onTap: () async {
            DateTime? pickedDate = await AppFunctions.pickDate(context);
            if (pickedDate != null) {
              setState(() {
                nextMeetingDate = pickedDate;
                nextMeetingDateController.text = DateFormat.yMMMd().format(
                  nextMeetingDate!,
                );
              });
            }
          },
        ),
        const SizedBox(height: 15),

        AppTextFields.textFormFieldHeading(
          context: context,
          controller: nextMeetingTimeController,
          suffixIcon: Icon(Icons.access_time_rounded),
          readOnly: true,
          onChanged: (value) {
            setState(() {});
          },
          headingText: "Next Meeting Time *",
          hintText: "Select Meeting Timing",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select next meeting time";
            }
            return null;
          },
          onTap: () async {
            TimeOfDay? pickedTime = await AppFunctions.pickTime(context);
            if (pickedTime != null) {
              setState(() {
                nextMeetingTimeController.text = pickedTime.format(context);
              });
            }
          },
        ),
      ],
    );
  }

  void _clearAllFields() {
    nameController.clear();
    mobileController.clear();
    descriptionController.clear();
    addressController.clear();
    eventNameController.clear();
    nextMeetingTimeController.clear();
    nextMeetingDateController.clear();
    eventDateController.clear();
    nextMeetingDate = null;
    eventDate = null;
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    eventNameController.dispose();
    nextMeetingTimeController.dispose();
    nextMeetingDateController.dispose();
    eventDateController.dispose();
    super.dispose();
  }
}
