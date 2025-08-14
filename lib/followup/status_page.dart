import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:relie_nquiry/routes/app_routes.dart';
import '../constants/app_colors.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String selectedFilter = 'All';
  String selectedStatus = 'Open';
  final List<String> statuses = ['Open', 'Completed', 'Close', 'No Response'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFilter = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: AppConstants.screenWidth(context),
          color: Colors.white,
          height: AppConstants.screenHeight(context),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: statuses.map((status) {
                    final bool isSelected = selectedStatus == status;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStatus = status;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (() {
                    var ref = FirebaseFirestore.instance
                        .collection('subscription')
                        .doc(AppConstants.companyName)
                        .collection('enquiry')
                        .where(
                          'user_uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                        );

                    // If date range is selected
                    if (startDate != null && endDate != null) {
                      ref = ref
                          .where(
                            'follow_up_date',
                            isGreaterThanOrEqualTo: Timestamp.fromDate(
                              DateTime(
                                startDate!.year,
                                startDate!.month,
                                startDate!.day,
                                0,
                                0,
                                0,
                              ),
                            ),
                          )
                          .where(
                            'follow_up_date',
                            isLessThanOrEqualTo: Timestamp.fromDate(
                              DateTime(
                                endDate!.year,
                                endDate!.month,
                                endDate!.day,
                                23,
                                59,
                                59,
                                999,
                              ),
                            ),
                          );
                    } else {
                      // Default: All from today and past
                      ref = ref.where(
                        'follow_up_date',
                        isLessThanOrEqualTo: Timestamp.fromDate(
                          DateTime.now().copyWith(
                            hour: 23,
                            minute: 59,
                            second: 59,
                            millisecond: 999,
                          ),
                        ),
                      );
                    }

                    return ref
                        .orderBy('follow_up_date', descending: false)
                        .snapshots();
                  })(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No enquiries found'));
                    }

                    final allData = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      data['id'] = doc.id;
                      return data;
                    }).toList();

                    // Apply status and form_type filters
                    final filtered = allData.where((item) {
                      final statusMatch =
                          selectedStatus == 'All' ||
                          item['status'] == selectedStatus;
                      final typeMatch =
                          selectedFilter == 'All' ||
                          item['form_type'] == selectedFilter;

                      final name = (item['name'] ?? '')
                          .toString()
                          .toLowerCase();
                      final phone = (item['mobile'] ?? '')
                          .toString()
                          .toLowerCase();
                      final matchesSearch =
                          searchText.isEmpty ||
                          name.contains(searchText) ||
                          phone.contains(searchText);

                      return statusMatch && typeMatch && matchesSearch;
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(child: Text('No enquiries found'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return InkWell(
                          onTap: () {
                            Get.toNamed(
                              Routes.followUpDetailsScreen,
                              arguments: item,
                            );
                          },
                          child: _buildFollowUpItem(snapchat: item),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController searchController = TextEditingController();
  String searchText = "";
  bool isDateSelected = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        color: AppColors.themeBlue,
        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xFF229CB8),
        //     Color(0xFF2098B3),
        //     Color(0xFF13859f),
        //     Color(0xFF066a81),
        //   ],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        // ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Text(
                  'Enquiry',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    if (isDateSelected) {
                      // If already selected, clear selection
                      setState(() {
                        isDateSelected = false;
                        startDate = null;
                        endDate = null;
                      });
                    } else {
                      showCustomDateRangePicker(
                        context,
                        dismissible: true,
                        minimumDate: DateTime(2022),
                        maximumDate: DateTime.now(),
                        endDate: endDate,
                        startDate: startDate,
                        backgroundColor: Colors.white,
                        primaryColor: AppColors.appColor,
                        onApplyClick: (start, end) {
                          setState(() {
                            startDate = start;
                            endDate = end;
                            isDateSelected = true;
                          });
                        },
                        onCancelClick: () {
                          setState(() {
                            startDate = null;
                            endDate = null;
                            isDateSelected = false;
                          });
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      isDateSelected ? Icons.close : Icons.calendar_today,
                      size: 18,
                      color: isDateSelected ? Colors.red : AppColors.appColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value.trim().toLowerCase();
                });
              },
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.themeRed,
                        ),
                        onPressed: () {
                          setState(() {
                            searchText = "";
                            searchController
                                .clear(); // This clears the visible field
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 20,
                          color: AppColors.white,
                        ),
                        onPressed: () {},
                      ),
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', selectedFilter == 'All'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Service', selectedFilter == 'Service'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Product', selectedFilter == 'Product'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Booking', selectedFilter == 'Booking'),
                  // const SizedBox(width: 12),
                  // _buildFilterChip('Others', selectedFilter == 'Others'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white12,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4A90A4) : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFollowUpItem({required Map<String, dynamic> snapchat}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (snapchat['form_type'] == 'Schedule')Text(
                        snapchat["others_title"] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appColor,
                        ),
                      ),
                      Text(
                        snapchat["name"] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (snapchat['form_type'] == 'Service')
                    Text(
                      snapchat['isInternship'] == true
                          ? "Course: ${snapchat['internshipCourseName']}" ?? ''
                          : snapchat['isTraining'] == true
                          ? "Course: ${snapchat['trainingCourseName']}" ?? ''
                          : snapchat['isJobFresher'] == true
                          ? "Job Role: ${snapchat['jobName']}" ?? ''
                          : snapchat['isJobExperienced'] == true
                          ? "Job Role: ${snapchat['jobName']}" ?? ''
                          : '',
                    ),
                  if (snapchat['form_type'] == 'Product')
                    Text('Product: ${snapchat['product_name'] ?? ''}'),
                  if (snapchat['form_type'] == 'Booking')
                    Text('Event Name: ${snapchat['event_name'] ?? ''}'),
                  // if (snapchat['form_type'] == 'Others')
                  //   Text('Title: ${snapchat['others_title'] ?? ''}'),
                  const SizedBox(height: 8),
                  Text(
                    'Follow Up Date: ${snapchat["follow_up_date"] != null ? DateFormat('dd/MM/yyyy').format((snapchat["follow_up_date"] as Timestamp).toDate()) : ''}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  snapchat['isInternship'] == true
                      ? "Internship" ?? ''
                      : snapchat['isTraining'] == true
                      ? "Training" ?? ''
                      : snapchat['isJobFresher'] == true
                      ? "Job: Fresher" ?? ''
                      : snapchat['isJobExperienced'] == true
                      ? "Job: Experienced" ?? ''
                      : 'No Title',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getFormTypeColor(snapchat["form_type"] ?? ''),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    snapchat["form_type"] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getFormTypeColor(String type) {
    switch (type) {
      case 'Service':
        return const Color(0xFFf9b401);
      case 'Product':
        return const Color(0xFF622fa4);
      case 'Booking':
        return const Color(0xFFf8681a);
      default:
        return const Color(0xFF3754db);
    }
  }
}
