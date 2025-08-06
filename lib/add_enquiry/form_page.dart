// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:relie_nquiry/constants/uppercase_formatter.dart';
// import '../constants/app_button.dart';
// import '../constants/app_colors.dart';
// import '../constants/app_constants.dart';
// import '../constants/app_text_styles.dart';
// import '../constants/funtions/enquiry_funtions.dart';
// import '../constants/text_fields.dart';
//
// class FormPage extends StatefulWidget {
//   const FormPage({super.key});
//
//   @override
//   State<FormPage> createState() => _FormPageState();
// }
//
// class _FormPageState extends State<FormPage> {
//   String? selectedEnquiry;
//   String? selectedServiceType;
//   final TextEditingController eventDateController = TextEditingController();
//
//   final TextEditingController typedEventController = TextEditingController();
//
//   // Form controllers - moved to class level
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController followUpDateController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController serviceController = TextEditingController();
//
//   final List<String> enquiryTypes = [
//     'Service',
//     'Product',
//     'Schedule',
//     "Others",
//   ];
//
//   final Map<String, List<String>> productModelMap = {
//     "Washing Machine": ["LG TurboWash", "Samsung EcoBubble", "Bosch Serie 6"],
//     "Refrigerator": ["Whirlpool 265L", "Samsung 345L", "Godrej Edge"],
//     "Microwave": ["IFB 30L", "Samsung 28L", "Panasonic 23L"],
//   };
//
//   String? selectedProduct;
//   String? selectedModel;
//
//   final List<String> eventList = ["Orientation", "Workshop", "Webinar"];
//   String? selectedEvent;
//   String? typedEvent;
//   DateTime? selectedEventDate;
//   DateTime? selectedFollowUpDate;
//
//   bool showTextField = false;
//
//   // bool needQuotation = false;
//   bool isSubmitting = false;
//
//   // Firebase Firestore instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   void dispose() {
//     // Dispose all controllers
//     eventDateController.dispose();
//     typedEventController.dispose();
//     nameController.dispose();
//     mobileController.dispose();
//     descriptionController.dispose();
//     followUpDateController.dispose();
//     addressController.dispose();
//     serviceController.dispose();
//     super.dispose();
//   }
//
//   // Clear all form fields
//   void clearFormFields() {
//     nameController.clear();
//     mobileController.clear();
//     descriptionController.clear();
//     followUpDateController.clear();
//     addressController.clear();
//     serviceController.clear();
//     eventDateController.clear();
//     typedEventController.clear();
//     setState(() {
//       selectedFollowUpDate = null;
//       selectedEventDate = null;
//       selectedProduct = null;
//       selectedModel = null;
//       selectedEvent = null;
//       typedEvent = null;
//       // needQuotation = false;
//     });
//   }
//
//   void showSuccessDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent tap to close
//       builder: (BuildContext context) {
//         Future.delayed(const Duration(seconds: 2), () {
//           if (Navigator.canPop(context)) {
//             Navigator.of(context).pop(); // Close the dialog after 2 seconds
//           }
//         });
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           elevation: 10,
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.green.shade100,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check_circle,
//                     color: Colors.green,
//                     size: 50,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   message,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Your enquiry has been submitted successfully!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Enhanced Firebase Firestore submission function
//   Future<void> submitForm() async {
//     // Step 1: Basic validation
//     if (nameController.text.trim().isEmpty ||
//         mobileController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Name and Mobile are required"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       isSubmitting = true;
//     });
//
//     try {
//       // Step 2: Call the EnquiryService to add the enquiry
//       String? error = await EnquiryService.addEnquiry(
//         name: nameController.text.trim(),
//         mobile: mobileController.text.trim(),
//         description: descriptionController.text.trim(),
//         address: addressController.text.trim(),
//         followUpDate: selectedFollowUpDate ?? DateTime.now(),
//         formType: selectedEnquiry ?? '',
//
//         eventDate: selectedEventDate,
//         eventName: typedEventController.text.trim(),
//
//         productName: selectedProduct,
//         serviceTitle: serviceController.text.trim(),
//       );
//
//       if (error == null) {
//         // Step 3: Show success dialog
//         showSuccessDialog(context, "Form Submitted Successfully!");
//
//         // Step 4: Clear form
//         Future.delayed(const Duration(seconds: 2), () {
//           clearFormFields();
//         });
//       } else {
//         // Step 5: Show error from service
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(error), backgroundColor: Colors.red),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Unexpected error: ${e.toString()}"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         isSubmitting = false;
//       });
//     }
//   }
//
//   Future<void> selectFollowUpDateTime() async {
//     // Step 1: Pick Date with custom theme
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.appColor, // Header background & OK button
//               onPrimary: Colors.white, // Header text color
//               onSurface: Colors.black, // Body text color
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: AppColors.appColor, // Button text color
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedDate != null) {
//       // Step 2: Pick Time with custom theme
//       final pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(DateTime.now()),
//         builder: (context, child) {
//           return Theme(
//             data: ThemeData.light().copyWith(
//               colorScheme: ColorScheme.light(
//                 primary: AppColors.appColor, // Dial color and OK button
//                 onPrimary: Colors.white,
//                 onSurface: Colors.black,
//               ),
//               textButtonTheme: TextButtonThemeData(
//                 style: TextButton.styleFrom(
//                   foregroundColor: AppColors.appColor,
//                 ),
//               ),
//             ),
//             child: child!,
//           );
//         },
//       );
//
//       if (pickedTime != null) {
//         final combinedDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//
//         setState(() {
//           selectedFollowUpDate = combinedDateTime;
//           followUpDateController.text = DateFormat(
//             'dd/MM/yyyy hh:mm a',
//           ).format(combinedDateTime);
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: AppConstants.screenWidth(context),
//       color: Colors.white,
//       height: AppConstants.screenHeight(context),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//
//         children: [
//           ClipPath(
//             clipper: ArcClipper(),
//             child: Container(
//               height: 140,
//               decoration: const BoxDecoration(
//                 gradient: AppColors.themGradient,
//                 borderRadius: BorderRadius.only(
//                   bottomRight: Radius.circular(30),
//                   bottomLeft: Radius.circular(30),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 20, left: 15),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const Center(
//             child: Text(
//               "Select Enquiry",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.teal, width: 1.5),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   dropdownColor: Colors.white,
//                   borderRadius: const BorderRadius.all(Radius.circular(5)),
//                   value: selectedEnquiry,
//                   hint: const Text(
//                     "Choose Enquiry Type",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   isExpanded: true,
//                   items:
//                       enquiryTypes.map((String item) {
//                         return DropdownMenuItem<String>(
//                           value: item,
//                           child: Text(
//                             item,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedEnquiry = value;
//                       selectedServiceType = null;
//                       selectedProduct = null;
//                       selectedModel = null;
//                       selectedEvent = null;
//                       typedEvent = null;
//                       selectedEventDate = null;
//                       eventDateController.clear();
//                       // Clear form fields when enquiry type changes
//                       clearFormFields();
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),
//
//           if (selectedEnquiry == 'Service') ...[
//             const SizedBox(height: 20),
//             buildEnquiryForm(context),
//           ],
//           const SizedBox(height: 20),
//           if (selectedEnquiry == 'Product') ...[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Select Product & Model",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       // Product Dropdown
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           dropdownColor: Colors.white,
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(5),
//                           ),
//                           value: selectedProduct,
//                           hint: const Text("Product"),
//                           items:
//                               productModelMap.keys.map((product) {
//                                 return DropdownMenuItem<String>(
//                                   value: product,
//                                   child: Text(
//                                     product,
//                                     overflow: TextOverflow.ellipsis,
//                                     // Ellipsis for long text
//                                     maxLines: 1,
//                                     style: const TextStyle(fontSize: 14),
//                                   ),
//                                 );
//                               }).toList(),
//                           onChanged: (val) {
//                             setState(() {
//                               selectedProduct = val;
//                               selectedModel = null;
//                             });
//                           },
//                           decoration: InputDecoration(
//                             hintText: "Product",
//                             isDense: true,
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 14,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: AppColors.appColor,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(width: 15),
//
//                       // Model Dropdown
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: selectedModel,
//                           dropdownColor: Colors.white,
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(5),
//                           ),
//                           hint: const Text(
//                             "Model",
//                             // style: TextStyle(color: Colors.grey), // Grey hint text
//                           ),
//                           items:
//                               selectedProduct != null
//                                   ? productModelMap[selectedProduct]!.map((
//                                     model,
//                                   ) {
//                                     return DropdownMenuItem(
//                                       value: model,
//                                       child: Text(
//                                         model,
//                                         overflow: TextOverflow.ellipsis,
//                                         // Prevent overflow
//                                         maxLines: 1, // Single line only
//                                       ),
//                                     );
//                                   }).toList()
//                                   : [],
//                           onChanged: (val) {
//                             setState(() {
//                               selectedModel = val;
//                             });
//                           },
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: const BorderSide(
//                                 color: Colors.grey,
//                               ), // Grey border initially
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: const BorderSide(
//                                 color: Colors.grey,
//                               ), // Grey when not focused
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: AppColors.appColor,
//                                 width: 2,
//                               ), // App color when focused
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 14,
//                             ),
//                           ),
//                           style: const TextStyle(
//                             color: Colors.black, // Always black text
//                           ),
//                           iconEnabledColor: Colors.black,
//                           // Black dropdown icon
//                           iconDisabledColor:
//                               Colors.black, // Black dropdown icon when disabled
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             if (selectedProduct != null && selectedModel != null)
//               buildEnquiryForm(context),
//           ],
//
//           if (selectedEnquiry == 'Schedule') ...[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Event Name and Date",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: TextFormField(
//                           controller: typedEventController,
//                           decoration: InputDecoration(
//                             hintText: "Type new event name",
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: AppColors.appColor,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                           onChanged: (val) {
//                             setState(() {
//                               typedEvent = val;
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         flex: 2,
//                         child: TextFormField(
//                           controller: eventDateController,
//                           readOnly: true,
//                           decoration: InputDecoration(
//                             hintText: "dd/mm/yyyy",
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 Icons.calendar_today,
//                                 color:
//                                     AppColors
//                                         .appColor, // App color for calendar icon
//                               ),
//                               onPressed: () async {
//                                 final picked = await showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(2020),
//                                   lastDate: DateTime(2030),
//                                   builder: (context, child) {
//                                     return Theme(
//                                       data: ThemeData.light().copyWith(
//                                         colorScheme: ColorScheme.light(
//                                           primary: AppColors.appColor,
//                                           // Header, selected date
//                                           onPrimary: Colors.white,
//                                           // Text on header
//                                           onSurface:
//                                               Colors
//                                                   .black, // Calendar body text
//                                         ),
//                                         textButtonTheme: TextButtonThemeData(
//                                           style: TextButton.styleFrom(
//                                             foregroundColor:
//                                                 AppColors
//                                                     .appColor, // OK/Cancel color
//                                           ),
//                                         ),
//                                       ),
//                                       child: child!,
//                                     );
//                                   },
//                                 );
//                                 if (picked != null) {
//                                   setState(() {
//                                     selectedEventDate = picked;
//                                     eventDateController.text = DateFormat(
//                                       'dd/MM/yyyy',
//                                     ).format(picked);
//                                   });
//                                 }
//                               },
//                             ),
//                             isDense: true,
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 14,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: const BorderSide(color: Colors.grey),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: const BorderSide(color: Colors.grey),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: AppColors.appColor,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//             if (typedEvent != null &&
//                 typedEvent!.isNotEmpty &&
//                 selectedEventDate != null)
//               buildEnquiryForm(context),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget buildEnquiryForm(BuildContext context) {
//     return Expanded(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 25.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Text(
//                 '${selectedEnquiry} Form',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: AppColors.appColor,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             if (selectedEnquiry == 'Service')
//               AppTextFields.textFormFieldHeading(
//                 context: context,
//                 controller: serviceController,
//                 headingText: "Service Title",
//                 hintText: "Enter Service title",
//                 inputFormatters: [UpperCaseTextFormatter()],
//               ),
//             if (selectedEnquiry == 'Service') const SizedBox(height: 20),
//
//             AppTextFields.textFormFieldHeading(
//               context: context,
//               controller: nameController,
//               headingText: "Name *",
//               inputFormatters: [UpperCaseTextFormatter()],
//               hintText: "Enter name",
//             ),
//             const SizedBox(height: 20),
//
//             AppTextFields.textFormFieldHeading(
//               context: context,
//               controller: mobileController,
//               headingText: "Mobile number *",
//               hintText: "Enter mobile number",
//               keyboardType: TextInputType.phone,
//               maxLength: 10,
//
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             ),
//             const SizedBox(height: 20),
//
//             AppTextFields.textFormFieldHeading(
//               context: context,
//               controller: addressController,
//               headingText: "Address",
//               hintText: "Enter address",
//               maxLines: 3,
//             ),
//             const SizedBox(height: 20),
//
//             AppTextFields.textFormFieldHeading(
//               context: context,
//               controller: descriptionController,
//               headingText: "Description",
//               hintText: "Enter description",
//               maxLines: 3,
//             ),
//             const SizedBox(height: 20),
//
//             const Text(
//               "Follow up date",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             const SizedBox(height: 10),
//
//             TextFormField(
//               controller: followUpDateController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 hintText: "dd/mm/yyyy",
//                 suffixIcon: IconButton(
//                   icon: Container(
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: AppColors.appColor,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: const Icon(
//                       Icons.calendar_today,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                   onPressed: selectFollowUpDateTime,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             // const SizedBox(height: 25),
//             //
//             // Row(
//             //   children: [
//             //     Checkbox(
//             //       value: needQuotation,
//             //       onChanged: (val) {
//             //         setState(() => needQuotation = val ?? false);
//             //       },
//             //     ),
//             //     const Text("Need Quotation", style: TextStyle(fontSize: 16)),
//             //   ],
//             // ),
//             const SizedBox(height: 20),
//
//             Center(
//               child: AppButton.AppCustomButton(
//                 paddingVertical: 8,
//                 paddingHorizontal: 20,
//                 onTap: submitForm,
//                 text: "Submit",
//                 style: AppTextStyles.white18bold,
//                 color: AppColors.appColor,
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
