// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:relie_nquiry/bill/Quotation.dart';
// import 'package:relie_nquiry/constants/app_button.dart';
// import 'package:relie_nquiry/constants/app_colors.dart';
// import 'package:relie_nquiry/constants/app_constants.dart';
// import 'package:relie_nquiry/constants/app_drop_downs.dart';
// import 'package:relie_nquiry/constants/app_funtion.dart';
// import 'package:relie_nquiry/constants/app_popups.dart';
// import 'package:relie_nquiry/constants/app_text_styles.dart';
// import 'package:relie_nquiry/constants/funtions/enquiry_funtions.dart';
// import 'package:relie_nquiry/constants/text_fields.dart';
// import 'package:relie_nquiry/constants/uppercase_formatter.dart';
//
// class NewFormPage extends StatefulWidget {
//   const NewFormPage({super.key});
//
//   @override
//   State<NewFormPage> createState() => _NewFormPageState();
// }
//
// class _NewFormPageState extends State<NewFormPage> {
//   final List<String> enquiryTypes = [
//     'Service',
//     'Product',
//     'Booking',
//     "Schedule",
//     "Bill",
//   ];
//
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String? selectedEnquiry;
//
//   TextEditingController nextMeetingDateController = TextEditingController(
//     text: "",
//   );
//   TextEditingController nextMeetingTimeController = TextEditingController(
//     text: "",
//   );
//
//   final TextEditingController serviceTitleController = TextEditingController();
//
//   // final TextEditingController othersController = TextEditingController();
//   final TextEditingController eventDateController = TextEditingController();
//   final TextEditingController eventNameController = TextEditingController();
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController productModelController = TextEditingController();
//   final TextEditingController productPriceController = TextEditingController();
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//
//   /// New
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController collageController = TextEditingController();
//
//   ///Internship
//   final TextEditingController internPursuingCourse = TextEditingController();
//   final TextEditingController internPursuingYear = TextEditingController();
//   final TextEditingController internCourseName = TextEditingController();
//   final TextEditingController internDuration = TextEditingController();
//
//   /// Training
//   final TextEditingController trainingQualification = TextEditingController();
//   final TextEditingController trainingCompletedYear = TextEditingController();
//   final TextEditingController trainingCourseName = TextEditingController();
//
//   /// Job / Career
//   final TextEditingController jobQualification = TextEditingController();
//   final TextEditingController jobName = TextEditingController();
//   final TextEditingController jobFresherDomain = TextEditingController();
//   final TextEditingController jobFresherSkill = TextEditingController();
//   final TextEditingController jobYearExperience = TextEditingController();
//   final TextEditingController jobWorkExperience = TextEditingController();
//   final TextEditingController othersController = TextEditingController();
//
//   bool internship = false;
//   bool training = false;
//   bool job = false;
//   bool fresher = false;
//   bool experience = false;
//   final List<String> serviceTypes = ['Internship', 'Training', 'Job'];
//
//   final List<String> serviceJobTypes = ['Fresher', 'Experienced'];
//
//   DateTime? nextMeetingDate;
//   DateTime? eventDate;
//
//   final RxBool isLoading = false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Container(
//         width: AppConstants.screenWidth(context),
//         color: Colors.white,
//         height: AppConstants.screenHeight(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipPath(
//               //clipper: ArcClipper(),
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 height: 80,
//                 alignment: Alignment.center,
//                 decoration: const BoxDecoration(
//                   color: AppColors.themeBlue,
//                   //gradient: AppColors.themGradient,
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(30),
//                     bottomLeft: Radius.circular(30),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Enquiry Form",
//                       style: AppTextStyles.appBarWhite21bold,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.only(
//                 bottom: 25,
//                 left: 16,
//                 right: 16,
//                 top: 20,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Select Enquiry", style: AppTextStyles.black16bold),
//                   SizedBox(height: 10),
//                   AppDropDownButton(
//                     validator: (value) {
//                       if (value == null) {
//                         return "Select task enquiry";
//                       }
//                       return null;
//                     },
//                     onChanged: (String? value) {
//                       setState(() {
//                         selectedEnquiry = value!;
//                       });
//                       setState(() {});
//                     },
//                     hintText: "Select Enquiry",
//                     itemList: enquiryTypes,
//                     selectedValue: selectedEnquiry,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (selectedEnquiry == 'Bill')
//                         InkWell(onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuotationPage(),));
//                         },child: Icon(Icons.add)),
//                       if (selectedEnquiry == 'Schedule')
//                         AppTextFields.textFormFieldHeading(
//                           context: context,
//                           controller: othersController,
//                           headingText: "Title *",
//                           hintText: "Enter title",
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter title";
//                             }
//                             return null;
//                           },
//                           inputFormatters: [UpperCaseTextFormatter()],
//                         ),
//
//                       // if (selectedEnquiry == 'Others')
//                       //   AppTextFields.textFormFieldHeading(
//                       //     context: context,
//                       //     controller: othersController,
//                       //     headingText: "Title ",
//                       //     hintText: "Enter title",
//                       //     inputFormatters: [UpperCaseTextFormatter()],
//                       //   ),
//                       if (selectedEnquiry == 'Service') ...[
//                         SizedBox(height: 10),
//                         _buildEnquiryTypeSelector(),
//                         if (_selectedEnquiryType == 'Internship') ...[
//                           AppTextFields.textFormFieldHeading(
//                             context: context,
//                             controller: internPursuingCourse,
//                             headingText: "Pursuing Course",
//                             hintText: "Enter your Pursuing Course",
//                           ),
//                           SizedBox(height: 10),
//                           AppTextFields.textFormFieldHeading(
//                             context: context,
//                             controller: internPursuingYear,
//                             headingText: "Pursuing Year",
//                             hintText: "Enter year (e.g. 2nd year)",
//                           ),
//                           SizedBox(height: 10),
//                           AppTextFields.textFormFieldHeading(
//                             context: context,
//                             controller: internCourseName,
//                             headingText: "Internship/Course Name",
//                             hintText: "Enter your (e.g. Web development)",
//                           ),
//                           SizedBox(height: 10),
//                           AppTextFields.textFormFieldHeading(
//                             context: context,
//                             controller: internDuration,
//                             headingText: "Internship Duration",
//                             hintText: "e.g. 1 month, 2 months",
//                           ),
//                         ],
//                         if (_selectedEnquiryType == 'Training') ...[
//                           AppTextFields.textFormFieldHeading(
//                             context: context,
//                             controller: trainingQualification,
//                             headingText: "Qualification",
//                             hintText: "e.g. B.E, B.Sc",
//                           ),
//                           SizedBox(height: 10),
//                           AppTextFields.textFormFieldHeading(
//                             context: context,
//                             controller: trainingCompletedYear,
//                             headingText: "Completed Year",
//                             hintText: "e.g. 2024",
//                           ),
//                           SizedBox(height: 10),
//                           AppTextFields.textFormFieldHeading(
//                             context: context,
//                             controller: trainingCourseName,
//                             headingText: "Course Name",
//                             hintText: "e.g. Flutter, MERN full stack",
//                           ),
//                         ],
//                         if (_selectedEnquiryType == 'Job/Career') ...[
//                           AppTextFields.textFormFieldHeading(
//                             context: context,
//                             controller: jobQualification,
//                             headingText: "Qualification",
//                             hintText: "e.g. M.Tech, BCA",
//                           ),
//                           SizedBox(height: 10),
//                           AppTextFields.textFormFieldHeading(
//                             context: context,
//                             controller: jobName,
//                             headingText: "Job Title",
//                             hintText: "e.g. Development, Testing",
//                           ),
//                           _buildExperienceSelector(),
//                         ],
//                       ],
//
//                       // AppTextFields.textFormFieldHeading(
//                       //   context: context,
//                       //   controller: serviceTitleController,
//                       //   headingText: "Service Title ",
//                       //
//                       //   hintText: "Enter Service title",
//                       //   inputFormatters: [UpperCaseTextFormatter()],
//                       // ),
//                       if (selectedEnquiry == 'Product')
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             AppTextFields.textFormFieldHeading(
//                               context: context,
//                               controller: productNameController,
//                               headingText: "Product Name",
//
//                               hintText: "Enter Product Name",
//                               inputFormatters: [UpperCaseTextFormatter()],
//                             ),
//                             SizedBox(height: 20),
//                             AppTextFields.textFormFieldHeading(
//                               context: context,
//                               controller: productModelController,
//                               headingText: "Product Model",
//
//                               hintText: "Enter Product Model",
//                               inputFormatters: [UpperCaseTextFormatter()],
//                             ),
//                             SizedBox(height: 20),
//                             AppTextFields.textFormFieldHeading(
//                               context: context,
//                               controller: productPriceController,
//                               headingText: "Product Price",
//
//                               hintText: "Enter Product Price",
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.digitsOnly,
//                               ],
//                             ),
//                           ],
//                         ),
//                       if (selectedEnquiry == 'Booking')
//                         Column(
//                           children: [
//                             AppTextFields.textFormFieldHeading(
//                               context: context,
//                               controller: eventNameController,
//                               headingText: "Event Name",
//
//                               hintText: "Enter Event Name",
//                               inputFormatters: [UpperCaseTextFormatter()],
//                             ),
//                             SizedBox(height: 20),
//                             AppTextFields.textFormFieldHeading(
//                               context: context,
//                               controller: eventDateController,
//                               suffixIcon: Icon(Icons.calendar_month_outlined),
//                               readOnly: true,
//                               onChanged: (value) {
//                                 setState(() {});
//                               },
//                               headingText: "Event Date",
//
//                               onTap: () async {
//                                 DateTime? pickedDate =
//                                     await AppFunctions.pickDate(context);
//                                 if (pickedDate != null) {
//                                   setState(() {
//                                     eventDate = pickedDate;
//                                     eventDateController.text =
//                                         DateFormat.yMMMd().format(eventDate!);
//                                   });
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//
//                       SizedBox(height: 20),
//
//                       commonForm(context),
//                       SizedBox(height: 25),
//
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 80),
//                           child: AppButton.AppCustomButton(
//                             paddingVertical: 10,
//                             paddingHorizontal: 20,
//                             // width: 100,
//                             onTap: () async {
//                               bool isValid = _formKey.currentState!.validate();
//                               if (!isValid) return;
//
//                               await Future.delayed(Duration.zero);
//
//                               if (_formKey.currentState!.validate()) {
//                                 FocusScope.of(context).unfocus();
//                                 final confirm =
//                                     await AppPopups.conformationPopup(
//                                       context: context,
//                                       title: "Are you sure want to Submit?",
//                                       onPressed: () {
//                                         Navigator.of(context).pop(true);
//                                       },
//                                     );
//                                 if (confirm != true) return;
//
//                                 isLoading.value = true;
//                                 final result = await EnquiryService.addEnquiry(
//                                   name: nameController.text.trim(),
//                                   mobile: mobileController.text.trim(),
//                                   collage: collageController.text.trim(),
//                                   email: emailController.text.trim(),
//                                   description: descriptionController.text
//                                       .trim(),
//                                   address: addressController.text.trim(),
//                                   formType: selectedEnquiry!,
//                                   followUpDate: nextMeetingDate!,
//                                   followUpTime: nextMeetingTimeController.text
//                                       .trim(),
//
//                                   selectedEnquiryType: _selectedEnquiryType,
//
//                                   /// internship
//                                   internshipPursuingCourse: internPursuingCourse
//                                       .text
//                                       .trim(),
//                                   internshipCourseName: internCourseName.text
//                                       .trim(),
//                                   internshipPursuingYear: internPursuingYear
//                                       .text
//                                       .trim(),
//                                   internshipDuration: internDuration.text
//                                       .trim(),
//
//                                   /// training
//                                   trainingQualification: trainingQualification
//                                       .text
//                                       .trim(),
//                                   trainingCompletedYear: trainingCompletedYear
//                                       .text
//                                       .trim(),
//                                   trainingCourseName: trainingCourseName.text
//                                       .trim(),
//
//                                   /// job
//                                   jobQualification: jobQualification.text
//                                       .trim(),
//                                   jobName: jobName.text.trim(),
//                                   jobFresherDomain: jobFresherDomain.text
//                                       .trim(),
//                                   jobFresherSkill: jobFresherSkill.text.trim(),
//
//                                   jobExperiencedYear: jobYearExperience.text
//                                       .trim(),
//                                   jobExperiencedMessage: jobWorkExperience.text
//                                       .trim(),
//
//                                   //serviceTitle: serviceTitleController.text.trim(),
//                                   otherTitle: othersController.text.trim(),
//                                   productName: productNameController.text
//                                       .trim(),
//                                   productPrice: productPriceController.text
//                                       .trim(),
//                                   productModel: productModelController.text
//                                       .trim(),
//                                   eventName: eventNameController.text.trim(),
//                                   eventDate: eventDate,
//                                 );
//
//                                 isLoading.value = false;
//
//                                 if (result == null) {
//                                   // ✅ Success
//                                   Get.snackbar(
//                                     "Success",
//                                     "Enquiry added successfully",
//                                     backgroundColor: Colors.green,
//                                     colorText: Colors.white,
//                                     duration: Duration(seconds: 2),
//                                   );
//
//                                   // 🎯 Clear all fields
//                                   nameController.clear();
//                                   mobileController.clear();
//                                   descriptionController.clear();
//                                   addressController.clear();
//                                   emailController.clear();
//                                   collageController.clear();
//                                   othersController.clear();
//                                   productNameController.clear();
//                                   productPriceController.clear();
//
//                                   _selectedEnquiryType = "";
//                                   internPursuingCourse.clear();
//                                   internPursuingYear.clear();
//                                   internCourseName.clear();
//                                   internDuration.clear();
//                                   trainingQualification.clear();
//                                   trainingCompletedYear.clear();
//                                   trainingCourseName.clear();
//                                   jobQualification.clear();
//                                   jobName.clear();
//                                   jobFresherDomain.clear();
//                                   jobFresherSkill.clear();
//                                   jobYearExperience.clear();
//                                   jobWorkExperience.clear();
//
//                                   productModelController.clear();
//                                   eventNameController.clear();
//                                   nextMeetingTimeController.clear();
//                                   nextMeetingDateController.clear();
//                                   eventDateController.clear();
//                                   serviceTitleController.clear();
//                                   selectedEnquiry = null;
//                                   nextMeetingDate = null;
//                                   eventDate = null;
//                                   setState(() {
//                                     _formKey = GlobalKey<FormState>();
//                                   });
//                                   // _formKey = GlobalKey<FormState>();
//                                 } else {
//                                   Get.snackbar(
//                                     "Error",
//                                     result,
//                                     backgroundColor: Colors.red,
//                                     colorText: Colors.white,
//                                   );
//                                 }
//                               }
//                             },
//                             text: "Submit",
//                             style: AppTextStyles.white18bold,
//                             color: AppColors.appColor,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 45),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _selectedEnquiryType = '';
//
//   Widget _buildEnquiryTypeSelector() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text("Enquiry Type", style: TextStyle(fontWeight: FontWeight.bold)),
//             InkWell(
//               onTap: () {
//                 setState(() {
//                   _selectedEnquiryType = "";
//                   _jobType = "";
//                 });
//               },
//               child: Icon(Icons.close, color: Colors.red, size: 20),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Radio<String>(
//               value: 'Internship',
//               groupValue: _selectedEnquiryType,
//               onChanged: (value) {
//                 setState(() => _selectedEnquiryType = value!);
//               },
//             ),
//             Text('Internship'),
//             Radio<String>(
//               value: 'Training',
//               groupValue: _selectedEnquiryType,
//               onChanged: (value) {
//                 setState(() => _selectedEnquiryType = value!);
//               },
//             ),
//             Text('Training'),
//             Radio<String>(
//               value: 'Job/Career',
//               groupValue: _selectedEnquiryType,
//               onChanged: (value) {
//                 setState(() => _selectedEnquiryType = value!);
//               },
//             ),
//             Text('Job/Career'),
//           ],
//         ),
//       ],
//     );
//   }
//
//   String _jobType = ''; // default empty
//
//   Widget _buildExperienceSelector() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Radio<String>(
//               value: 'Fresher',
//               groupValue: _jobType,
//               onChanged: (value) => setState(() => _jobType = value!),
//             ),
//             Text("Fresher"),
//             Radio<String>(
//               value: 'Experienced',
//               groupValue: _jobType,
//               onChanged: (value) => setState(() => _jobType = value!),
//             ),
//             Text("Experienced"),
//           ],
//         ),
//         // Only show extra fields if a choice is made
//         if (_jobType == 'Fresher') ...[
//           AppTextFields.textFormFieldHeading(
//             context: context,
//             controller: jobFresherDomain,
//             headingText: "Domain of Interest",
//             hintText: "e.g. Flutter, Web Dev",
//           ),
//           SizedBox(height: 10),
//           AppTextFields.textFormFieldHeading(
//             context: context,
//             controller: jobFresherSkill,
//             headingText: "Skills",
//             hintText: "e.g. Dart, Firebase",
//           ),
//         ] else if (_jobType == 'Experienced') ...[
//           AppTextFields.textFormFieldHeading(
//             context: context,
//             controller: jobYearExperience,
//             headingText: "Years of Experience",
//             hintText: "e.g. 2",
//           ),
//           SizedBox(height: 10),
//           AppTextFields.textFormFieldHeading(
//             context: context,
//             controller: jobWorkExperience,
//             headingText: "Describe Work Experience",
//             hintText: "Your job responsibilities, tools used, etc.",
//             maxLines: 4,
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget commonForm(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (selectedEnquiry != 'Schedule')
//           AppTextFields.textFormFieldHeading(
//             context: context,
//             controller: nameController,
//             headingText: "Name *",
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please enter name";
//               }
//               return null;
//             },
//             inputFormatters: [UpperCaseTextFormatter()],
//             hintText: "Enter name",
//           ),
//         if (selectedEnquiry != 'Schedule') SizedBox(height: 20),
//         if (selectedEnquiry != 'Schedule')
//           AppTextFields.textFormFieldHeading(
//             context: context,
//             controller: mobileController,
//             headingText: "Mobile number *",
//             hintText: "Enter mobile number",
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please enter mobile number";
//               } else if (value.length != 10) {
//                 return "Mobile number must be 10 digits";
//               }
//               return null;
//             },
//             keyboardType: TextInputType.phone,
//             maxLength: 10,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           ),
//
//         //const SizedBox(height: 20),
//         if (selectedEnquiry != 'Schedule')
//           AppTextFields.textFormFieldHeading(
//             context: context,
//             controller: emailController,
//             headingText: "Email-id *",
//             hintText: "Enter email-id",
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please enter email-id";
//               }
//               return null;
//             },
//           ),
//         if (selectedEnquiry != 'Schedule') SizedBox(height: 20),
//         if (selectedEnquiry != 'Schedule')
//           AppTextFields.textFormFieldHeading(
//             context: context,
//             controller: collageController,
//             headingText: "Collage Name *",
//             hintText: "Enter collage name",
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please enter collage name";
//               }
//               return null;
//             },
//           ),
//         if (selectedEnquiry != 'Schedule') SizedBox(height: 20),
//         if (selectedEnquiry != 'Schedule')
//           AppTextFields.textFormFieldHeading(
//             context: context,
//             controller: addressController,
//             headingText: "Address *",
//             hintText: "Enter address",
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please enter address";
//               }
//               return null;
//             },
//             maxLines: 3,
//           ),
//         if (selectedEnquiry != 'Schedule') SizedBox(height: 20),
//
//         AppTextFields.textFormFieldHeading(
//           context: context,
//           controller: descriptionController,
//           headingText: "Description",
//           hintText: "Enter description",
//           maxLines: 3,
//           // No validator here
//         ),
//         const SizedBox(height: 20),
//
//         AppTextFields.textFormFieldHeading(
//           context: context,
//           controller: nextMeetingDateController,
//           suffixIcon: Icon(Icons.calendar_month_outlined),
//           readOnly: true,
//           onChanged: (value) {
//             setState(() {});
//           },
//           hintText: "Select Meeting Date",
//           headingText: "Next Meeting Date *",
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Please select next meeting date";
//             }
//             return null;
//           },
//           onTap: () async {
//             DateTime? pickedDate = await AppFunctions.pickDate(context);
//             if (pickedDate != null) {
//               setState(() {
//                 nextMeetingDate = pickedDate;
//                 nextMeetingDateController.text = DateFormat.yMMMd().format(
//                   nextMeetingDate!,
//                 );
//               });
//             }
//           },
//         ),
//         const SizedBox(height: 15),
//
//         AppTextFields.textFormFieldHeading(
//           context: context,
//           controller: nextMeetingTimeController,
//           suffixIcon: Icon(Icons.access_time_rounded),
//           readOnly: true,
//           onChanged: (value) {
//             setState(() {});
//           },
//           headingText: "Next Meeting Time *",
//           hintText: "Select Meeting Timing",
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Please select next meeting time";
//             }
//             return null;
//           },
//           onTap: () async {
//             TimeOfDay? pickedTime = await AppFunctions.pickTime(context);
//             if (pickedTime != null) {
//               setState(() {
//                 nextMeetingTimeController.text = pickedTime.format(context);
//               });
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:relie_nquiry/bill/Quotation.dart';
import 'package:relie_nquiry/constants/app_button.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:relie_nquiry/constants/app_drop_downs.dart';
import 'package:relie_nquiry/constants/app_funtion.dart';
import 'package:relie_nquiry/constants/app_popups.dart';
import 'package:relie_nquiry/constants/app_text_styles.dart';
import 'package:relie_nquiry/constants/funtions/enquiry_funtions.dart';
import 'package:relie_nquiry/constants/text_fields.dart';
import 'package:relie_nquiry/constants/uppercase_formatter.dart';

class Product {
  String name;
  double price;
  int quantity;

  Product({required this.name, required this.price, this.quantity = 1});

  double get total => price * quantity;

  // Convert to Map for passing to QuotationPage
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "qty": quantity,
      "rate": price.toInt(),
    };
  }
}

