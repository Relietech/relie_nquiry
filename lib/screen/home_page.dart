import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userRole;

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('user_role');
    });

    print("_userRole : $_userRole");
  }

  int service = 0;
  int product = 0;
  int schedule = 0;
  int other = 0;

  @override
  void initState() {
    super.initState();
    _loadUserRole();

    FirebaseFirestore.instance
        .collection("subscription")
        .doc(AppConstants.companyName)
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"lastSeenNotificationAt": FieldValue.serverTimestamp()});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.screenHeight(context),

      width: AppConstants.screenWidth(context),
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 290,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
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
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 20,
                              left: 20,
                              bottom: 15,
                              top: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("subscription")
                                          .doc(AppConstants.companyName)
                                          .collection("users")
                                          .doc(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          )
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container();
                                        }

                                        if (!snapshot.hasData ||
                                            !snapshot.data!.exists) {
                                          return Text(
                                            "Guest",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }

                                        final userData =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        return Text(
                                          "Hello, ${userData['name'] ?? 'User'}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (_userRole == 'Admin' ||
                                        _userRole == 'Super Admin')
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.adminpage);
                                        },
                                        child: Icon(
                                          Icons.admin_panel_settings,
                                          color: Colors.white,
                                        ),
                                      ),
                                    if (_userRole == 'Admin' ||
                                        _userRole == 'Super Admin')
                                      SizedBox(width: 14),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.profile);
                                      },
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("subscription")
                                          .doc(AppConstants.companyName)
                                          .collection("users")
                                          .doc(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          )
                                          .snapshots(),
                                      builder: (context, userSnap) {
                                        if (!userSnap.hasData ||
                                            !userSnap.data!.exists) {
                                          return Icon(
                                            Icons.notifications_rounded,
                                            color: Colors.white,
                                          );
                                        }

                                        final userData =
                                            userSnap.data!.data()
                                                as Map<String, dynamic>;
                                        final lastSeen =
                                            userData['lastSeenNotificationAt']
                                                as Timestamp?;

                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("subscription")
                                              .doc(AppConstants.companyName)
                                              .collection("AppNotification")
                                              .where(
                                                "topic",
                                                arrayContains: FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                              )
                                              .orderBy(
                                                "timestamp",
                                                descending: true,
                                              )
                                              .snapshots(),
                                          builder: (context, notifSnap) {
                                            if (!notifSnap.hasData) {
                                              return Icon(
                                                Icons.notifications_rounded,
                                                color: Colors.white,
                                              );
                                            }

                                            final docs = notifSnap.data!.docs;
                                            final newNotifs = docs.where((doc) {
                                              final deletedList =
                                                  List<String>.from(
                                                    doc['deletedList'] ?? [],
                                                  );
                                              final ts =
                                                  doc['timestamp'] as Timestamp;
                                              return !deletedList.contains(
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                  ) &&
                                                  (lastSeen == null ||
                                                      ts.toDate().isAfter(
                                                        lastSeen.toDate(),
                                                      ));
                                            }).toList();

                                            return Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      Routes.notificationScreen,
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.notifications_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                if (newNotifs.isNotEmpty)
                                                  Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    child: Container(
                                                      width: 18,
                                                      height: 18,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${newNotifs.length}',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    Stack(children: []),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("subscription")
                                .doc(AppConstants.companyName)
                                .collection("enquiry")
                                .where(
                                  "user_uid",
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid,
                                )
                                .where(
                                  'follow_up_date',
                                  isGreaterThanOrEqualTo: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  ),
                                )
                                .where(
                                  'follow_up_date',
                                  isLessThan: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day + 1,
                                  ),
                                )
                                .snapshots(),
                            builder: (context, snapshot) {
                              int count = 0;
                              if (snapshot.hasData) {
                                count = snapshot.data!.docs.length;
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Schedules',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      // height: 30,
                                      // width: 30,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        count.toString(),
                                        // shows 05, 06, etc.
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Horizontal Scrollable Container
              Positioned(
                bottom: 20,
                left: 15,
                right: 0,
                // top: 80,
                child: SizedBox(
                  height: 170, // Fixed height for the scroll area
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("subscription")
                        .doc(AppConstants.companyName)
                        .collection("enquiry")
                        .where(
                          "user_uid",
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .where(
                          'follow_up_date',
                          isGreaterThanOrEqualTo: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                        )
                        .where(
                          'follow_up_date',
                          isLessThan: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day + 1,
                          ),
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Card(
                            elevation: 2,
                            color: Colors.white,
                            child: Container(
                              width: 280,
                              // Fixed width for each card
                              margin: EdgeInsets.only(right: 15),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                // image: DecorationImage(
                                //   image: AssetImage(
                                //     "asset/image/no_follow.jpg",
                                //   ),
                                // ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    height: 100,
                                    //  width: 100,
                                    "asset/image/no_follow.jpg",
                                  ),
                                  Text(
                                    'No follow-ups today.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final List<Map<String, dynamic>> studentData = snapshot
                          .data!
                          .docs
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: studentData.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.toNamed(
                                Routes.followUpDetailsScreen,
                                arguments: studentData[index],
                              );
                            },
                            child: cardS(snapchat: studentData[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Enquiries',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 8),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("subscription")
                          .doc(AppConstants.companyName)
                          .collection("enquiry")
                          .where(
                            "user_uid",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                          )
                          .where(
                            'created_at',
                            isGreaterThanOrEqualTo: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                          )
                          .where(
                            'created_at',
                            isLessThan: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day + 1,
                            ),
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.appColor,
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '0',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.appColor,
                              ),
                            ),
                          );
                        }

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            snapshot.data!.docs.length.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.appColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.statusPage, arguments: "All");
                  },
                  child: Row(
                    children: [
                      Text(
                        'View More',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.appColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.appColor,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 30),
          // Add remaining content here (Enquiries section, etc.)
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (service != 0) {
                                Get.toNamed(
                                  Routes.statusPage,
                                  arguments: "Service",
                                );
                              }
                            },
                            child: Container(
                              alignment: Alignment.topCenter,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.appColor,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        //fit: BoxFit.cover,
                                        image: AssetImage(
                                          "asset/image/Service.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  //SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Service",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("subscription")
                                              .doc(AppConstants.companyName)
                                              .collection("enquiry")
                                              .where(
                                                "user_uid",
                                                isEqualTo: FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                              )
                                              .where(
                                                'form_type',
                                                isEqualTo: "Service",
                                              )
                                              .where(
                                                'created_at',
                                                isGreaterThanOrEqualTo:
                                                    DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day,
                                                    ),
                                              )
                                              .where(
                                                'created_at',
                                                isLessThan: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day + 1,
                                                ),
                                              )
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Container(); // or SizedBox.shrink()
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data == null) {
                                              return Container(
                                                width: 30,
                                                height: 30,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  '0',
                                                  style: TextStyle(
                                                    color: AppColors.appColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              );
                                            }

                                            service =
                                                snapshot.data!.docs.length;

                                            return Container(
                                              width: 30,
                                              height: 30,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                service.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.appColor,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (product != 0) {
                                Get.toNamed(
                                  Routes.statusPage,
                                  arguments: "Product",
                                );
                              }
                            },
                            child: Container(
                              alignment: Alignment.topCenter,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.appColor,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        //fit: BoxFit.cover,
                                        image: AssetImage(
                                          "asset/image/pro4.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  //SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Product",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("subscription")
                                              .doc(AppConstants.companyName)
                                              .collection("enquiry")
                                              .where(
                                                "user_uid",
                                                isEqualTo: FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                              )
                                              .where(
                                                'form_type',
                                                isEqualTo: "Product",
                                              )
                                              .where(
                                                'created_at',
                                                isGreaterThanOrEqualTo:
                                                    DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day,
                                                    ),
                                              )
                                              .where(
                                                'created_at',
                                                isLessThan: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day + 1,
                                                ),
                                              )
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Container(); // or SizedBox.shrink()
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data == null) {
                                              return Container(
                                                width: 30,
                                                height: 30,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  '0',
                                                  style: TextStyle(
                                                    color: AppColors.appColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              );
                                            }

                                            product =
                                                snapshot.data!.docs.length;

                                            return Container(
                                              width: 30,
                                              height: 30,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                product.toString(),
                                                style: TextStyle(
                                                  color: AppColors.appColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          },
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
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (schedule != 0) {
                                Get.toNamed(
                                  Routes.statusPage,
                                  arguments: "Schedule",
                                );
                              }
                            },
                            child: Container(
                              alignment: Alignment.topCenter,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.appColor,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [

                                  Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        // fit: BoxFit.cover,
                                        image: AssetImage(
                                          "asset/image/Schedule.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Schedule",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("subscription")
                                              .doc(AppConstants.companyName)
                                              .collection("enquiry")
                                              .where(
                                                "user_uid",
                                                isEqualTo: FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                              )
                                              .where(
                                                'form_type',
                                                isEqualTo: "Schedule",
                                              )
                                              .where(
                                                'created_at',
                                                isGreaterThanOrEqualTo:
                                                    DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day,
                                                    ),
                                              )
                                              .where(
                                                'created_at',
                                                isLessThan: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day + 1,
                                                ),
                                              )
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Container(); // or SizedBox.shrink()
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data == null) {
                                              return Container(
                                                width: 30,
                                                height: 30,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  '0',
                                                  style: TextStyle(
                                                    color: AppColors.appColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              );
                                            }

                                            schedule =
                                                snapshot.data!.docs.length;

                                            return Container(
                                              width: 30,
                                              height: 30,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                schedule.toString(),
                                                style: TextStyle(
                                                  color: AppColors.appColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.quotationPage);
                            },
                            child: Container(
                              alignment: Alignment.topCenter,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.appColor,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        // fit: BoxFit.cover,
                                        image: AssetImage(
                                          "asset/image/Quotation-01-01.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Quotation",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            "0",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.appColor,
                                            ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for different card data
}

// Widget _notificationIcon(int count) {
//   return Stack(
//     children: [
//       InkWell(
//         onTap: () async {
//           // 👇 Update seen time
//           await FirebaseFirestore.instance
//               .collection("subscription")
//               .doc(AppConstants.companyName)
//               .collection("users")
//               .doc(FirebaseAuth.instance.currentUser!.uid)
//               .update({"lastSeenNotificationAt": FieldValue.serverTimestamp()});
//
//           Get.toNamed(Routes.notificationScreen);
//         },
//         child: const Icon(
//           Icons.notifications_rounded,
//           color: Colors.white,
//           size: 25,
//         ),
//       ),
//       if (count > 0)
//         Positioned(
//           right: 0,
//           top: 0,
//           child: Container(
//             width: 16,
//             height: 16,
//             decoration: const BoxDecoration(
//               color: Colors.red,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 count > 99 ? '99+' : '$count',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//     ],
//   );
// }

Widget cardS({required snapchat}) {
  return Card(
    elevation: 2,
    // color: snapchat["status"] == "Open" ? Colors.white : Colors.grey.shade600,
    child: Container(
      width: 280,
      // Fixed width for each card
      // margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: snapchat["status"] == "Open"
            ? Colors.white
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: snapchat["form_type"] == "Service"
                        ? Color(0xFFf9b401)
                        : snapchat["form_type"] == "Product"
                        ? Color(0xFF622fa4)
                        : snapchat["form_type"] == "Schedule"
                        ? Color(0xFFf8681a)
                        : Color(0xFF3754db),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    snapchat["form_type"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  snapchat["name"],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 9),
            if (snapchat['form_type'] == 'Service') ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      snapchat['isInternship'] == true
                          ? "Internship\n${snapchat['internshipCourseName']}" ??
                                ''
                          : snapchat['isTraining'] == true
                          ? "Training\n${snapchat['trainingCourseName']}" ?? ''
                          : snapchat['isJobFresher'] == true
                          ? "Job: Fresher\n${snapchat['jobName']}" ?? ''
                          : snapchat['isJobExperienced'] == true
                          ? "Job: Experienced\n${snapchat['jobName']}" ?? ''
                          : 'No Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ] else if (snapchat['form_type'] == 'Product') ...[
              Row(
                children: [
                  const Text(
                    'Product Name: ',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Expanded(
                    child: Text(
                      "${snapchat['product_name'] ?? ''} ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ] else if (snapchat['form_type'] == 'Schedule') ...[
              Row(
                children: [
                  const Text(
                    'Event Name: ',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Expanded(
                    child: Text(
                      snapchat['event_name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            // else if (snapchat['form_type'] == 'Others') ...[
            //   Row(
            //     children: [
            //       const Text(
            //         'Title: ',
            //         style: TextStyle(fontSize: 16, color: Colors.black54),
            //       ),
            //       Expanded(
            //         child: Text(
            //           snapchat['others_title'] ?? '',
            //           style: const TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.black87,
            //           ),
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //       ),
            //     ],
            //   ),
            // ],
            SizedBox(height: 9),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  snapchat["follow_up_date"] != null
                      ? "${DateFormat('d MMM yyyy').format((snapchat["follow_up_date"] as Timestamp).toDate())} - ${snapchat["follow_up_time"]}"
                      : 'No follow-up date',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
