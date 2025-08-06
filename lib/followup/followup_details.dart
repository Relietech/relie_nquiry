import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:relie_nquiry/constants/app_funtion.dart';
import 'package:relie_nquiry/constants/app_text_styles.dart';
import 'package:relie_nquiry/constants/text_fields.dart';
import 'package:relie_nquiry/constants/uppercase_formatter.dart';
import 'package:relie_nquiry/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/funtions/enquiry_funtions.dart';

class FollowDetailsPage extends StatefulWidget {
  final snapshot = Get.arguments;

  FollowDetailsPage({super.key});

  @override
  State<FollowDetailsPage> createState() => _FollowDetailsPageState();
}

class _FollowDetailsPageState extends State<FollowDetailsPage> {
  String selectedStatus = 'Open';
  Map<String, dynamic>? data;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _descriptionFollowupController =
      TextEditingController();

  TextEditingController nextMeetingDateController = TextEditingController(
    text: "",
  );
  TextEditingController nextMeetingTimeController = TextEditingController(
    text: "",
  );
  DateTime? nextMeetingDates;

  final List<Map<String, dynamic>> statusOptions = [
    {'value': 'Open', 'label': 'Open', 'color': Colors.black87},
    {'value': 'Completed', 'label': 'Completed', 'color': Colors.green},
    {'value': 'Close', 'label': 'Close', 'color': Colors.red},
    {'value': 'No Response', 'label': 'No Response', 'color': Colors.blue},
  ];
  String? _userRole;

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('user_role');
    });

    print("_userRole : $_userRole");
  }

  @override
  void initState() {
    super.initState();
    // Initialize selectedStatus with the current status from snapshot
    selectedStatus = widget.snapshot['status'] ?? 'Open';
    _loadUserRole();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _showFollowupUpdateBottomSheet({
    required String docId,
    required String status,
    required String formType,
  }) {
    _descriptionFollowupController.clear();
    nextMeetingDateController.clear();
    nextMeetingTimeController.clear();
    nextMeetingDates = null;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Next Meeting',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppTextFields.textFormFieldHeading(
                        context: context,
                        controller: nextMeetingDateController,
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
                        readOnly: true,
                        headingText: "Next Meeting Date *",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select next meeting date";
                          }
                          return null;
                        },
                        onTap: () async {
                          DateTime? pickedDate = await AppFunctions.pickDate(
                            context,
                          );
                          if (pickedDate != null) {
                            setModalState(() {
                              nextMeetingDates = pickedDate;
                              nextMeetingDateController.text =
                                  DateFormat.yMMMd().format(nextMeetingDates!);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      AppTextFields.textFormFieldHeading(
                        context: context,
                        controller: nextMeetingTimeController,
                        suffixIcon: const Icon(Icons.access_time_rounded),
                        readOnly: true,
                        headingText: "Next Meeting Time *",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select next meeting time";
                          }
                          return null;
                        },
                        onTap: () async {
                          TimeOfDay? pickedTime = await AppFunctions.pickTime(
                            context,
                          );
                          if (pickedTime != null) {
                            setModalState(() {
                              nextMeetingTimeController.text = pickedTime
                                  .format(context); // e.g., 12:56 PM
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      AppTextFields.textFormFieldHeading(
                        context: context,
                        controller: _descriptionFollowupController,
                        headingText: "Description",
                        hintText: "Enter description",
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  Colors.grey.shade200,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final followUpTime = nextMeetingTimeController
                                    .text
                                    .trim();
                                final description =
                                    _descriptionFollowupController.text.trim();

                                if (nextMeetingDates == null ||
                                    followUpTime.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Date and time are required",

                                    backgroundColor: Colors.red.shade600,
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(12),
                                    borderRadius: 8,
                                  );

                                  return;
                                }

                                final followupEntry = {
                                  "date": nextMeetingDates,
                                  "time": followUpTime,
                                  "status": status,
                                  "description": description,
                                  "user_uid":
                                      FirebaseAuth.instance.currentUser!.uid,
                                };

                                final String? uid =
                                    FirebaseAuth.instance.currentUser?.uid;
                                // if (uid == null) return "User not logged in";

                                // Step 1: Get employee_id from users collection
                                DocumentSnapshot userDoc =
                                    await FirebaseFirestore.instance
                                        .collection('subscription')
                                        .doc(AppConstants.companyName)
                                        .collection("users")
                                        .doc(uid)
                                        .get();

                                if (!userDoc.exists) {
                                  print("User document not found");
                                }

                                final data =
                                    userDoc.data() as Map<String, dynamic>;

                                try {
                                  await FirebaseFirestore.instance
                                      .collection("subscription")
                                      .doc(AppConstants.companyName)
                                      .collection("enquiry")
                                      .doc(docId)
                                      .update({
                                        "followup_history":
                                            FieldValue.arrayUnion([
                                              followupEntry,
                                            ]),
                                        "follow_up_date": nextMeetingDates,
                                        "follow_up_time": followUpTime,
                                      })
                                      .then((value) async {
                                        await EnquiryService.sendNotificationFolloup(
                                          data: data,
                                          formType: formType,
                                        );
                                      });

                                  Get.offAllNamed(Routes.homeScreen);

                                  Get.snackbar(
                                    "Follow-up",
                                    "Follow-up updated successfully",
                                    backgroundColor: Colors.green.shade600,
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(12),
                                    borderRadius: 8,
                                  );
                                } catch (e) {
                                  print("Error updating: $e");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF229CB8),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showStatusBottomSheet() {
    String tempSelectedStatus = selectedStatus;
    _descriptionController.clear();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Update Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status Options
                    ...statusOptions.map(
                      (option) => GestureDetector(
                        onTap: () {
                          setModalState(() {
                            tempSelectedStatus = option['value'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: tempSelectedStatus == option['value']
                                ? option['color'].withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: option['color'],
                                    width: 2,
                                  ),
                                ),
                                child: tempSelectedStatus == option['value']
                                    ? Container(
                                        margin: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: option['color'],
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                option['label'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: option['color'],
                                  fontWeight:
                                      tempSelectedStatus == option['value']
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              if (tempSelectedStatus == option['value'])
                                Icon(
                                  Icons.check,
                                  color: option['color'],
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppTextFields.textFormFieldHeading(
                      context: context,
                      controller: _descriptionController,
                      headingText: 'Description',
                      inputFormatters: [UpperCaseTextFormatter()],
                      hintText: 'Enter status description or notes...',
                      maxLines: 3,
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                Colors.grey.shade200,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await updateStatus(
                                docId: widget.snapshot["docId"],
                                formType: widget.snapshot["form_type"],
                                newStatus: tempSelectedStatus,
                                description: _descriptionController.text.trim(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF229CB8),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> updateStatus({
    required String docId,
    required String newStatus,
    required String description,
    required String formType,
  }) async {
    if (docId.isEmpty) {
      Get.snackbar(
        'Error',
        'Document ID is missing',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Show loading
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: AppColors.appColor),
        ),
      );

      String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
      // Prepare follow-up history entry
      final followUpEntry = {
        "date": DateTime.now(),
        "time": formattedTime,
        "status": newStatus,
        "description": description,
        "user_uid": FirebaseAuth.instance.currentUser!.uid,
      };

      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      // if (uid == null) return "User not logged in";

      // Step 1: Get employee_id from users collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('subscription')
          .doc(AppConstants.companyName)
          .collection("users")
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        print("User document not found");
      }

      final data = userDoc.data() as Map<String, dynamic>;
      // Update Firestore document
      await FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection("enquiry")
          .doc(docId)
          .update({
            'status': newStatus,
            'followup_history': FieldValue.arrayUnion([followUpEntry]),
          })
          .then((value) async {
            await EnquiryService.sendNotificationStatus(
              data: data,
              formType: formType,
              status: newStatus,
            );
          });

      // Close loading
      if (Get.isDialogOpen ?? false) Get.back();

      // Navigate to status page
      Get.offAllNamed(Routes.homeScreen);

      // Show success
      Get.snackbar(
        'Success',
        'Status updated to "$newStatus"',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back(); // Close loading

      String errorMessage = 'Failed to update status';
      if (e.toString().contains('not-found')) {
        errorMessage = 'Document not found. It may have been deleted.';
      } else if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied. Check your Firestore rules.';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.toString().contains('unavailable')) {
        errorMessage = 'Service temporarily unavailable. Please try again.';
      }

      Get.snackbar(
        'Error',
        "Update Failed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Close':
        return Colors.red;
      case 'No Response':
        return Colors.blue;
      case 'Open':
      default:
        return Colors.black87;
    }
  }

  Color _getFormColor(String? formType) {
    switch (formType) {
      case 'Service':
        return const Color(0xFFf9b401);
      case 'Product':
        return const Color(0xFF622fa4);
      case 'Schedule':
        return const Color(0xFFf8681a);
      default:
        return const Color(0xFF3754db);
    }
  }

  String formatFollowUpDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawDate);
      return '${DateFormat('dd/MM/yyyy').format(dt)}\n${DateFormat('hh:mm a').format(dt)}';
    } catch (_) {
      return rawDate;
    }
  }

  Widget buildLabelRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            ':',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF666666),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
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
                    // Back icon aligned to top-left
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.homeScreen);
                          },
                          child: const Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    // Title centered at the top
                    const Text(
                      "Details",
                      style: AppTextStyles.appBarWhite21bold,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 3,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.snapshot['name'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    if (_userRole == 'Admin' ||
                                        _userRole == 'Super Admin')
                                      if (widget.snapshot['employee_id'] !=
                                          "Super Admin")
                                        Text(
                                          widget.snapshot['employee_id'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getFormColor(
                                      widget.snapshot["form_type"],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.snapshot["form_type"] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              widget.snapshot['isInternship'] == true
                                  ? "Internship" ?? ''
                                  : widget.snapshot['isTraining'] == true
                                  ? "Training" ?? ''
                                  : widget.snapshot['isJobFresher'] == true
                                  ? "Job: Fresher" ?? ''
                                  : widget.snapshot['isJobExperienced'] == true
                                  ? "Job: Experienced" ?? ''
                                  : 'No Title',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (widget.snapshot['form_type'] == 'Service') ...[
                              buildLabelRow(
                                /// title
                                widget.snapshot['isJobFresher'] == true ||
                                        widget.snapshot['isJobExperienced'] ==
                                            true
                                    ? "Job Role"
                                    : "Course",

                                ///  value
                                widget.snapshot['isInternship'] == true
                                    ? "${widget.snapshot['internshipCourseName']}" ??
                                          ''
                                    : widget.snapshot['isTraining'] == true
                                    ? "${widget.snapshot['trainingCourseName']}" ??
                                          ''
                                    : widget.snapshot['isJobFresher'] == true
                                    ? "${widget.snapshot['jobName']}" ?? ''
                                    : widget.snapshot['isJobExperienced'] ==
                                          true
                                    ? "${widget.snapshot['jobName']}" ?? ''
                                    : 'No Title',
                                // "Service Title",
                                // widget.snapshot['service_title'] ?? '',
                              ),
                            ] else if (widget.snapshot['form_type'] ==
                                'Product') ...[
                              buildLabelRow(
                                "Product Name",
                                "${widget.snapshot['product_name'] ?? ''}",
                              ),
                              buildLabelRow(
                                "Product Model",
                                "${widget.snapshot['product_model'] ?? ''}",
                              ),
                              buildLabelRow(
                                "Product Price",
                                "${widget.snapshot['product_price'] ?? ''}",
                              ),
                            ] else if (widget.snapshot['form_type'] ==
                                'Schedule') ...[
                              buildLabelRow(
                                "Event Name",
                                widget.snapshot['event_name'] ?? '',
                              ),
                              buildLabelRow(
                                "Event Date",
                                "${DateFormat('dd/MM/yyyy').format((widget.snapshot["event_date"] as Timestamp).toDate())}",
                              ),
                            ],
                            // else if (widget.snapshot['form_type'] ==
                            //     'Others') ...[
                            //   buildLabelRow(
                            //     "Title",
                            //     widget.snapshot['others_title'] ?? '',
                            //   ),
                            // ],
                            buildLabelRow(
                              "Mobile No",
                              widget.snapshot?["mobile"] ?? '',
                            ),
                            buildLabelRow(
                              "Address",
                              widget.snapshot?["address"] ?? '',
                            ),
                            if (widget.snapshot["followup_description"] != "")
                              buildLabelRow(
                                "Description",

                                widget.snapshot["followup_description"] ?? '',
                              ),
                            const SizedBox(height: 20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Follow Up Date",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    _showFollowupUpdateBottomSheet(
                                      docId: widget.snapshot["docId"],
                                      status: selectedStatus,
                                      formType: widget.snapshot["form_type"],
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.appColor.withOpacity(
                                        0.2,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.snapshot["follow_up_date"] !=
                                                  null
                                              ? "${DateFormat('dd/MM/yyyy').format((widget.snapshot["follow_up_date"] as Timestamp).toDate())} - ${widget.snapshot["follow_up_time"]}"
                                              : 'No follow-up date',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                            height: 1.3,
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showStatusBottomSheet,
                      child: Card(
                        color: Colors.white,
                        elevation: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: AppColors.appColor,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 7,
                                      backgroundColor: _getStatusColor(
                                        selectedStatus,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedStatus,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: _getStatusColor(selectedStatus),
                                      ),
                                    ),
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppFunctions.launchPhone(widget.snapshot?["mobile"]);
          },
          elevation: 5,
          shape: const CircleBorder(),
          backgroundColor: Colors.green,
          child: Icon(Icons.phone, color: Colors.white),
        ),
      ),
    );
  }
}