class NewFormPage extends StatefulWidget {
  const NewFormPage({super.key});

  @override
  State<NewFormPage> createState() => _NewFormPageState();
}

class _NewFormPageState extends State<NewFormPage> {
  final List<String> enquiryTypes = [
    'Service',
    'Product',
    'Booking',
    "Schedule",
    // "Bill",
    // "Bill & Quotation", // Added new option
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedEnquiry;

  // Bill & Quotation specific variables
  String _billQuotationType = ''; // 'Bill' or 'Quotation'
  List<Product> _products = [];

  // Controllers for Bill & Quotation
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerMobileController = TextEditingController();
  final TextEditingController customerEmailController = TextEditingController();
  final TextEditingController productNameAddController = TextEditingController();
  final TextEditingController productPriceAddController = TextEditingController();
  final TextEditingController productQuantityController = TextEditingController(text: '1');

  // Your existing controllers (keeping exactly as they were)
  TextEditingController nextMeetingDateController = TextEditingController(text: "");
  TextEditingController nextMeetingTimeController = TextEditingController(text: "");
  final TextEditingController serviceTitleController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productModelController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController collageController = TextEditingController();
  final TextEditingController internPursuingCourse = TextEditingController();
  final TextEditingController internPursuingYear = TextEditingController();
  final TextEditingController internCourseName = TextEditingController();
  final TextEditingController internDuration = TextEditingController();
  final TextEditingController trainingQualification = TextEditingController();
  final TextEditingController trainingCompletedYear = TextEditingController();
  final TextEditingController trainingCourseName = TextEditingController();
  final TextEditingController jobQualification = TextEditingController();
  final TextEditingController jobName = TextEditingController();
  final TextEditingController jobFresherDomain = TextEditingController();
  final TextEditingController jobFresherSkill = TextEditingController();
  final TextEditingController jobYearExperience = TextEditingController();
  final TextEditingController jobWorkExperience = TextEditingController();
  final TextEditingController othersController = TextEditingController();

  bool internship = false;
  bool training = false;
  bool job = false;
  bool fresher = false;
  bool experience = false;
  final List<String> serviceTypes = ['Internship', 'Training', 'Job'];
  final List<String> serviceJobTypes = ['Fresher', 'Experienced'];

  DateTime? nextMeetingDate;
  DateTime? eventDate;
  final RxBool isLoading = false.obs;
  String _selectedEnquiryType = '';
  String _jobType = '';

  // Calculate total amount for Bill & Quotation
  double get totalAmount {
    return _products.fold(0.0, (sum, product) => sum + product.total);
  }

  // Add product to list
  void _addProduct() {
    if (productNameAddController.text.isNotEmpty &&
        productPriceAddController.text.isNotEmpty) {

      double price = double.tryParse(productPriceAddController.text) ?? 0.0;
      int quantity = int.tryParse(productQuantityController.text) ?? 1;

      setState(() {
        _products.add(Product(
          name: productNameAddController.text.trim(),
          price: price,
          quantity: quantity,
        ));
      });

      // Clear controllers
      productNameAddController.clear();
      productPriceAddController.clear();
      productQuantityController.text = '1';

      Get.snackbar(
        "Success",
        "Product added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 1),
      );
    } else {
      Get.snackbar(
        "Error",
        "Please fill product name and price",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Remove product from list
  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  // Generate Bill or Quotation - Updated to navigate to QuotationPage
  void _generateDocument() {
    if (_products.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add at least one product",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (customerNameController.text.isEmpty ||
        customerMobileController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill customer details",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Convert products to the format expected by QuotationPage
    List<Map<String, dynamic>> itemsForQuotation = _products.map((product) => product.toMap()).toList();

    // Navigate to QuotationPage with the data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuotationPage(
          customerName: customerNameController.text.trim(),
          customerMobile: customerMobileController.text.trim(),
          customerEmail: customerEmailController.text.trim(),
          items: itemsForQuotation,
          documentType: _billQuotationType, // 'Bill' or 'Quotation'
        ),
      ),
    ).then((_) {
      // When returning from QuotationPage, ask user if they want to clear the form
      _showClearFormDialog();
    });
  }

  void _showClearFormDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Form?'),
          content: Text('Do you want to clear the current form data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Keep Data'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearBillQuotationForm();
                Get.snackbar(
                  "Success",
                  "Form cleared successfully!",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: Text('Clear Form', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _clearBillQuotationForm() {
    setState(() {
      _billQuotationType = '';
      _products.clear();
      customerNameController.clear();
      customerMobileController.clear();
      customerEmailController.clear();
      productNameAddController.clear();
      productPriceAddController.clear();
      productQuantityController.text = '1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: AppConstants.screenWidth(context),
        color: Colors.white,
        height: AppConstants.screenHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.themeBlue,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Enquiry Form",
                      style: AppTextStyles.appBarWhite21bold,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                bottom: 25,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Enquiry", style: AppTextStyles.black16bold),
                  SizedBox(height: 10),
                  AppDropDownButton(
                    validator: (value) {
                      if (value == null) {
                        return "Select task enquiry";
                      }
                      return null;
                    },
                    onChanged: (String? value) {
                      setState(() {
                        selectedEnquiry = value!;
                        // Reset bill/quotation data when changing enquiry type
                        if (selectedEnquiry != 'Bill & Quotation') {
                          _clearBillQuotationForm();
                        }
                      });
                    },
                    hintText: "Select Enquiry",
                    itemList: enquiryTypes,
                    selectedValue: selectedEnquiry,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bill & Quotation Section (New Implementation)
                      if (selectedEnquiry == 'Bill & Quotation') ...[
                        _buildBillQuotationTypeSelector(),
                        if (_billQuotationType.isNotEmpty) ...[
                          SizedBox(height: 20),
                          _buildCustomerDetailsForm(),
                          SizedBox(height: 20),
                          _buildProductForm(),
                          SizedBox(height: 20),
                          _buildProductList(),
                          if (_products.isNotEmpty) ...[
                            SizedBox(height: 20),
                            _buildTotalAmount(),
                            SizedBox(height: 20),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: _generateDocument,
                                icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                                label: Text(
                                  'Generate $_billQuotationType PDF',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.appColor,
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],

                      // Your existing Bill section (keeping exactly as it was)
                      if (selectedEnquiry == 'Bill')
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QuotationPage(),
                              ));
                            },
                            child: Icon(Icons.add)
                        ),

                      // Your existing Schedule section (keeping exactly as it was)
                      if (selectedEnquiry == 'Schedule')
                        AppTextFields.textFormFieldHeading(
                          context: context,
                          controller: othersController,
                          headingText: "Title *",
                          hintText: "Enter title",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter title";
                            }
                            return null;
                          },
                          inputFormatters: [UpperCaseTextFormatter()],
                        ),

                      // Your existing Service section (keeping exactly as it was)
                      if (selectedEnquiry == 'Service') ...[
                        SizedBox(height: 10),
                        _buildEnquiryTypeSelector(),
                        if (_selectedEnquiryType == 'Internship') ...[
                          AppTextFields.textFormFieldHeading(
                            context: context,
                            controller: internPursuingCourse,
                            headingText: "Pursuing Course",
                            hintText: "Enter your Pursuing Course",
                          ),
                          SizedBox(height: 10),
                          AppTextFields.textFormFieldHeading(
                            context: context,
                            controller: internPursuingYear,
                            headingText: "Pursuing Year",
                            hintText: "Enter year (e.g. 2nd year)",
                          ),
                          SizedBox(height: 10),
                          AppTextFields.textFormFieldHeading(
                            context: context,
                            controller: internCourseName,
                            headingText: "Internship/Course Name",
                            hintText: "Enter your (e.g. Web development)",
                          ),
                          SizedBox(height: 10),
                          AppTextFields.textFormFieldHeading(
                            context: context,
                            controller: internDuration,
                            headingText: "Internship Duration",
                            hintText: "e.g. 1 month, 2 months",
                          ),
                        ],
                        if (_selectedEnquiryType == 'Training') ...[
                          AppTextFields.textFormFieldHeading(
                            context: context,
                            controller: trainingQualification,
                            headingText: "Qualification",
                            hintText: "e.g. B.E, B.Sc",
                          ),
                          SizedBox(height: 10),
                          AppTextFields.textFormFieldHeading(
                            context: context,
                            controller: trainingCompletedYear,
                            headingText: "Completed Year",
                            hintText: "e.g. 2024",
                          ),
                          SizedBox(height: 10),
                          AppTextFields.textFormFieldHeading(
                            context: context,
                            controller: trainingCourseName,
                            headingText: "Course Name",
                            hintText: "e.g. Flutter, MERN full stack",
                          ),
                        ],
                        if (_selectedEnquiryType == 'Job/Career') ...[
                          AppTextFields.textFormFieldHeading(
                            context: context,
                            controller: jobQualification,
                            headingText: "Qualification",
                            hintText: "e.g. M.Tech, BCA",
                          ),
                          SizedBox(height: 10),
                          AppTextFields.textFormFieldHeading(
                            context: context,
                            controller: jobName,
                            headingText: "Job Title",
                            hintText: "e.g. Development, Testing",
                          ),
                          _buildExperienceSelector(),
                        ],
                      ],

                      // Your existing Product section (keeping exactly as it was)
                      if (selectedEnquiry == 'Product')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextFields.textFormFieldHeading(
                              context: context,
                              controller: productNameController,
                              headingText: "Product Name",
                              hintText: "Enter ProductName",
                              inputFormatters: [UpperCaseTextFormatter()],
                            ),
                            SizedBox(height: 20),
                            AppTextFields.textFormFieldHeading(
                              context: context,
                              controller: productModelController,
                              headingText: "Product Model",
                              hintText: "Enter Product Model",
                              inputFormatters: [UpperCaseTextFormatter()],
                            ),
                            SizedBox(height: 20),
                            AppTextFields.textFormFieldHeading(
                              context: context,
                              controller: productPriceController,
                              headingText: "Product Price",
                              hintText: "Enter Product Price",
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ],
                        ),

                      // Your existing Booking section (keeping exactly as it was)
                      if (selectedEnquiry == 'Booking')
                        Column(
                          children: [
                            AppTextFields.textFormFieldHeading(
                              context: context,
                              controller: eventNameController,
                              headingText: "Event Name",
                              hintText: "Enter Event Name",
                              inputFormatters: [UpperCaseTextFormatter()],
                            ),
                            SizedBox(height: 20),
                            AppTextFields.textFormFieldHeading(
                              context: context,
                              controller: eventDateController,
                              suffixIcon: Icon(Icons.calendar_month_outlined),
                              readOnly: true,
                              onChanged: (value) {
                                setState(() {});
                              },
                              headingText: "Event Date",
                              onTap: () async {
                                DateTime? pickedDate =
                                await AppFunctions.pickDate(context);
                                if (pickedDate != null) {
                                  setState(() {
                                    eventDate = pickedDate;
                                    eventDateController.text =
                                        DateFormat.yMMMd().format(eventDate!);
                                  });
                                }
                              },
                            ),
                          ],
                        ),

                      SizedBox(height: 20),

                      // Show common form for all except Bill & Quotation
                      if (selectedEnquiry != 'Bill & Quotation')
                        commonForm(context),

                      SizedBox(height: 25),

                      // Submit button (only show for non-Bill & Quotation)
                      if (selectedEnquiry != 'Bill & Quotation')
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            child: AppButton.AppCustomButton(
                              paddingVertical: 10,
                              paddingHorizontal: 20,
                              onTap: () async {
                                bool isValid = _formKey.currentState!.validate();
                                if (!isValid) return;

                                await Future.delayed(Duration.zero);

                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  final confirm =
                                  await AppPopups.conformationPopup(
                                    context: context,
                                    title: "Are you sure want to Submit?",
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  );
                                  if (confirm != true) return;

                                  isLoading.value = true;
                                  final result = await EnquiryService.addEnquiry(
                                    name: nameController.text.trim(),
                                    mobile: mobileController.text.trim(),
                                    collage: collageController.text.trim(),
                                    email: emailController.text.trim(),
                                    description: descriptionController.text
                                        .trim(),
                                    address: addressController.text.trim(),
                                    formType: selectedEnquiry!,
                                    followUpDate: nextMeetingDate!,
                                    followUpTime: nextMeetingTimeController.text
                                        .trim(),

                                    selectedEnquiryType: _selectedEnquiryType,

                                    /// internship
                                    internshipPursuingCourse: internPursuingCourse
                                        .text
                                        .trim(),
                                    internshipCourseName: internCourseName.text
                                        .trim(),
                                    internshipPursuingYear: internPursuingYear
                                        .text
                                        .trim(),
                                    internshipDuration: internDuration.text
                                        .trim(),

                                    /// training
                                    trainingQualification: trainingQualification
                                        .text
                                        .trim(),
                                    trainingCompletedYear: trainingCompletedYear
                                        .text
                                        .trim(),
                                    trainingCourseName: trainingCourseName.text
                                        .trim(),

                                    /// job
                                    jobQualification: jobQualification.text
                                        .trim(),
                                    jobName: jobName.text.trim(),
                                    jobFresherDomain: jobFresherDomain.text
                                        .trim(),
                                    jobFresherSkill: jobFresherSkill.text.trim(),

                                    jobExperiencedYear: jobYearExperience.text
                                        .trim(),
                                    jobExperiencedMessage: jobWorkExperience.text
                                        .trim(),

                                    otherTitle: othersController.text.trim(),
                                    productName: productNameController.text
                                        .trim(),
                                    productPrice: productPriceController.text
                                        .trim(),
                                    productModel: productModelController.text
                                        .trim(),
                                    eventName: eventNameController.text.trim(),
                                    eventDate: eventDate,
                                  );

                                  isLoading.value = false;

                                  if (result == null) {
                                    // ✅ Success
                                    Get.snackbar(
                                      "Success",
                                      "Enquiry added successfully",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      duration: Duration(seconds: 2),
                                    );

                                    // 🎯 Clear all fields
                                    nameController.clear();
                                    mobileController.clear();
                                    descriptionController.clear();
                                    addressController.clear();
                                    emailController.clear();
                                    collageController.clear();
                                    othersController.clear();
                                    productNameController.clear();
                                    productPriceController.clear();

                                    _selectedEnquiryType = "";
                                    internPursuingCourse.clear();
                                    internPursuingYear.clear();
                                    internCourseName.clear();
                                    internDuration.clear();
                                    trainingQualification.clear();
                                    trainingCompletedYear.clear();
                                    trainingCourseName.clear();
                                    jobQualification.clear();
                                    jobName.clear();
                                    jobFresherDomain.clear();
                                    jobFresherSkill.clear();
                                    jobYearExperience.clear();
                                    jobWorkExperience.clear();

                                    productModelController.clear();
                                    eventNameController.clear();
                                    nextMeetingTimeController.clear();
                                    nextMeetingDateController.clear();
                                    eventDateController.clear();
                                    serviceTitleController.clear();
                                    selectedEnquiry = null;
                                    nextMeetingDate = null;
                                    eventDate = null;
                                    setState(() {
                                      _formKey = GlobalKey<FormState>();
                                    });
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
                              color: AppColors.appColor,
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
    );
  }

  // New Bill & Quotation Widgets
  Widget _buildBillQuotationTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Type", style: AppTextStyles.black16bold),
        SizedBox(height: 10),
        Row(
          children: [
            Radio<String>(
              value: 'Bill',
              groupValue: _billQuotationType,
              onChanged: (value) {
                setState(() {
                  _billQuotationType = value!;
                  _products.clear();
                });
              },
            ),
            Text('Bill', style: AppTextStyles.black14),
            SizedBox(width: 30),
            Radio<String>(
              value: 'Quotation',
              groupValue: _billQuotationType,
              onChanged: (value) {
                setState(() {
                  _billQuotationType = value!;
                  _products.clear();
                });
              },
            ),
            Text('Quotation', style: AppTextStyles.black14),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer Details", style: AppTextStyles.black16bold),
        SizedBox(height: 15),
        AppTextFields.textFormFieldHeading(
          context: context,
          controller: customerNameController,
          headingText: "Customer Name *",
          hintText: "Enter customer name",
          inputFormatters: [UpperCaseTextFormatter()],
        ),
        SizedBox(height: 15),
        AppTextFields.textFormFieldHeading(
          context: context,
          controller: customerMobileController,
          headingText: "Mobile Number *",
          hintText: "Enter mobile number",
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        AppTextFields.textFormFieldHeading(
          context: context,
          controller: customerEmailController,
          headingText: "Email ID",
          hintText: "Enter email id (optional)",
        ),
      ],
    );
  }

  Widget _buildProductForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Add Products", style: AppTextStyles.black16bold),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AppTextFields.textFormFieldHeading(
                context: context,
                controller: productNameAddController,
                headingText: "Product Name",
                hintText: "Product name",
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: AppTextFields.textFormFieldHeading(
                context: context,
                controller: productPriceAddController,
                headingText: "Price",
                hintText: "₹ Price",
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: AppTextFields.textFormFieldHeading(
                context: context,
                controller: productQuantityController,
                headingText: "Qty",
                hintText: "1",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Center(
          child: ElevatedButton.icon(
            onPressed: _addProduct,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('Add Product', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.appColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    if (_products.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Added Products", style: AppTextStyles.black16bold),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                    SizedBox(width: 40), // For delete button
                  ],
                ),
              ),
              // Product list
              ..._products.asMap().entries.map((entry) {
                int index = entry.key;
                Product product = entry.value;
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(product.name)),
                      Expanded(flex: 2, child: Text('₹${product.price.toStringAsFixed(2)}')),
                      Expanded(flex: 1, child: Text('${product.quantity}')),
                      Expanded(flex: 2, child: Text('₹${product.total.toStringAsFixed(2)}')),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _removeProduct(index),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmount() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.appColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.appColor,
            ),
          ),
          Text(
            '₹${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.appColor,
            ),
          ),
        ],
      ),
    );
  }

  // Your existing methods (keeping exactly as they were)
  Widget _buildEnquiryTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Enquiry Type", style: TextStyle(fontWeight: FontWeight.bold)),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedEnquiryType = "";
                  _jobType = "";
                });
              },
              child: Icon(Icons.close, color: Colors.red, size: 20),
            ),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Internship',
              groupValue: _selectedEnquiryType,
              onChanged: (value) {
                setState(() => _selectedEnquiryType = value!);
              },
            ),
            Text('Internship'),
            Radio<String>(
              value: 'Training',
              groupValue: _selectedEnquiryType,
              onChanged: (value) {
                setState(() => _selectedEnquiryType = value!);
              },
            ),
            Text('Training'),
            Radio<String>(
              value: 'Job/Career',
              groupValue: _selectedEnquiryType,
              onChanged: (value) {
                setState(() => _selectedEnquiryType = value!);
              },
            ),
            Text('Job/Career'),
          ],
        ),
      ],
    );
  }

  Widget _buildExperienceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<String>(
              value: 'Fresher',
              groupValue: _jobType,
              onChanged: (value) => setState(() => _jobType = value!),
            ),
            Text("Fresher"),
            Radio<String>(
              value: 'Experienced',
              groupValue: _jobType,
              onChanged: (value) => setState(() => _jobType = value!),
            ),
            Text("Experienced"),
          ],
        ),
        // Only show extra fields if a choice is made
        if (_jobType == 'Fresher') ...[
          AppTextFields.textFormFieldHeading(
            context: context,
            controller: jobFresherDomain,
            headingText: "Domain of Interest",
            hintText: "e.g. Flutter, Web Dev",
          ),
          SizedBox(height: 10),
          AppTextFields.textFormFieldHeading(
            context: context,
            controller: jobFresherSkill,
            headingText: "Skills",
            hintText: "e.g. Dart, Firebase",
          ),
        ] else if (_jobType == 'Experienced') ...[
          AppTextFields.textFormFieldHeading(
            context: context,
            controller: jobYearExperience,
            headingText: "Years of Experience",
            hintText: "e.g. 2",
          ),
          SizedBox(height: 10),
          AppTextFields.textFormFieldHeading(
            context: context,
            controller: jobWorkExperience,
            headingText: "Describe Work Experience",
            hintText: "Your job responsibilities, tools used, etc.",
            maxLines: 4,
          ),
        ],
      ],
    );
  }

  Widget commonForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedEnquiry != 'Schedule')
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
        if (selectedEnquiry != 'Schedule') SizedBox(height: 20),
        if (selectedEnquiry != 'Schedule')
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

        if (selectedEnquiry != 'Schedule')
          AppTextFields.textFormFieldHeading(
            context: context,
            controller: emailController,
            headingText: "Email-id *",
            hintText: "Enter email-id",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter email-id";
              }
              return null;
            },
          ),
        if (selectedEnquiry != 'Schedule') SizedBox(height: 20),
        if (selectedEnquiry != 'Schedule')
          AppTextFields.textFormFieldHeading(
            context: context,
            controller: collageController,
            headingText: "Collage Name *",
            hintText: "Enter collage name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter collage name";
              }
              return null;
            },
          ),
        if (selectedEnquiry != 'Schedule') SizedBox(height: 20),
        if (selectedEnquiry != 'Schedule')
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
        if (selectedEnquiry != 'Schedule') SizedBox(height: 20),

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
}