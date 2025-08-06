//
// import 'package:flutter/material.dart';
// import 'package:relie_captain/constants/app_constants.dart';
// import 'package:relie_captain/constants/app_text_styles.dart';
//
// class NotificationPage extends StatefulWidget {
//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//   final List<NotificationItem> notifications = [
//     NotificationItem(
//       icon: Icons.account_balance,
//       iconColor: Color(0xffffb81e),
//       title: "Pending",
//       message: "Please update your Bank details.",
//       dateTime: "21/12/2025 02:12 PM",
//     ),
//     NotificationItem(
//       icon: Icons.warning,
//       iconColor: Colors.red,
//       title: "Warning !",
//       message: "Avoid late payment for the COD amount.",
//       dateTime: "21/12/2025 02:12 PM",
//     ),
//     NotificationItem(
//       icon: Icons.credit_card_off,
//       iconColor: Colors.amber,
//       title: "Pending",
//       message: "Please update your PAN details.",
//       dateTime: "21/12/2025 02:12 PM",
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold( appBar: AppBar(
//       leading: InkWell(
//         onTap: () {
//           Navigator.pop(context);
//         },
//         child: Icon(Icons.arrow_back, color: Colors.black),
//       ),
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black,
//     ),
//       backgroundColor: Colors.white,
//       body: Container(
//         height: AppConstants.screenHeight(context),
//         width: AppConstants.screenWidth(context),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Custom status bar
//             // CustomStatusBar(),
//
//             // Custom "AppBar" layout using a Column
//             Text(
//                 "Notifications",
//                 style:AppTextStyles.black20bold
//             ),
//             SizedBox(height: 20,),
//             // Notification list
//             Expanded(
//               child: ListView.builder(
//                 // padding: const EdgeInsets.all(16),
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   final item = notifications[index];
//                   return NotificationCard(item: item);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class NotificationItem {
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String message;
//   final String dateTime;
//
//   NotificationItem({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.message,
//     required this.dateTime,
//   });
// }
//
// class NotificationCard extends StatelessWidget {
//   final NotificationItem item;
//
//   const NotificationCard({required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       margin: const EdgeInsets.only(bottom: 16),
//
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Title and DateTime Row
//                   ///
//
//                   Row(mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//
//                       Text(
//                         item.dateTime,
//                         style: TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                     ],
//                   ), Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: item.iconColor,
//                         child: Icon(item.icon, color: Colors.white),
//                       ),
//                       SizedBox(width: 12),
//                       Column(crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             item.title,
//                             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
//                           ),
//                           Text(
//                             item.message,
//                             style: TextStyle(
//                               color: Color(0xff616161),fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                     ],
//                   ),
//                   // SizedBox(height: 8),
//
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:intl/intl.dart';
//
// import '../constants/app_colors.dart';
// import '../constants/app_constants.dart' show AppConstants;
// import '../constants/app_text_styles.dart';
// import 'package:get/get.dart';
//
// class NotificationPage extends StatefulWidget {
//   const NotificationPage({Key? key}) : super(key: key);
//
//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//   bool _isSelectionMode = false;
//
//   // final List<NotificationItem> _notifications = [
//   //   NotificationItem(
//   //     id: '1',
//   //     icon: Icons.info_outline,
//   //     iconColor: Colors.amber,
//   //     title: 'Pending',
//   //     message: 'Please update your Profile Photo.',
//   //     date: '21/12/2026',
//   //     time: '02:12 PM',
//   //   ),
//   //   NotificationItem(
//   //     id: '2',
//   //     icon: Icons.info_outline,
//   //     iconColor: Colors.amber,
//   //     title: 'Pending',
//   //     message: 'Please update your details.',
//   //     date: '21/12/2026',
//   //     time: '02:12 PM',
//   //   ),
//   //   NotificationItem(
//   //     id: '3',
//   //     icon: Icons.notifications,
//   //     iconColor: Colors.green,
//   //     title: 'New Offer',
//   //     message: 'Special discount on your next ride!',
//   //     date: '20/12/2026',
//   //     time: '01:30 PM',
//   //   ),
//   // ];
//
//   final Set<String> _selectedIds = {};
//
//   void _toggleSelectionMode() {
//     setState(() {
//       _isSelectionMode = !_isSelectionMode;
//       if (!_isSelectionMode) {
//         _selectedIds.clear();
//       }
//     });
//   }
//
//   void _selectAll(List<QueryDocumentSnapshot> docs) {
//     setState(() {
//       if (_selectedIds.length == docs.length) {
//         _selectedIds.clear();
//       } else {
//         _selectedIds.clear();
//         _selectedIds.addAll(docs.map((doc) => doc.id));
//       }
//     });
//   }
//
//   // void _selectAll() {
//   //   setState(() {
//   //     if (_selectedIds.length == _notifications.length) {
//   //       // If all are selected, deselect all
//   //       _selectedIds.clear();
//   //     } else {
//   //       // Select all
//   //       _selectedIds.addAll(_notifications.map((n) => n.id));
//   //     }
//   //   });
//   // }
//
//   void _toggleSelection(String id) {
//     setState(() {
//       if (_selectedIds.contains(id)) {
//         _selectedIds.remove(id);
//       } else {
//         _selectedIds.add(id);
//       }
//     });
//   }
//
//   Future<void> _deleteSelectedNotifications() async {
//     final userId = FirebaseAuth.instance.currentUser!.uid;
//
//     for (final id in _selectedIds) {
//       final ref = FirebaseFirestore.instance
//           .collection("subscription")
//           .doc(AppConstants.companyName)
//           .collection("AppNotification")
//           .doc(id);
//
//       final doc = await ref.get();
//       if (doc.exists) {
//         List deletedList = doc.get("deletedList") ?? [];
//         if (!deletedList.contains(userId)) {
//           deletedList.add(userId);
//           await ref.update({"deletedList": deletedList});
//         }
//       }
//     }
//
//     setState(() {
//       _selectedIds.clear();
//       _isSelectionMode = false;
//     });
//   }
//
//   // void _deleteSelectedNotifications() {
//   //   setState(() {
//   //     _notifications.removeWhere(
//   //       (notification) => _selectedIds.contains(notification.id),
//   //     );
//   //     _selectedIds.clear();
//   //     _isSelectionMode = false;
//   //   });
//   // }
//
//   // void _deleteNotification(String id) {
//   //   setState(() {
//   //     _notifications.removeWhere((notification) => notification.id == id);
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Column(
//           children: [
//             ClipPath(
//               clipper: ArcClipper(),
//               child: Container(
//                 padding: EdgeInsets.only(top: 5, left: 10),
//                 height: 140,
//                 alignment: Alignment.topLeft,
//                 decoration: const BoxDecoration(
//                   gradient: AppColors.themGradient,
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(30),
//                     bottomLeft: Radius.circular(30),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 25,
//                       ),
//                     ),
//                     Text("Notification", style: AppTextStyles.white22bold),
//                     IconButton(
//                       icon: Icon(
//                         _isSelectionMode ? Icons.close : Icons.more_vert,
//                       ),
//                       color: Colors.white,
//                       onPressed: _toggleSelectionMode,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Selection options bar
//             // if (_isSelectionMode)
//             //   Container(
//             //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             //     color: Colors.grey[100],
//             //     child: Row(
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       children: [
//             //         TextButton(
//             //           onPressed: () => _selectAll(snapshot.data!.docs),
//             //           child: Text(
//             //             _selectedIds.length == snapshot.data!.docs.length
//             //                 ? 'Deselect All'
//             //                 : 'Select All',
//             //             style: TextStyle(color: AppColors.appColor),
//             //           ),
//             //         ),
//             //         if (_selectedIds.isNotEmpty)
//             //           TextButton.icon(
//             //             onPressed: _deleteSelectedNotifications,
//             //             icon: Icon(Icons.delete, color: Colors.red),
//             //             label: Text(
//             //               'Delete',
//             //               style: TextStyle(color: Colors.red),
//             //             ),
//             //           ),
//             //       ],
//             //     ),
//             //   ),
//
//             // Notifications list
//             StreamBuilder(
//               stream:
//                   FirebaseFirestore.instance
//                       .collection("subscription")
//                       .doc(AppConstants.companyName)
//                       .collection("AppNotification")
//                       .where(
//                         "topic",
//                         arrayContains:
//                             FirebaseAuth.instance.currentUser!.uid.toString(),
//                       )
//                       .orderBy('timeStamp', descending: true)
//                       .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   if (snapshot.data!.docs.isNotEmpty) {
//                     return Column(
//                       children: [
//                         if (_isSelectionMode)
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             color: Colors.grey[100],
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 TextButton(
//                                   onPressed:
//                                       () => _selectAll(snapshot.data!.docs),
//                                   child: Text(
//                                     _selectedIds.length ==
//                                             snapshot.data!.docs.length
//                                         ? 'Deselect All'
//                                         : 'Select All',
//                                     style: TextStyle(color: AppColors.appColor),
//                                   ),
//                                 ),
//                                 if (_selectedIds.isNotEmpty)
//                                   TextButton.icon(
//                                     onPressed: _deleteSelectedNotifications,
//                                     icon: Icon(Icons.delete, color: Colors.red),
//                                     label: Text(
//                                       'Delete',
//                                       style: TextStyle(color: Colors.red),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//
//                         ListView.builder(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//                             final doc = snapshot.data!.docs[index];
//                             final notificationId = doc.id;
//                             final isSelected = _selectedIds.contains(
//                               notificationId,
//                             );
//
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 8.0),
//                               child: Dismissible(
//                                 key: Key(notificationId),
//                                 onDismissed: (
//                                   DismissDirection direction,
//                                 ) async {
//                                   final ref = FirebaseFirestore.instance
//                                       .collection("subscription")
//                                       .doc(AppConstants.companyName)
//                                       .collection("AppNotification")
//                                       .doc(notificationId);
//
//                                   final data = await ref.get();
//                                   List deletedList =
//                                       data.get("deletedList") ?? [];
//                                   if (!deletedList.contains(
//                                     FirebaseAuth.instance.currentUser!.uid,
//                                   )) {
//                                     deletedList.add(
//                                       FirebaseAuth.instance.currentUser!.uid,
//                                     );
//                                     await ref.update({
//                                       "deletedList": deletedList,
//                                     });
//                                   }
//                                 },
//                                 direction: DismissDirection.endToStart,
//                                 background: Container(
//                                   alignment: Alignment.centerRight,
//                                   padding: const EdgeInsets.only(right: 20),
//                                   decoration: BoxDecoration(
//                                     color: Colors.red,
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                   child: const Icon(
//                                     Icons.delete,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {});
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color:
//                                           isSelected
//                                               ? Colors.blue.withOpacity(0.1)
//                                               : Colors.white,
//                                       borderRadius: BorderRadius.circular(8.0),
//                                       border: Border.all(
//                                         color:
//                                             isSelected
//                                                 ? AppColors.appColor
//                                                 : Colors.grey.shade300,
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(16.0),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           if (_isSelectionMode)
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                 right: 10.0,
//                                               ),
//                                               child: Checkbox(
//                                                 value: isSelected,
//                                                 onChanged: (bool? value) {
//                                                   _toggleSelection(
//                                                     notificationId,
//                                                   );
//                                                 },
//                                                 activeColor: AppColors.appColor,
//                                               ),
//                                             ),
//                                           if (!_isSelectionMode)
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                 color: AppColors.appColor
//                                                     .withOpacity(0.5),
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               padding: const EdgeInsets.all(
//                                                 8.0,
//                                               ),
//                                               child: const Icon(
//                                                 Icons.notifications,
//                                                 color: Colors.amber,
//                                                 size: 24.0,
//                                               ),
//                                             ),
//                                           const SizedBox(width: 12),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   doc['title'],
//                                                   style: const TextStyle(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 4),
//                                                 Text(
//                                                   doc['msg'],
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: Colors.grey.shade700,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                             children: [
//                                               Text(
//                                                 DateFormat.yMMMd().format(
//                                                   doc['timestamp'].toDate(),
//                                                 ),
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.grey.shade600,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 DateFormat.jm().format(
//                                                   doc['timestamp'].toDate(),
//                                                 ),
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.grey.shade600,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     );
//                   } else {
//                     return const Center(
//                       child: Text(
//                         "No Notifications",
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     );
//                   }
//                 } else {
//                   return Container();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class NotificationItem {
//   final String id;
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String message;
//   final String date;
//   final String time;
//
//   NotificationItem({
//     required this.id,
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.message,
//     required this.date,
//     required this.time,
//   });
// }
//
// // Expanded(
// // child:
// // _notifications.isEmpty
// // ? Center(
// // child: Text(
// // 'No notifications',
// // style: TextStyle(color: Colors.grey),
// // ),
// // )
// //     : ListView.builder(
// // padding: const EdgeInsets.symmetric(horizontal: 15),
// // itemCount: _notifications.length,
// // itemBuilder: (context, index) {
// // final notification = _notifications[index];
// // final isSelected = _selectedIds.contains(
// // notification.id,
// // );
// //
// // return Padding(
// // padding: const EdgeInsets.only(bottom: 8.0),
// // child: Dismissible(
// // key: Key(notification.id),
// // direction: DismissDirection.endToStart,
// // background: Container(
// // alignment: Alignment.centerRight,
// // padding: EdgeInsets.only(right: 20),
// // decoration: BoxDecoration(
// // color: Colors.white,
// // borderRadius: BorderRadius.circular(8.0),
// // ),
// // child: Icon(
// // Icons.delete,
// // color: Colors.white,
// // ),
// // ),
// // onDismissed: (direction) {
// // _deleteNotification(notification.id);
// // },
// // child: GestureDetector(
// // onTap:
// // _isSelectionMode
// // ? () => _toggleSelection(
// // notification.id,
// // )
// //     : null,
// // onLongPress: () {
// // if (!_isSelectionMode) {
// // setState(() {
// // _isSelectionMode = true;
// // _selectedIds.add(notification.id);
// // });
// // }
// // },
// // child: Container(
// // decoration: BoxDecoration(
// // color:
// // isSelected
// // ? Colors.blue.withOpacity(0.1)
// //     : Colors.white,
// // borderRadius: BorderRadius.circular(
// // 8.0,
// // ),
// // border: Border.all(
// // color:
// // isSelected
// // ? AppColors.appColor
// //     : Colors.grey.shade300,
// // ),
// // ),
// // child: Padding(
// // padding: const EdgeInsets.all(16.0),
// // child: Row(
// // crossAxisAlignment:
// // CrossAxisAlignment.start,
// // children: [
// // if (_isSelectionMode)
// // Padding(
// // padding: const EdgeInsets.only(
// // right: 10.0,
// // ),
// // child: Checkbox(
// // value: isSelected,
// // onChanged: (bool? value) {
// // _toggleSelection(
// // notification.id,
// // );
// // },
// // activeColor:
// // AppColors.appColor,
// // ),
// // ),
// // if (!_isSelectionMode)
// // Container(
// // decoration: BoxDecoration(
// // color: notification.iconColor
// //     .withOpacity(0.1),
// // shape: BoxShape.circle,
// // ),
// // padding: const EdgeInsets.all(
// // 8.0,
// // ),
// // child: Icon(
// // notification.icon,
// // color: notification.iconColor,
// // size: 24.0,
// // ),
// // ),
// // const SizedBox(width: 12),
// // Expanded(
// // child: Column(
// // crossAxisAlignment:
// // CrossAxisAlignment.start,
// // children: [
// // Text(
// // notification.title,
// // style: const TextStyle(
// // fontSize: 16,
// // fontWeight:
// // FontWeight.bold,
// // ),
// // ),
// // const SizedBox(height: 4),
// // Text(
// // notification.message,
// // style: TextStyle(
// // fontSize: 14,
// // color:
// // Colors.grey.shade700,
// // ),
// // ),
// // ],
// // ),
// // ),
// // Column(
// // crossAxisAlignment:
// // CrossAxisAlignment.end,
// // children: [
// // Text(
// // notification.date,
// // style: TextStyle(
// // fontSize: 12,
// // color: Colors.grey.shade600,
// // ),
// // ),
// // const SizedBox(height: 4),
// // Text(
// // notification.time,
// // style: TextStyle(
// // fontSize: 12,
// // color: Colors.grey.shade600,
// // ),
// // ),
// // ],
// // ),
// // ],
// // ),
// // ),
// // ),
// // ),
// // ),
// // );
// // },
// // ),
// // );
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart' show AppConstants;
import '../constants/app_text_styles.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedIds.clear();
      }
    });
  }

  List notifications = [];

  void _selectAll(List<QueryDocumentSnapshot> docs) {
    setState(() {
      if (_selectedIds.length == docs.length) {
        _selectedIds.clear();
      } else {
        _selectedIds.clear();
        _selectedIds.addAll(docs.map((doc) => doc.id));
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _deleteSelectedNotifications() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    for (final id in _selectedIds) {
      final ref = FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection("AppNotification")
          .doc(id);

      final doc = await ref.get();
      if (doc.exists) {
        List deletedList = doc.get("deletedList") ?? [];
        if (!deletedList.contains(userId)) {
          deletedList.add(userId);
          await ref.update({"deletedList": deletedList});
        }
      }
    }

    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    notifications;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

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
                  //gradient: AppColors.themGradient,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const Center(
                      child: Text(
                        "Notifications",
                        style: AppTextStyles.appBarWhite21bold,
                      ),
                    ),
                    //if (notifications.isNotEmpty)
                    InkWell(
                      onTap: _toggleSelectionMode,
                      child: Icon(
                        _isSelectionMode ? Icons.close : Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            /// Notifications Stream
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection("subscription")
                        .doc(AppConstants.companyName)
                        .collection("AppNotification")
                        .where("topic", arrayContains: userId)
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final allDocs = snapshot.data!.docs;
                    final visibleDocs =
                        allDocs.where((doc) {
                          List deletedList = doc.get("deletedList") ?? [];
                          return !deletedList.contains(userId);
                        }).toList();

                    if (visibleDocs.isEmpty) {
                      return Center(
                        child: Container(
                          // width: 280,
                          // Fixed width for each card
                          margin: EdgeInsets.only(right: 15),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                height: 150,
                                width: 150,
                                "asset/image/empty_notification.png",
                              ),
                              SizedBox(height: 15),
                              Icon(Icons.notifications),
                              Text(
                                'No Notification.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        if (_isSelectionMode)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: Colors.grey[100],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => _selectAll(visibleDocs),
                                  child: Text(
                                    _selectedIds.length == visibleDocs.length
                                        ? 'Deselect All'
                                        : 'Select All',
                                    style: TextStyle(color: AppColors.appColor),
                                  ),
                                ),
                                if (_selectedIds.isNotEmpty)
                                  TextButton.icon(
                                    onPressed: _deleteSelectedNotifications,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    label: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemCount: visibleDocs.length,
                            itemBuilder: (context, index) {
                              final doc = visibleDocs[index];
                              final notificationId = doc.id;
                              final isSelected = _selectedIds.contains(
                                notificationId,
                              );

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Colors.blue.withOpacity(0.1)
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? AppColors.appColor
                                              : Colors.grey.shade300,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_isSelectionMode)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10.0,
                                          ),
                                          child: Checkbox(
                                            value: isSelected,
                                            onChanged:
                                                (bool? value) =>
                                                    _toggleSelection(
                                                      notificationId,
                                                    ),
                                            activeColor: AppColors.appColor,
                                          ),
                                        ),
                                      if (!_isSelectionMode)
                                        Container(
                                          alignment: Alignment.center,
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: AppColors.appColor
                                                .withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            doc['title'].toString().isNotEmpty
                                                ? doc['title']
                                                    .toString()[0]
                                                    .toUpperCase()
                                                : '',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc['title'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              doc['msg'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            DateFormat.yMMMd().format(
                                              doc['timestamp'].toDate(),
                                            ),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            DateFormat.jm().format(
                                              doc['timestamp'].toDate(),
                                            ),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Container(
                        // width: 280,
                        // Fixed width for each card
                        margin: EdgeInsets.only(right: 15),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              height: 150,
                              width: 150,
                              "asset/image/empty_notification.png",
                            ),
                            SizedBox(height: 15),
                            Text(
                              'No Notification.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// return Padding(
// padding: const EdgeInsets.only(bottom: 8.0),
// child: Dismissible(
// key: Key(notificationId),
// // direction: DismissDirection.endToStart,
// // background: Container(
// //   alignment: Alignment.centerRight,
// //   padding: const EdgeInsets.only(right: 20),
// //   decoration: BoxDecoration(
// //     color: Colors.red,
// //     borderRadius: BorderRadius.circular(8.0),
// //   ),
// //   child: const Icon(
// //     Icons.delete,
// //     color: Colors.white,
// //   ),
// // ),
// // onDismissed: (direction) async {
// //   final ref = FirebaseFirestore.instance
// //       .collection("subscription")
// //       .doc(AppConstants.companyName)
// //       .collection("AppNotification")
// //       .doc(notificationId);
// //
// //   final data = await ref.get();
// //   List deletedList =
// //       data.get("deletedList") ?? [];
// //   if (!deletedList.contains(userId)) {
// //     deletedList.add(userId);
// //     await ref.update({
// //       "deletedList": deletedList,
// //     });
// //   }
// // },
// child: GestureDetector(
// onTap: () => setState(() {}),
// child: Container(
// decoration: BoxDecoration(
// color:
// isSelected
// ? Colors.blue.withOpacity(0.1)
//     : Colors.white,
// borderRadius: BorderRadius.circular(
// 8.0,
// ),
// border: Border.all(
// color:
// isSelected
// ? AppColors.appColor
//     : Colors.grey.shade300,
// ),
// ),
// padding: const EdgeInsets.all(16.0),
// child: Row(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// if (_isSelectionMode)
// Padding(
// padding: const EdgeInsets.only(
// right: 10.0,
// ),
// child: Checkbox(
// value: isSelected,
// onChanged:
// (bool? value) =>
// _toggleSelection(
// notificationId,
// ),
// activeColor: AppColors.appColor,
// ),
// ),
// if (!_isSelectionMode)
// Container(
// alignment: Alignment.center,
// width: 45,
// height: 45,
// decoration: BoxDecoration(
// color: AppColors.appColor
//     .withOpacity(0.5),
// shape: BoxShape.circle,
// ),
// // padding: const EdgeInsets.all(
// //  10,
// // ),
// child:  Text(
// "E",
// style: TextStyle(
// fontSize: 24,
// color: Colors.black,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// const SizedBox(width: 12),
// Expanded(
// child: Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// Text(
// doc['title'],
// style: const TextStyle(
// fontSize: 16,
// fontWeight: FontWeight.bold,
// ),
// ),
// const SizedBox(height: 4),
// Text(
// doc['msg'],
// style: TextStyle(
// fontSize: 14,
// color: Colors.grey.shade700,
// ),
// ),
// ],
// ),
// ),
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.end,
// children: [
// Text(
// DateFormat.yMMMd().format(
// doc['timestamp'].toDate(),
// ),
// style: TextStyle(
// fontSize: 12,
// color: Colors.grey.shade600,
// ),
// ),
// const SizedBox(height: 4),
// Text(
// DateFormat.jm().format(
// doc['timestamp'].toDate(),
// ),
// style: TextStyle(
// fontSize: 12,
// color: Colors.grey.shade600,
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// ),
// ),
// );
