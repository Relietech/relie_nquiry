// // import 'package:custom_date_range_picker/custom_date_range_picker.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:get/get.dart';
// // import 'package:intl/intl.dart';
// // import 'package:relie_nquiry/bill&quotation/bill_quotation_list_page.dart';
// // import 'package:relie_nquiry/constants/app_constants.dart';
// // import 'package:relie_nquiry/routes/app_routes.dart';
// // import '../../constants/app_colors.dart';
// // import '../../constants/app_text_styles.dart';
// // import 'bill_quotation_list_page.dart';
// //
// // class BillsQuotationsPage extends StatefulWidget {
// //   const BillsQuotationsPage({super.key});
// //
// //   @override
// //   State<BillsQuotationsPage> createState() => _BillsQuotationsPageState();
// // }
// //
// // class _BillsQuotationsPageState extends State<BillsQuotationsPage> {
// //   String selectedFilter = 'All';
// //   String selectedStatus = 'Pending';
// //   final List<String> statuses = ['Pending', 'Paid', 'Overdue', 'Cancelled'];
// //
// //   // Date filter variables
// //   DateTime? startDate;
// //   DateTime? endDate;
// //   bool isDateSelected = false;
// //
// //   // Search variables
// //   final TextEditingController searchController = TextEditingController();
// //   String searchText = "";
// //
// //   // Employee filter variables
// //   String? selectedEmployee;
// //   List<Map<String, dynamic>> employeeList = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchEmployees();
// //   }
// //
// //   @override
// //   void dispose() {
// //     searchController.dispose();
// //     super.dispose();
// //   }
// //
// //   void fetchEmployees() async {
// //     final snapshot = await FirebaseFirestore.instance
// //         .collection('subscription')
// //         .doc(AppConstants.companyName)
// //         .collection('users')
// //         .where('role', whereIn: ['Employee', 'Admin', "Super Admin"])
// //         .get();
// //
// //     final List<Map<String, dynamic>> employees = snapshot.docs.map((doc) {
// //       final data = doc.data();
// //       return {'uid': data['uid'], 'name': data['name'] ?? ''};
// //     }).toList();
// //
// //     setState(() {
// //       employeeList = employees;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         body: Container(
// //           width: AppConstants.screenWidth(context),
// //           color: Colors.white,
// //           height: AppConstants.screenHeight(context),
// //           child: Column(
// //             children: [
// //               _buildHeader(),
// //               const SizedBox(height: 10),
// //
// //               // Status filter chips
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: statuses.map((status) {
// //                     final bool isSelected = selectedStatus == status;
// //                     return GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           selectedStatus = status;
// //                         });
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 12,
// //                           vertical: 8,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: isSelected ? Colors.black : Colors.grey[300],
// //                           borderRadius: BorderRadius.circular(6),
// //                         ),
// //                         child: Text(
// //                           status,
// //                           style: TextStyle(
// //                             color: isSelected ? Colors.white : Colors.black,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //
// //               // Bills & Quotations List
// //               Expanded(
// //                 child: StreamBuilder<QuerySnapshot>(
// //                   stream: (() {
// //                     Query<Map<String, dynamic>> ref = FirebaseFirestore.instance
// //                         .collection('subscription')
// //                         .doc(AppConstants.companyName)
// //                         .collection('Bill&Quotation'); // Changed collection name
// //
// //                     // Date range filter
// //                     if (startDate != null && endDate != null) {
// //                       ref = ref
// //                           .where(
// //                         'created_date',
// //                         isGreaterThanOrEqualTo: Timestamp.fromDate(
// //                           DateTime(
// //                             startDate!.year,
// //                             startDate!.month,
// //                             startDate!.day,
// //                             0,
// //                             0,
// //                             0,
// //                           ),
// //                         ),
// //                       )
// //                           .where(
// //                         'created_date',
// //                         isLessThanOrEqualTo: Timestamp.fromDate(
// //                           DateTime(
// //                             endDate!.year,
// //                             endDate!.month,
// //                             endDate!.day,
// //                             23,
// //                             59,
// //                             59,
// //                             999,
// //                           ),
// //                         ),
// //                       );
// //                     } else {
// //                       // Default: All from today and past
// //                       ref = ref.where(
// //                         'created_date',
// //                         isLessThanOrEqualTo: Timestamp.fromDate(
// //                           DateTime.now().copyWith(
// //                             hour: 23,
// //                             minute: 59,
// //                             second: 59,
// //                             millisecond: 999,
// //                           ),
// //                         ),
// //                       );
// //                     }
// //
// //                     return ref
// //                         .orderBy('created_date', descending: true)
// //                         .snapshots();
// //                   })(),
// //                   builder: (context, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return const Center(child: CircularProgressIndicator());
// //                     }
// //
// //                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //                       return const Center(child: Text('No bills or quotations found'));
// //                     }
// //
// //                     final allData = snapshot.data!.docs.map((doc) {
// //                       final data = doc.data() as Map<String, dynamic>;
// //                       data['id'] = doc.id;
// //                       return data;
// //                     }).toList();
// //
// //                     // Apply filters
// //                     final filtered = allData.where((item) {
// //                       final statusMatch = selectedStatus == 'All' ||
// //                           item['status'] == selectedStatus;
// //
// //                       final typeMatch = selectedFilter == 'All' ||
// //                           item['type'] == selectedFilter;
// //
// //                       // Search filter
// //                       final customerName = (item['customer_name'] ?? '').toString().toLowerCase();
// //                       final billNumber = (item['bill_number'] ?? '').toString().toLowerCase();
// //                       final quotationNumber = (item['quotation_number'] ?? '').toString().toLowerCase();
// //
// //                       final matchesSearch = searchText.isEmpty ||
// //                           customerName.contains(searchText) ||
// //                           billNumber.contains(searchText) ||
// //                           quotationNumber.contains(searchText);
// //
// //                       // Employee filter
// //                       final matchesEmployee = selectedEmployee == null ||
// //                           item['created_by'] == selectedEmployee;
// //
// //                       return statusMatch && typeMatch && matchesSearch && matchesEmployee;
// //                     }).toList();
// //
// //                     if (filtered.isEmpty) {
// //                       return const Center(child: Text('No matching records found'));
// //                     }
// //
// //                     return ListView.builder(
// //                       padding: const EdgeInsets.all(16),
// //                       itemCount: filtered.length,
// //                       itemBuilder: (context, index) {
// //                         final item = filtered[index];
// //                         return InkWell(
// //                           onTap: () {
// //                             // Navigate to details page
// //                             // Get.toNamed(
// //                             //   Routes.BillQuotationListPage, // You'll need to define this route
// //                             //   arguments: item,
// //                             // );
// //                           },
// //                           child: _buildBillQuotationItem(data: item),
// //                         );
// //                       },
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return Container(
// //       height: 220,
// //       decoration: const BoxDecoration(
// //         color: AppColors.themeBlue,
// //         borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
// //       ),
// //       child: Column(
// //         children: [
// //           const SizedBox(height: 15),
// //
// //           // Top bar with back button and title
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 InkWell(
// //                   onTap: () => Get.back(),
// //                   child: const Icon(Icons.arrow_back, color: Colors.white),
// //                 ),
// //                 Text('Bills & Quotations', style: AppTextStyles.appBarWhite21bold),
// //
// //                 // Date filter button
// //                 GestureDetector(
// //                   onTap: () {
// //                     if (isDateSelected) {
// //                       // Clear date selection
// //                       setState(() {
// //                         isDateSelected = false;
// //                         startDate = null;
// //                         endDate = null;
// //                       });
// //                     } else {
// //                       showCustomDateRangePicker(
// //                         context,
// //                         dismissible: true,
// //                         minimumDate: DateTime(2022),
// //                         maximumDate: DateTime.now(),
// //                         endDate: endDate,
// //                         startDate: startDate,
// //                         backgroundColor: Colors.white,
// //                         primaryColor: AppColors.appColor,
// //                         onApplyClick: (start, end) {
// //                           setState(() {
// //                             startDate = start;
// //                             endDate = end;
// //                             isDateSelected = true;
// //                           });
// //                         },
// //                         onCancelClick: () {
// //                           setState(() {
// //                             startDate = null;
// //                             endDate = null;
// //                             isDateSelected = false;
// //                           });
// //                         },
// //                       );
// //                     }
// //                   },
// //                   child: Container(
// //                     padding: const EdgeInsets.all(5),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(5),
// //                     ),
// //                     child: Icon(
// //                       isDateSelected ? Icons.close : Icons.calendar_today,
// //                       size: 18,
// //                       color: isDateSelected ? Colors.red : AppColors.appColor,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           const SizedBox(height: 30),
// //
// //           // Search and Employee filter row
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //             child: Row(
// //               children: [
// //                 // Search field
// //                 Expanded(
// //                   child: SizedBox(
// //                     height: 50,
// //                     child: TextField(
// //                       controller: searchController,
// //                       onChanged: (value) {
// //                         setState(() {
// //                           searchText = value.trim().toLowerCase();
// //                         });
// //                       },
// //                       cursorColor: Colors.white,
// //                       style: const TextStyle(color: Colors.white),
// //                       decoration: InputDecoration(
// //                         suffixIcon: searchText.isNotEmpty
// //                             ? IconButton(
// //                           icon: Icon(
// //                             Icons.close,
// //                             size: 20,
// //                             color: AppColors.themeRed,
// //                           ),
// //                           onPressed: () {
// //                             setState(() {
// //                               searchText = "";
// //                               searchController.clear();
// //                             });
// //                           },
// //                         )
// //                             : IconButton(
// //                           icon: Icon(
// //                             Icons.search,
// //                             size: 20,
// //                             color: AppColors.white,
// //                           ),
// //                           onPressed: () {},
// //                         ),
// //                         hintText: 'Search customer, bill#, quote#',
// //                         hintStyle: const TextStyle(color: Colors.white),
// //                         filled: true,
// //                         fillColor: Colors.white24,
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //
// //                 const SizedBox(width: 10),
// //
// //                 // Employee dropdown
// //                 Expanded(
// //                   child: SizedBox(
// //                     height: 50,
// //                     child: DropdownButtonFormField<String>(
// //                       value: selectedEmployee,
// //                       isExpanded: true,
// //                       items: employeeList.map((emp) {
// //                         final uid = emp['uid']?.toString() ?? '';
// //                         final name = emp['name']?.toString() ?? '';
// //                         return DropdownMenuItem<String>(
// //                           value: uid,
// //                           child: Text(
// //                             name,
// //                             style: const TextStyle(color: Colors.white),
// //                           ),
// //                         );
// //                       }).toList(),
// //                       onChanged: (value) {
// //                         setState(() {
// //                           selectedEmployee = value;
// //                         });
// //                       },
// //                       hint: const Text(
// //                         'Select Employee',
// //                         style: TextStyle(color: Colors.white),
// //                       ),
// //                       decoration: InputDecoration(
// //                         filled: true,
// //                         fillColor: Colors.white24,
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                       ),
// //                       isDense: true,
// //                       icon: GestureDetector(
// //                         onTap: () {
// //                           if (selectedEmployee != null && selectedEmployee!.isNotEmpty) {
// //                             setState(() {
// //                               selectedEmployee = null;
// //                             });
// //                           }
// //                         },
// //                         child: Icon(
// //                           selectedEmployee != null && selectedEmployee!.isNotEmpty
// //                               ? Icons.close
// //                               : Icons.arrow_drop_down_sharp,
// //                           color: selectedEmployee != null && selectedEmployee!.isNotEmpty
// //                               ? Colors.red
// //                               : Colors.white,
// //                         ),
// //                       ),
// //                       dropdownColor: Colors.blue,
// //                       style: const TextStyle(color: Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           const SizedBox(height: 25),
// //
// //           // Type filter chips (Bill/Quotation)
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             child: SingleChildScrollView(
// //               scrollDirection: Axis.horizontal,
// //               child: Row(
// //                 children: [
// //                   _buildFilterChip('All', selectedFilter == 'All'),
// //                   const SizedBox(width: 12),
// //                   _buildFilterChip('Bill', selectedFilter == 'Bill'),
// //                   const SizedBox(width: 12),
// //                   _buildFilterChip('Quotation', selectedFilter == 'Quotation'),
// //                   const SizedBox(width: 12),
// //                   _buildFilterChip('Invoice', selectedFilter == 'Invoice'),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFilterChip(String text, bool isSelected) {
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           selectedFilter = text;
// //         });
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
// //         decoration: BoxDecoration(
// //           color: isSelected ? Colors.white : Colors.white12,
// //           borderRadius: BorderRadius.circular(20),
// //           border: Border.all(
// //             color: isSelected ? Colors.white : Colors.transparent,
// //           ),
// //         ),
// //         child: Text(
// //           text,
// //           style: TextStyle(
// //             color: isSelected ? const Color(0xFF4A90A4) : Colors.white,
// //             fontSize: 14,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBillQuotationItem({required Map<String, dynamic> data}) {
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       elevation: 2,
// //       child: Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(12),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 // Customer name and document number
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         data["customer_name"] ?? 'N/A',
// //                         style: TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w600,
// //                           color: AppColors.appColor,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Text(
// //                         data['type'] == 'Bill'
// //                             ? 'Bill #: ${data["bill_number"] ?? "N/A"}'
// //                             : data['type'] == 'Quotation'
// //                             ? 'Quote #: ${data["quotation_number"] ?? "N/A"}'
// //                             : 'Invoice #: ${data["invoice_number"] ?? "N/A"}',
// //                         style: const TextStyle(
// //                           fontSize: 14,
// //                           color: Colors.grey,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 // Type and status tags
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.end,
// //                   children: [
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 12,
// //                         vertical: 6,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: _getTypeColor(data["type"] ?? ''),
// //                         borderRadius: BorderRadius.circular(4),
// //                       ),
// //                       child: Text(
// //                         data["type"] ?? '',
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 6),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 12,
// //                         vertical: 4,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: _getStatusColor(data["status"] ?? ''),
// //                         borderRadius: BorderRadius.circular(4),
// //                       ),
// //                       child: Text(
// //                         data["status"] ?? '',
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 11,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //
// //             const SizedBox(height: 12),
// //
// //             // Amount and date row
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       'Amount',
// //                       style: TextStyle(
// //                         fontSize: 12,
// //                         color: Colors.grey[600],
// //                       ),
// //                     ),
// //                     Text(
// //                       '₹${data["amount"] ?? "0"}',
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.green,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.end,
// //                   children: [
// //                     Text(
// //                       'Date',
// //                       style: TextStyle(
// //                         fontSize: 12,
// //                         color: Colors.grey[600],
// //                       ),
// //                     ),
// //                     Text(
// //                       data["created_date"] != null
// //                           ? DateFormat('dd/MM/yyyy').format(
// //                           (data["created_date"] as Timestamp).toDate())
// //                           : 'N/A',
// //                       style: const TextStyle(
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //
// //             // Due date for bills (if applicable)
// //             if (data['type'] == 'Bill' && data['due_date'] != null) ...[
// //               const SizedBox(height: 8),
// //               Text(
// //                 'Due Date: ${DateFormat('dd/MM/yyyy').format((data["due_date"] as Timestamp).toDate())}',
// //                 style: TextStyle(
// //                   fontSize: 12,
// //                   color: _isDueDateOverdue(data['due_date']) ? Colors.red : Colors.grey[600],
// //                   fontWeight: _isDueDateOverdue(data['due_date']) ? FontWeight.bold : FontWeight.normal,
// //                 ),
// //               ),
// //             ],
// //
// //             // Description/Items (if available)
// //             if (data['description'] != null && data['description'].toString().isNotEmpty) ...[
// //               const SizedBox(height: 8),
// //               Text(
// //                 'Description: ${data["description"]}',
// //                 style: const TextStyle(
// //                   fontSize: 13,
// //                   color: Colors.black87,
// //                 ),
// //                 maxLines: 2,
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //             ],
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   bool _isDueDateOverdue(dynamic dueDateField) {
// //     if (dueDateField == null) return false;
// //     final dueDate = (dueDateField as Timestamp).toDate();
// //     return dueDate.isBefore(DateTime.now());
// //   }
// //
// //   Color _getTypeColor(String type) {
// //     switch (type) {
// //       case 'Bill':
// //         return const Color(0xFF4CAF50); // Green
// //       case 'Quotation':
// //         return const Color(0xFF2196F3); // Blue
// //       case 'Invoice':
// //         return const Color(0xFF9C27B0); // Purple
// //       default:
// //         return const Color(0xFF757575); // Grey
// //     }
// //   }
// //
// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'Paid':
// //         return const Color(0xFF4CAF50); // Green
// //       case 'Pending':
// //         return const Color(0xFFFF9800); // Orange
// //       case 'Overdue':
// //         return const Color(0xFFf44336); // Red
// //       case 'Cancelled':
// //         return const Color(0xFF9E9E9E); // Grey
// //       default:
// //         return const Color(0xFF757575);
// //     }
// //   }
// // }
// import 'package:custom_date_range_picker/custom_date_range_picker.dart';
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:relie_nquiry/constants/app_constants.dart';
// import 'package:relie_nquiry/routes/app_routes.dart';
// import '../constants/app_colors.dart';
// import '../constants/app_text_styles.dart';
//
// class AdminBillsQuotationsPage extends StatefulWidget {
//   const AdminBillsQuotationsPage({super.key});
//
//   @override
//   State<AdminBillsQuotationsPage> createState() => _AdminBillsQuotationsPageState();
// }
//
// class _AdminBillsQuotationsPageState extends State<AdminBillsQuotationsPage> {
//   String selectedFilter = 'All';
//   String selectedStatus = 'Pending';
//   final List<String> statuses = ['Pending', 'Paid', 'Overdue', 'Cancelled'];
//
//   // Date filter variables
//   DateTime? startDate;
//   DateTime? endDate;
//   bool isDateSelected = false;
//
//   // Search variables
//   final TextEditingController searchController = TextEditingController();
//   String searchText = "";
//
//   // Employee filter variables
//   String? selectedEmployee;
//   List<Map<String, dynamic>> employeeList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEmployees();
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   void fetchEmployees() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('subscription')
//         .doc(AppConstants.companyName)
//         .collection('users')
//         .where('role', whereIn: ['Employee', 'Admin', "Super Admin"])
//         .get();
//
//     final List<Map<String, dynamic>> employees = snapshot.docs.map((doc) {
//       final data = doc.data();
//       return {'uid': data['uid'], 'name': data['name'] ?? ''};
//     }).toList();
//
//     setState(() {
//       employeeList = employees;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           width: AppConstants.screenWidth(context),
//           color: Colors.white,
//           height: AppConstants.screenHeight(context),
//           child: Column(
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 10),
//
//               // Status filter chips
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: statuses.map((status) {
//                     final bool isSelected = selectedStatus == status;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedStatus = status;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.black : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           status,
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//
//               // Bills & Quotations List
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: (() {
//                     Query<Map<String, dynamic>> ref = FirebaseFirestore.instance
//                         .collection('subscription')
//                         .doc(AppConstants.companyName)
//                         .collection('Bill&Quotation'); // Changed collection name
//
//                     // Date range filter
//                     if (startDate != null && endDate != null) {
//                       ref = ref
//                           .where(
//                         'created_date',
//                         isGreaterThanOrEqualTo: Timestamp.fromDate(
//                           DateTime(
//                             startDate!.year,
//                             startDate!.month,
//                             startDate!.day,
//                             0,
//                             0,
//                             0,
//                           ),
//                         ),
//                       )
//                           .where(
//                         'created_date',
//                         isLessThanOrEqualTo: Timestamp.fromDate(
//                           DateTime(
//                             endDate!.year,
//                             endDate!.month,
//                             endDate!.day,
//                             23,
//                             59,
//                             59,
//                             999,
//                           ),
//                         ),
//                       );
//                     } else {
//                       // Default: All from today and past
//                       ref = ref.where(
//                         'created_date',
//                         isLessThanOrEqualTo: Timestamp.fromDate(
//                           DateTime.now().copyWith(
//                             hour: 23,
//                             minute: 59,
//                             second: 59,
//                             millisecond: 999,
//                           ),
//                         ),
//                       );
//                     }
//
//                     return ref
//                         .orderBy('created_date', descending: true)
//                         .snapshots();
//                   })(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Center(child: Text('No bills or quotations found'));
//                     }
//
//                     final allData = snapshot.data!.docs.map((doc) {
//                       final data = doc.data() as Map<String, dynamic>;
//                       data['id'] = doc.id;
//                       return data;
//                     }).toList();
//
//                     // Apply filters
//                     final filtered = allData.where((item) {
//                       final statusMatch = selectedStatus == 'All' ||
//                           item['status'] == selectedStatus;
//
//                       final typeMatch = selectedFilter == 'All' ||
//                           item['type'] == selectedFilter;
//
//                       // Search filter
//                       final customerName = (item['customer_name'] ?? '').toString().toLowerCase();
//                       final billNumber = (item['bill_number'] ?? '').toString().toLowerCase();
//                       final quotationNumber = (item['quotation_number'] ?? '').toString().toLowerCase();
//
//                       final matchesSearch = searchText.isEmpty ||
//                           customerName.contains(searchText) ||
//                           billNumber.contains(searchText) ||
//                           quotationNumber.contains(searchText);
//
//                       // Employee filter
//                       final matchesEmployee = selectedEmployee == null ||
//                           item['created_by'] == selectedEmployee;
//
//                       return statusMatch && typeMatch && matchesSearch && matchesEmployee;
//                     }).toList();
//
//                     if (filtered.isEmpty) {
//                       return const Center(child: Text('No matching records found'));
//                     }
//
//                     return ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: filtered.length,
//                       itemBuilder: (context, index) {
//                         final item = filtered[index];
//                         return InkWell(
//                           onTap: () {
//                             // Navigate to details page
//                             Get.toNamed(
//                               Routes.pdfPage, // You'll need to define this route
//                               arguments: item,
//                             );
//                           },
//                           child: _buildBillQuotationItem(data: item),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       height: 220,
//       decoration: const BoxDecoration(
//         color: AppColors.themeBlue,
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 15),
//
//           // Top bar with back button and title
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: () => Get.back(),
//                   child: const Icon(Icons.arrow_back, color: Colors.white),
//                 ),
//                 Text('Bills & Quotations', style: AppTextStyles.appBarWhite21bold),
//
//                 // Date filter button
//                 GestureDetector(
//                   onTap: () {
//                     if (isDateSelected) {
//                       // Clear date selection
//                       setState(() {
//                         isDateSelected = false;
//                         startDate = null;
//                         endDate = null;
//                       });
//                     } else {
//                       showCustomDateRangePicker(
//                         context,
//                         dismissible: true,
//                         minimumDate: DateTime(2022),
//                         maximumDate: DateTime.now(),
//                         endDate: endDate,
//                         startDate: startDate,
//                         backgroundColor: Colors.white,
//                         primaryColor: AppColors.appColor,
//                         onApplyClick: (start, end) {
//                           setState(() {
//                             startDate = start;
//                             endDate = end;
//                             isDateSelected = true;
//                           });
//                         },
//                         onCancelClick: () {
//                           setState(() {
//                             startDate = null;
//                             endDate = null;
//                             isDateSelected = false;
//                           });
//                         },
//                       );
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Icon(
//                       isDateSelected ? Icons.close : Icons.calendar_today,
//                       size: 18,
//                       color: isDateSelected ? Colors.red : AppColors.appColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 30),
//
//           // Search and Employee filter row
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 // Search field
//                 Expanded(
//                   child: SizedBox(
//                     height: 50,
//                     child: TextField(
//                       controller: searchController,
//                       onChanged: (value) {
//                         setState(() {
//                           searchText = value.trim().toLowerCase();
//                         });
//                       },
//                       cursorColor: Colors.white,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         suffixIcon: searchText.isNotEmpty
//                             ? IconButton(
//                           icon: Icon(
//                             Icons.close,
//                             size: 20,
//                             color: AppColors.themeRed,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               searchText = "";
//                               searchController.clear();
//                             });
//                           },
//                         )
//                             : IconButton(
//                           icon: Icon(
//                             Icons.search,
//                             size: 20,
//                             color: AppColors.white,
//                           ),
//                           onPressed: () {},
//                         ),
//                         hintText: 'Search customer, bill#, quote#',
//                         hintStyle: const TextStyle(color: Colors.white),
//                         filled: true,
//                         fillColor: Colors.white24,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 10),
//
//                 // Employee dropdown
//                 Expanded(
//                   child: SizedBox(
//                     height: 50,
//                     child: DropdownButtonFormField<String>(
//                       value: selectedEmployee,
//                       isExpanded: true,
//                       items: employeeList.map((emp) {
//                         final uid = emp['uid']?.toString() ?? '';
//                         final name = emp['name']?.toString() ?? '';
//                         return DropdownMenuItem<String>(
//                           value: uid,
//                           child: Text(
//                             name,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedEmployee = value;
//                         });
//                       },
//                       hint: const Text(
//                         'Select Employee',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white24,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       isDense: true,
//                       icon: GestureDetector(
//                         onTap: () {
//                           if (selectedEmployee != null && selectedEmployee!.isNotEmpty) {
//                             setState(() {
//                               selectedEmployee = null;
//                             });
//                           }
//                         },
//                         child: Icon(
//                           selectedEmployee != null && selectedEmployee!.isNotEmpty
//                               ? Icons.close
//                               : Icons.arrow_drop_down_sharp,
//                           color: selectedEmployee != null && selectedEmployee!.isNotEmpty
//                               ? Colors.red
//                               : Colors.white,
//                         ),
//                       ),
//                       dropdownColor: Colors.blue,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 25),
//
//           // Type filter chips (Bill/Quotation)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildFilterChip('All', selectedFilter == 'All'),
//                   const SizedBox(width: 12),
//                   _buildFilterChip('Bill', selectedFilter == 'Bill'),
//                   const SizedBox(width: 12),
//                   _buildFilterChip('Quotation', selectedFilter == 'Quotation'),
//                   const SizedBox(width: 12),
//                   _buildFilterChip('Invoice', selectedFilter == 'Invoice'),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterChip(String text, bool isSelected) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedFilter = text;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.white12,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? Colors.white : Colors.transparent,
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? const Color(0xFF4A90A4) : Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBillQuotationItem({required Map<String, dynamic> data}) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Customer name and document number
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         data["customer_name"] ?? 'N/A',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.appColor,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         data['type'] == 'Bill'
//                             ? 'Bill #: ${data["bill_number"] ?? "N/A"}'
//                             : data['type'] == 'Quotation'
//                             ? 'Quote #: ${data["quotation_number"] ?? "N/A"}'
//                             : 'Invoice #: ${data["invoice_number"] ?? "N/A"}',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Type and status tags
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _getTypeColor(data["type"] ?? ''),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         data["type"] ?? '',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _getStatusColor(data["status"] ?? ''),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         data["status"] ?? '',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 12),
//
//             // Amount and date row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Amount',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     Text(
//                       '₹${data["amount"] ?? "0"}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       'Date',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     Text(
//                       data["created_date"] != null
//                           ? DateFormat('dd/MM/yyyy').format(
//                           (data["created_date"] as Timestamp).toDate())
//                           : 'N/A',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             // Due date for bills (if applicable)
//             if (data['type'] == 'Bill' && data['due_date'] != null) ...[
//               const SizedBox(height: 8),
//               Text(
//                 'Due Date: ${DateFormat('dd/MM/yyyy').format((data["due_date"] as Timestamp).toDate())}',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: _isDueDateOverdue(data['due_date']) ? Colors.red : Colors.grey[600],
//                   fontWeight: _isDueDateOverdue(data['due_date']) ? FontWeight.bold : FontWeight.normal,
//                 ),
//               ),
//             ],
//
//             // Description/Items (if available)
//             if (data['description'] != null && data['description'].toString().isNotEmpty) ...[
//               const SizedBox(height: 8),
//               Text(
//                 'Description: ${data["description"]}',
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: Colors.black87,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   bool _isDueDateOverdue(dynamic dueDateField) {
//     if (dueDateField == null) return false;
//     final dueDate = (dueDateField as Timestamp).toDate();
//     return dueDate.isBefore(DateTime.now());
//   }
//
//   Color _getTypeColor(String type) {
//     switch (type) {
//       case 'Bill':
//         return const Color(0xFF4CAF50); // Green
//       case 'Quotation':
//         return const Color(0xFF2196F3); // Blue
//       case 'Invoice':
//         return const Color(0xFF9C27B0); // Purple
//       default:
//         return const Color(0xFF757575); // Grey
//     }
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Paid':
//         return const Color(0xFF4CAF50); // Green
//       case 'Pending':
//         return const Color(0xFFFF9800); // Orange
//       case 'Overdue':
//         return const Color(0xFFf44336); // Red
//       case 'Cancelled':
//         return const Color(0xFF9E9E9E); // Grey
//       default:
//         return const Color(0xFF757575);
//     }
//   }
// }
//
// import 'package:custom_date_range_picker/custom_date_range_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:relie_nquiry/constants/app_constants.dart';
// import 'package:relie_nquiry/routes/app_routes.dart';
// import '../constants/app_colors.dart';
// import '../constants/app_text_styles.dart';
//
// class AdminBillsQuotationsPage extends StatefulWidget {
//   const AdminBillsQuotationsPage({super.key});
//
//   @override
//   State<AdminBillsQuotationsPage> createState() => _AdminBillsQuotationsPageState();
// }
//
// class _AdminBillsQuotationsPageState extends State<AdminBillsQuotationsPage> {
//   String selectedFilter = 'All';
//   String selectedStatus = 'Pending';
//   final List<String> statuses = ['Pending', 'Paid', 'Overdue', 'Cancelled'];
//
//   // Date filter variables
//   DateTime? startDate;
//   DateTime? endDate;
//   bool isDateSelected = false;
//
//   // Search variables
//   final TextEditingController searchController = TextEditingController();
//   String searchText = "";
//
//   // Employee filter variables
//   String? selectedEmployee;
//   List<Map<String, dynamic>> employeeList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEmployees();
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   void fetchEmployees() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('subscription')
//         .doc(AppConstants.companyName)
//         .collection('users')
//         .where('role', whereIn: ['Employee', 'Admin', "Super Admin"])
//         .get();
//
//     final List<Map<String, dynamic>> employees = snapshot.docs.map((doc) {
//       final data = doc.data();
//       return {'uid': data['uid'], 'name': data['name'] ?? ''};
//     }).toList();
//
//     setState(() {
//       employeeList = employees;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           width: AppConstants.screenWidth(context),
//           color: Colors.white,
//           height: AppConstants.screenHeight(context),
//           child: Column(
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 10),
//
//               // Status filter chips
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: statuses.map((status) {
//                     final bool isSelected = selectedStatus == status;
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedStatus = status;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.black : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           status,
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//
//               // Bills & Quotations List
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: (() {
//                     Query<Map<String, dynamic>> ref = FirebaseFirestore.instance
//                         .collection('subscription')
//                         .doc(AppConstants.companyName)
//                         .collection('Bill&Quotation'); // Changed collection name
//
//
//                     if (startDate != null && endDate != null) {
//                       ref = ref
//                           .where(
//                         'created_date',
//                         isGreaterThanOrEqualTo: Timestamp.fromDate(
//                           DateTime(
//                             startDate!.year,
//                             startDate!.month,
//                             startDate!.day,
//                             0,
//                             0,
//                             0,
//                           ),
//                         ),
//                       )
//                           .where(
//                         'created_date',
//                         isLessThanOrEqualTo: Timestamp.fromDate(
//                           DateTime(
//                             endDate!.year,
//                             endDate!.month,
//                             endDate!.day,
//                             23,
//                             59,
//                             59,
//                             999,
//                           ),
//                         ),
//                       );
//                     } else {
//                       // Default: All from today and past
//                       ref = ref.where(
//                         'created_date',
//                         isLessThanOrEqualTo: Timestamp.fromDate(
//                           DateTime.now().copyWith(
//                             hour: 00,
//                             minute: 00,
//                             second: 00,
//                             millisecond: 00,
//                           ),
//                         ),
//                       );
//                     }
//
//                     return ref
//                         .orderBy('created_date', descending: true)
//                         .snapshots();
//                   })(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Center(child: Text('No bills or quotations found'));
//                     }
//
//                     final allData = snapshot.data!.docs.map((doc) {
//                       final data = doc.data() as Map<String, dynamic>;
//                       data['id'] = doc.id;
//                       return data;
//                     }).toList();
//
//                     // Apply filters
//                     final filtered = allData.where((item) {
//                       final statusMatch = selectedStatus == 'All' ||
//                           item['status'] == selectedStatus;
//
//                       final typeMatch = selectedFilter == 'All' ||
//                           item['type'] == selectedFilter;
//
//                       // Search filter
//                       final customerName = (item['customer_name'] ?? '').toString().toLowerCase();
//                       final billNumber = (item['bill_number'] ?? '').toString().toLowerCase();
//                       final quotationNumber = (item['quotation_number'] ?? '').toString().toLowerCase();
//
//                       final matchesSearch = searchText.isEmpty ||
//                           customerName.contains(searchText) ||
//                           billNumber.contains(searchText) ||
//                           quotationNumber.contains(searchText);
//
//                       // Employee filter
//                       final matchesEmployee = selectedEmployee == null ||
//                           item['created_by'] == selectedEmployee;
//
//                       return statusMatch && typeMatch && matchesSearch && matchesEmployee;
//                     }).toList();
//
//                     if (filtered.isEmpty) {
//                       return const Center(child: Text('No matching records found'));
//                     }
//
//                     return ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: filtered.length,
//                       itemBuilder: (context, index) {
//                         final item = filtered[index];
//                         return InkWell(
//                           onTap: () {
//                             // Navigate to details page
//                             Get.toNamed(
//                               Routes.pdfPage, // You'll need to define this route
//                               arguments: item,
//                             );
//                           },
//                           child: _buildBillQuotationItem(data: item),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       height: 220,
//       decoration: const BoxDecoration(
//         color: AppColors.themeBlue,
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 15),
//
//           // Top bar with back button and title
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: () => Get.back(),
//                   child: const Icon(Icons.arrow_back, color: Colors.white),
//                 ),
//                 Text('Bills & Quotations', style: AppTextStyles.appBarWhite21bold),
//
//                 // Date filter button
//                 GestureDetector(
//                   onTap: () {
//                     if (isDateSelected) {
//                       // Clear date selection
//                       setState(() {
//                         isDateSelected = false;
//                         startDate = null;
//                         endDate = null;
//                       });
//                     } else {
//                       showCustomDateRangePicker(
//                         context,
//                         dismissible: true,
//                         minimumDate: DateTime(2022),
//                         maximumDate: DateTime.now(),
//                         endDate: endDate,
//                         startDate: startDate,
//                         backgroundColor: Colors.white,
//                         primaryColor: AppColors.appColor,
//                         onApplyClick: (start, end) {
//                           setState(() {
//                             startDate = start;
//                             endDate = end;
//                             isDateSelected = true;
//                           });
//                         },
//                         onCancelClick: () {
//                           setState(() {
//                             startDate = null;
//                             endDate = null;
//                             isDateSelected = false;
//                           });
//                         },
//                       );
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Icon(
//                       isDateSelected ? Icons.close : Icons.calendar_today,
//                       size: 18,
//                       color: isDateSelected ? Colors.red : AppColors.appColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 30),
//
//           // Search and Employee filter row
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 // Search field
//                 Expanded(
//                   child: SizedBox(
//                     height: 50,
//                     child: TextField(
//                       controller: searchController,
//                       onChanged: (value) {
//                         setState(() {
//                           searchText = value.trim().toLowerCase();
//                         });
//                       },
//                       cursorColor: Colors.white,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         suffixIcon: searchText.isNotEmpty
//                             ? IconButton(
//                           icon: Icon(
//                             Icons.close,
//                             size: 20,
//                             color: AppColors.themeRed,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               searchText = "";
//                               searchController.clear();
//                             });
//                           },
//                         )
//                             : IconButton(
//                           icon: Icon(
//                             Icons.search,
//                             size: 20,
//                             color: AppColors.white,
//                           ),
//                           onPressed: () {},
//                         ),
//                         hintText: 'Search customer, bill#, quote#',
//                         hintStyle: const TextStyle(color: Colors.white),
//                         filled: true,
//                         fillColor: Colors.white24,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 10),
//
//                 // Employee dropdown
//                 Expanded(
//                   child: SizedBox(
//                     height: 50,
//                     child: DropdownButtonFormField<String>(
//                       value: selectedEmployee,
//                       isExpanded: true,
//                       items: employeeList.map((emp) {
//                         final uid = emp['uid']?.toString() ?? '';
//                         final name = emp['name']?.toString() ?? '';
//                         return DropdownMenuItem<String>(
//                           value: uid,
//                           child: Text(
//                             name,
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedEmployee = value;
//                         });
//                       },
//                       hint: const Text(
//                         'Select Employee',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white24,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       isDense: true,
//                       icon: GestureDetector(
//                         onTap: () {
//                           if (selectedEmployee != null && selectedEmployee!.isNotEmpty) {
//                             setState(() {
//                               selectedEmployee = null;
//                             });
//                           }
//                         },
//                         child: Icon(
//                           selectedEmployee != null && selectedEmployee!.isNotEmpty
//                               ? Icons.close
//                               : Icons.arrow_drop_down_sharp,
//                           color: selectedEmployee != null && selectedEmployee!.isNotEmpty
//                               ? Colors.red
//                               : Colors.white,
//                         ),
//                       ),
//                       dropdownColor: Colors.blue,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 25),
//
//           // Type filter chips (Bill/Quotation)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildFilterChip('All', selectedFilter == 'All'),
//                   const SizedBox(width: 12),
//                   _buildFilterChip('Bill', selectedFilter == 'Bill'),
//                   const SizedBox(width: 12),
//                   _buildFilterChip('Quotation', selectedFilter == 'Quotation'),
//                   const SizedBox(width: 12),
//                   _buildFilterChip('Invoice', selectedFilter == 'Invoice'),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterChip(String text, bool isSelected) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedFilter = text;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.white12,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? Colors.white : Colors.transparent,
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? const Color(0xFF4A90A4) : Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBillQuotationItem({required Map<String, dynamic> data}) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Customer name and document number
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         data["customer_name"] ?? 'N/A',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.appColor,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         data['type'] == 'Bill'
//                             ? 'Bill #: ${data["bill_number"] ?? "N/A"}'
//                             : data['type'] == 'Quotation'
//                             ? 'Quote #: ${data["quotation_number"] ?? "N/A"}'
//                             : 'Invoice #: ${data["invoice_number"] ?? "N/A"}',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Type and status tags
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _getTypeColor(data["type"] ?? ''),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         data["type"] ?? '',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _getStatusColor(data["status"] ?? ''),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         data["status"] ?? '',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 12),
//
//             // Amount and date row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Amount',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     Text(
//                       '₹${data["amount"] ?? "0"}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       'Date',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     Text(
//                       data["created_date"] != null
//                           ? DateFormat('dd/MM/yyyy').format(
//                           (data["created_date"] as Timestamp).toDate())
//                           : 'N/A',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             // Due date for bills (if applicable)
//             if (data['type'] == 'Bill' && data['due_date'] != null) ...[
//               const SizedBox(height: 8),
//               Text(
//                 'Due Date: ${DateFormat('dd/MM/yyyy').format((data["due_date"] as Timestamp).toDate())}',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: _isDueDateOverdue(data['due_date']) ? Colors.red : Colors.grey[600],
//                   fontWeight: _isDueDateOverdue(data['due_date']) ? FontWeight.bold : FontWeight.normal,
//                 ),
//               ),
//             ],
//
//             // Description/Items (if available)
//             if (data['description'] != null && data['description'].toString().isNotEmpty) ...[
//               const SizedBox(height: 8),
//               Text(
//                 'Description: ${data["description"]}',
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: Colors.black87,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   bool _isDueDateOverdue(dynamic dueDateField) {
//     if (dueDateField == null) return false;
//     final dueDate = (dueDateField as Timestamp).toDate();
//     return dueDate.isBefore(DateTime.now());
//   }
//
//   Color _getTypeColor(String type) {
//     switch (type) {
//       case 'Bill':
//         return const Color(0xFF4CAF50); // Green
//       case 'Quotation':
//         return const Color(0xFF2196F3); // Blue
//       case 'Invoice':
//         return const Color(0xFF9C27B0); // Purple
//       default:
//         return const Color(0xFF757575); // Grey
//     }
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Paid':
//         return const Color(0xFF4CAF50); // Green
//       case 'Pending':
//         return const Color(0xFFFF9800); // Orange
//       case 'Overdue':
//         return const Color(0xFFf44336); // Red
//       case 'Cancelled':
//         return const Color(0xFF9E9E9E); // Grey
//       default:
//         return const Color(0xFF757575);
//     }
//   }
// }
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:relie_nquiry/routes/app_routes.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AdminBillsQuotationsPage extends StatefulWidget {
  const AdminBillsQuotationsPage({super.key});

  @override
  State<AdminBillsQuotationsPage> createState() => _AdminBillsQuotationsPageState();
}

class _AdminBillsQuotationsPageState extends State<AdminBillsQuotationsPage> {
  String selectedFilter = 'All';
  String selectedStatus = 'All'; // Changed from 'Pending' to 'All'
  final List<String> statuses = ['All', 'Pending', 'Paid', 'Overdue', 'Cancelled']; // Added 'All'

  // Date filter variables
  DateTime? startDate;
  DateTime? endDate;
  bool isDateSelected = false;

  // Search variables
  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  // Employee filter variables
  String? selectedEmployee;
  List<Map<String, dynamic>> employeeList = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void fetchEmployees() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('subscription')
          .doc(AppConstants.companyName)
          .collection('users')
          .where('role', whereIn: ['Employee', 'Admin', "Super Admin"])
          .get();

      final List<Map<String, dynamic>> employees = snapshot.docs.map((doc) {
        final data = doc.data();
        return {'uid': data['uid'], 'name': data['name'] ?? ''};
      }).toList();

      setState(() {
        employeeList = employees;
      });
    } catch (e) {
      print('Error fetching employees: $e');
    }
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

              // Status filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: statuses.map((status) {
                      final bool isSelected = selectedStatus == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
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
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Bills & Quotations List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _getBillsQuotationsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      print('Firebase error: ${snapshot.error}');
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text('Error loading data: ${snapshot.error}'),
                            ElevatedButton(
                              onPressed: () => setState(() {}),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No bills or quotations found',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    final allData = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      data['id'] = doc.id;
                      return data;
                    }).toList();

                    print('Total documents fetched: ${allData.length}');

                    // Apply filters
                    final filtered = _applyFilters(allData);

                    print('After filtering: ${filtered.length}');

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No matching records found',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return InkWell(
                          onTap: () {
                            // Navigate to details page
                            Get.toNamed(
                              Routes.pdfPage,
                              arguments: item,
                            );
                          },
                          child: _buildBillQuotationItem(data: item),
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

  // Separate method for building the stream query
  Stream<QuerySnapshot> _getBillsQuotationsStream() {
    try {
      Query<Map<String, dynamic>> ref = FirebaseFirestore.instance
          .collection('subscription')
          .doc(AppConstants.companyName)
          .collection('Bill&Quotation');

      // Date range filter
      if (startDate != null && endDate != null) {
        ref = ref
            .where(
          'created_date',
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
          'created_date',
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
      }
      // REMOVED THE DEFAULT DATE FILTER - NOW SHOWS ALL DATA

      return ref
          .orderBy('created_date', descending: true)
          .snapshots();
    } catch (e) {
      print('Error creating stream: $e');
      return const Stream.empty();
    }
  }

  // Separate method for applying filters
  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> allData) {
    return allData.where((item) {
      // Status filter - now properly handles 'All'
      final statusMatch = selectedStatus == 'All' ||
          (item['status']?.toString().toLowerCase() == selectedStatus.toLowerCase());

      // Type filter
      final typeMatch = selectedFilter == 'All' ||
          (item['type']?.toString().toLowerCase() == selectedFilter.toLowerCase());

      // Search filter
      final customerName = (item['customer_name'] ?? '').toString().toLowerCase();
      final billNumber = (item['bill_number'] ?? '').toString().toLowerCase();
      final quotationNumber = (item['quotation_number'] ?? '').toString().toLowerCase();
      final invoiceNumber = (item['invoice_number'] ?? '').toString().toLowerCase();

      final matchesSearch = searchText.isEmpty ||
          customerName.contains(searchText.toLowerCase()) ||
          billNumber.contains(searchText.toLowerCase()) ||
          quotationNumber.contains(searchText.toLowerCase()) ||
          invoiceNumber.contains(searchText.toLowerCase());

      // Employee filter
      final matchesEmployee = selectedEmployee == null ||
          selectedEmployee!.isEmpty ||
          item['created_by']?.toString() == selectedEmployee;

      return statusMatch && typeMatch && matchesSearch && matchesEmployee;
    }).toList();
  }

  Widget _buildHeader() {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        color: AppColors.themeBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),

          // Top bar with back button and title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Text('Bills & Quotations', style: AppTextStyles.appBarWhite21bold),

                // Date filter button
                GestureDetector(
                  onTap: () {
                    if (isDateSelected) {
                      // Clear date selection
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

          const SizedBox(height: 30),

          // Search and Employee filter row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Search field
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value.trim();
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
                              searchController.clear();
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
                        hintText: 'Search customer, bill#, quote#',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Employee dropdown
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: DropdownButtonFormField<String>(
                      value: selectedEmployee,
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                            'All Employees',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ...employeeList.map((emp) {
                          final uid = emp['uid']?.toString() ?? '';
                          final name = emp['name']?.toString() ?? '';
                          return DropdownMenuItem<String>(
                            value: uid,
                            child: Text(
                              name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedEmployee = value;
                        });
                      },
                      hint: const Text(
                        'Select Employee',
                        style: TextStyle(color: Colors.white70),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      isDense: true,
                      icon: GestureDetector(
                        onTap: () {
                          if (selectedEmployee != null && selectedEmployee!.isNotEmpty) {
                            setState(() {
                              selectedEmployee = null;
                            });
                          }
                        },
                        child: Icon(
                          selectedEmployee != null && selectedEmployee!.isNotEmpty
                              ? Icons.close
                              : Icons.arrow_drop_down_sharp,
                          color: selectedEmployee != null && selectedEmployee!.isNotEmpty
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                      dropdownColor: Colors.blue,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Type filter chips (Bill/Quotation)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', selectedFilter == 'All'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Bill', selectedFilter == 'Bill'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Quotation', selectedFilter == 'Quotation'),
                  const SizedBox(width: 12),
                  _buildFilterChip('Invoice', selectedFilter == 'Invoice'),
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

  Widget _buildBillQuotationItem({required Map<String, dynamic> data}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Customer name and document number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["customer_name"]?.toString() ?? 'N/A',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getDocumentNumberText(data),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Type and status tags
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(data["type"]?.toString() ?? ''),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data["type"]?.toString() ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(data["status"]?.toString() ?? ''),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data["status"]?.toString() ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Amount and date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '₹${data["amount"]?.toString() ?? "0"}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _formatDate(data["created_date"]),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Due date for bills (if applicable)
            if (data['type']?.toString().toLowerCase() == 'bill' && data['due_date'] != null) ...[
              const SizedBox(height: 8),
              Text(
                'Due Date: ${_formatDate(data["due_date"])}',
                style: TextStyle(
                  fontSize: 12,
                  color: _isDueDateOverdue(data['due_date']) ? Colors.red : Colors.grey[600],
                  fontWeight: _isDueDateOverdue(data['due_date']) ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],

            // Description/Items (if available)
            if (data['description'] != null && data['description'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Description: ${data["description"]}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDocumentNumberText(Map<String, dynamic> data) {
    final type = data['type']?.toString().toLowerCase() ?? '';
    switch (type) {
      case 'bill':
        return 'Bill #: ${data["bill_number"]?.toString() ?? "N/A"}';
      case 'quotation':
        return 'Quote #: ${data["quotation_number"]?.toString() ?? "N/A"}';
      case 'invoice':
        return 'Invoice #: ${data["invoice_number"]?.toString() ?? "N/A"}';
      default:
        return 'Document #: N/A';
    }
  }

  String _formatDate(dynamic dateField) {
    if (dateField == null) return 'N/A';
    try {
      if (dateField is Timestamp) {
        return DateFormat('dd/MM/yyyy').format(dateField.toDate());
      } else if (dateField is DateTime) {
        return DateFormat('dd/MM/yyyy').format(dateField);
      } else if (dateField is String) {
        final parsedDate = DateTime.tryParse(dateField);
        if (parsedDate != null) {
          return DateFormat('dd/MM/yyyy').format(parsedDate);
        }
      }
      return 'N/A';
    } catch (e) {
      print('Date formatting error: $e');
      return 'N/A';
    }
  }

  bool _isDueDateOverdue(dynamic dueDateField) {
    if (dueDateField == null) return false;
    try {
      DateTime dueDate;
      if (dueDateField is Timestamp) {
        dueDate = dueDateField.toDate();
      } else if (dueDateField is DateTime) {
        dueDate = dueDateField;
      } else if (dueDateField is String) {
        final parsedDate = DateTime.tryParse(dueDateField);
        if (parsedDate == null) return false;
        dueDate = parsedDate;
      } else {
        return false;
      }
      return dueDate.isBefore(DateTime.now());
    } catch (e) {
      print('Due date check error: $e');
      return false;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'bill':
        return const Color(0xFF4CAF50); // Green
      case 'quotation':
        return const Color(0xFF2196F3); // Blue
      case 'invoice':
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF757575); // Grey
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(0xFF4CAF50); // Green
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      case 'overdue':
        return const Color(0xFFf44336); // Red
      case 'cancelled':
        return const Color(0xFF9E9E9E); // Grey
      default:
        return const Color(0xFF757575);
    }
  }
}