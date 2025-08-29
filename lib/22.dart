// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:relie_nquiry/constants/app_colors.dart';
// import 'package:relie_nquiry/constants/app_text_styles.dart';
// import 'package:relie_nquiry/constants/app_constants.dart';
//
// import 'package:relie_nquiry/pages/Bill_quotation_page.dart';
//
// import 'bill/Quotation.dart'; // Import your main page
//
// class BillQuotationListPage extends StatefulWidget {
//   const BillQuotationListPage({super.key});
//
//   @override
//   State<BillQuotationListPage> createState() => _BillQuotationListPageState();
// }
//
// class _BillQuotationListPageState extends State<BillQuotationListPage> {
//   String _selectedFilter = 'All'; // All, Bill, Quotation
//   String _searchQuery = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Bills & Quotations",
//           style: AppTextStyles.appBarWhite21bold,
//         ),
//         backgroundColor: AppColors.themeBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add, color: Colors.white),
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => BillQuotationPage(),
//                 ),
//               ).then((_) => setState(() {})); // Refresh when coming back
//             },
//             tooltip: "Create New",
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildFilterAndSearchSection(),
//           Expanded(child: _buildDocumentsList()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterAndSearchSection() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Filter buttons
//           Row(
//             children: [
//               _buildFilterChip('All'),
//               SizedBox(width: 8),
//               _buildFilterChip('Bill'),
//               SizedBox(width: 8),
//               _buildFilterChip('Quotation'),
//             ],
//           ),
//           SizedBox(height: 12),
//
//           // Search bar
//           TextField(
//             decoration: InputDecoration(
//               hintText: 'Search by customer name...',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: AppColors.appColor),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//             onChanged: (value) {
//               setState(() {
//                 _searchQuery = value.toLowerCase();
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterChip(String filter) {
//     bool isSelected = _selectedFilter == filter;
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _selectedFilter = filter;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.appColor : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? AppColors.appColor : Colors.grey.shade300,
//           ),
//         ),
//         child: Text(
//           filter,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey.shade700,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDocumentsList() {
//     String? employeeUid = FirebaseAuth.instance.currentUser?.uid;
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('subscription')
//           .doc(AppConstants.companyName)
//           .collection('bill&Quotation')
//           .where('employeeUid', isEqualTo: employeeUid)
//           .orderBy('updatedAt', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               'Error loading documents: ${snapshot.error}',
//               style: TextStyle(color: Colors.red),
//             ),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.receipt_long,
//                   size: 64,
//                   color: Colors.grey.shade400,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'No documents found',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Create your first bill or quotation',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade500,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         // Filter documents
//         List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//           // Filter by document type
//           if (_selectedFilter != 'All' && data['documentType'] != _selectedFilter) {
//             return false;
//           }
//
//           // Filter by search query
//           if (_searchQuery.isNotEmpty) {
//             String customerName = (data['customerName'] ?? '').toString().toLowerCase();
//             if (!customerName.contains(_searchQuery)) {
//               return false;
//             }
//           }
//
//           return true;
//         }).toList();
//
//         if (filteredDocs.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.search_off,
//                   size: 64,
//                   color: Colors.grey.shade400,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'No documents match your search',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: filteredDocs.length,
//           itemBuilder: (context, index) {
//             DocumentSnapshot doc = filteredDocs[index];
//             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//             return _buildDocumentCard(doc.id, data);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildDocumentCard(String docId, Map<String, dynamic> data) {
//     String documentType = data['documentType'] ?? 'Bill';
//     String customerName = data['customerName'] ?? 'Unknown Customer';
//     String customerMobile = data['customerMobile'] ?? '';
//     double totalAmount = (data['totalAmount'] ?? 0).toDouble();
//     int itemCount = (data['items'] as List?)?.length ?? 0;
//
//     // Format date
//     String dateStr = 'Unknown Date';
//     if (data['updatedAt'] != null) {
//       Timestamp timestamp = data['updatedAt'];
//       DateTime date = timestamp.toDate();
//       dateStr = '${date.day}/${date.month}/${date.year}';
//     }
//
//     return Card(
//       margin: EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () {
//           // Navigate to edit page
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => BillQuotationPage(
//                 existingDocumentId: docId,
//                 existingData: data,
//               ),
//             ),
//           ).then((_) => setState(() {})); // Refresh when coming back
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: documentType == 'Bill'
//                           ? Colors.blue.shade100
//                           : AppColors.appColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       documentType.toUpperCase(),
//                       style: TextStyle(
//                         color: documentType == 'Bill'
//                             ? Colors.blue.shade700
//                             : AppColors.appColor,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     dateStr,
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),
//
//               Row(
//                 children: [
//                   Icon(Icons.person, size: 16, color: Colors.grey.shade600),
//                   SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       customerName,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               if (customerMobile.isNotEmpty) ...[
//                 SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
//                     SizedBox(width: 6),
//                     Text(
//                       customerMobile,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//
//               SizedBox(height: 12),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.inventory_2, size: 16, color: Colors.grey.shade600),
//                       SizedBox(width: 6),
//                       Text(
//                         '$itemCount item${itemCount != 1 ? 's' : ''}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     '₹${totalAmount.toStringAsFixed(0)}',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.appColor,
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 12),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         // Navigate to edit
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => BillQuotationPage(
//                               existingDocumentId: docId,
//                               existingData: data,
//                             ),
//                           ),
//                         ).then((_) => setState(() {}));
//                       },
//                       icon: Icon(Icons.edit, size: 16),
//                       label: Text('Edit'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: AppColors.appColor,
//                         side: BorderSide(color: AppColors.appColor),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         // Navigate to generate PDF page
//                         _navigateToGeneratePDF(docId, data);
//                       },
//                       icon: Icon(
//                         documentType == 'Bill' ? Icons.receipt : Icons.picture_as_pdf,
//                         size: 16,
//                         color: Colors.white,
//                       ),
//                       label: Text(
//                         'View PDF',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: documentType == 'Bill'
//                             ? Colors.blue
//                             : AppColors.appColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _navigateToGeneratePDF(String docId, Map<String, dynamic> data) {
//     // Extract items for quotation page
//     List<Map<String, dynamic>> items = [];
//     if (data['items'] != null) {
//       items = List<Map<String, dynamic>>.from(data['items']);
//     }
//
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => QuotationPage( // Your existing QuotationPage
//           customerName: data['customerName'] ?? '',
//           customerMobile: data['customerMobile'] ?? '',
//           customerEmail: data['customerEmail'] ?? '',
//           items: items,
//           documentType: data['documentType'] ?? 'Bill',
//           existingDocumentId: docId,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/constants/app_text_styles.dart';
import 'package:relie_nquiry/constants/app_constants.dart';

import 'package:relie_nquiry/pages/Bill_quotation_page.dart';

import 'bill/Quotation.dart'; // Import your main page

class BillQuotationListPage extends StatefulWidget {
  const BillQuotationListPage({super.key});

  @override
  State<BillQuotationListPage> createState() => _BillQuotationListPageState();
}

class _BillQuotationListPageState extends State<BillQuotationListPage> {
  String _selectedFilter = 'All'; // All, Bill, Quotation
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Bills & Quotations",
            style: AppTextStyles.appBarWhite21bold,
          ),
          backgroundColor: AppColors.themeBlue,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => BillQuotationPage(),
                      ),
                    )
                    .then((_) => setState(() {})); // Refresh when coming back
              },
              tooltip: "Create New",
            ),
          ],
        ),
        body: Column(
          children: [
            _buildFilterAndSearchSection(),
            Expanded(child: _buildDocumentsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterAndSearchSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // Filter buttons
          Row(
            children: [
              _buildFilterChip('All'),
              SizedBox(width: 8),
              _buildFilterChip('Bill'),
              SizedBox(width: 8),
              _buildFilterChip('Quotation'),
            ],
          ),
          SizedBox(height: 12),

          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by customer name...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.appColor),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    bool isSelected = _selectedFilter == filter;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.appColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsList() {
    String? employeeUid = FirebaseAuth.instance.currentUser?.uid;

    if (employeeUid == null) {
      return Center(
        child: Text(
          'Please login to view documents',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _getDocumentsStream(employeeUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading documents: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade400),
                SizedBox(height: 16),
                Text(
                  'No documents found',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                SizedBox(height: 8),
                Text(
                  'Create your first bill or quotation',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        // Get all documents and sort them in code
        List<DocumentSnapshot> allDocs = snapshot.data!.docs;

        // Filter documents
        List<DocumentSnapshot> filteredDocs = allDocs.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Filter by document type
          if (_selectedFilter != 'All' &&
              data['documentType'] != _selectedFilter) {
            return false;
          }

          // Filter by search query
          if (_searchQuery.isNotEmpty) {
            String customerName = (data['customerName'] ?? '')
                .toString()
                .toLowerCase();
            if (!customerName.contains(_searchQuery)) {
              return false;
            }
          }

          return true;
        }).toList();

        // Sort by updatedAt in descending order (latest first)
        filteredDocs.sort((a, b) {
          Map<String, dynamic> dataA = a.data() as Map<String, dynamic>;
          Map<String, dynamic> dataB = b.data() as Map<String, dynamic>;

          Timestamp? timestampA = dataA['updatedAt'] as Timestamp?;
          Timestamp? timestampB = dataB['updatedAt'] as Timestamp?;

          // Handle null timestamps
          if (timestampA == null && timestampB == null) return 0;
          if (timestampA == null) return 1; // Put null timestamps at end
          if (timestampB == null) return -1;

          return timestampB.compareTo(
            timestampA,
          ); // Descending order (newest first)
        });

        if (filteredDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                SizedBox(height: 16),
                Text(
                  'No documents match your search',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = filteredDocs[index];
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            return Column(
              children: [
                _buildDocumentCard(doc.id, data),SizedBox(height: 10,)
              ],
            );
          },
        );
      },
    );
  }

  // Separate method to ensure clean query
  Stream<QuerySnapshot> _getDocumentsStream(String employeeUid) {
    return FirebaseFirestore.instance
        .collection('subscription')
        .doc(AppConstants.companyName)
        .collection('bill&Quotation')
        .where('employeeUid', isEqualTo: employeeUid)
        .snapshots();
  }

  Widget _buildDocumentCard(String docId, Map<String, dynamic> data) {
    String documentType = data['documentType'] ?? 'Bill';
    String customerName = data['customerName'] ?? 'Unknown Customer';
    String customerMobile = data['customerMobile'] ?? '';
    double totalAmount = (data['totalAmount'] ?? 0).toDouble();
    int itemCount = (data['items'] as List?)?.length ?? 0;

    // Format date
    String dateStr = 'Unknown Date';
    if (data['updatedAt'] != null) {
      Timestamp timestamp = data['updatedAt'];
      DateTime date = timestamp.toDate();
      dateStr = '${date.day}/${date.month}/${date.year}';
    }

    return InkWell(
      onTap: () {
        // Navigate to edit page
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => BillQuotationPage(
                  existingDocumentId: docId,
                  existingData: data,
                ),
              ),
            )
            .then((_) => setState(() {})); // Refresh when coming back
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.appColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: documentType == 'Bill'
                        ? Colors.blue.shade100
                        : AppColors.appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    documentType.toUpperCase(),
                    style: TextStyle(
                      color: documentType == 'Bill'
                          ? Colors.blue.shade700
                          : AppColors.appColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  dateStr,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.person, size: 18, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    customerName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            if (customerMobile.isNotEmpty) ...[

              Row(
                children: [
                  Icon(Icons.phone, size: 18, color: Colors.grey.shade600),
                  SizedBox(width: 6),
                  Text(
                    customerMobile,
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],



            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '$itemCount item${itemCount != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${totalAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to edit
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => BillQuotationPage(
                                existingDocumentId: docId,
                                existingData: data,
                              ),
                            ),
                          )
                          .then((_) => setState(() {}));
                    },
                    icon: Icon(Icons.edit, size: 16),
                    label: Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.appColor,
                      side: BorderSide(color: AppColors.appColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to generate PDF page
                      _navigateToGeneratePDF(docId, data);
                    },
                    icon: Icon(
                      documentType == 'Bill'
                          ? Icons.receipt
                          : Icons.picture_as_pdf,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      'View PDF',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: documentType == 'Bill'
                          ? Colors.blue
                          : AppColors.appColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToGeneratePDF(String docId, Map<String, dynamic> data) {
    // Extract items for quotation page
    List<Map<String, dynamic>> items = [];
    if (data['items'] != null) {
      items = List<Map<String, dynamic>>.from(data['items']);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuotationPage(
          // Your existing QuotationPage
          customerName: data['customerName'] ?? '',
          customerMobile: data['customerMobile'] ?? '',
          customerEmail: data['customerEmail'] ?? '',
          items: items,
          documentType: data['documentType'] ?? 'Bill',
          existingDocumentId: docId,
        ),
      ),
    );
  }
}
