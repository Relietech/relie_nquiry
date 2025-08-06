import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:relie_nquiry/constants/app_funtion.dart';
import 'package:relie_nquiry/constants/funtions/auth_services.dart';
import 'package:relie_nquiry/constants/uppercase_formatter.dart';
import '../constants/app_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/text_fields.dart';
import '../routes/app_routes.dart';

class AdminEmployeePage extends StatefulWidget {
  const AdminEmployeePage({super.key});

  @override
  State<AdminEmployeePage> createState() => _AdminEmployeePageState();
}

class _AdminEmployeePageState extends State<AdminEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final mobileController = TextEditingController();
  final employeeIdController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final designationController = TextEditingController();

  String _imageFile = "";

  List<String> roleList = ['Admin', 'Employee'];

  //  / ✅ Already existing function
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registering user...")));

      final result = await authService.employee(
        name: name,
        role: role!,
        imageFile: _imageFile,
        password: password,
        designation: designation,
        mobile: mobile,
        employeeId: employeeId,
        address: address,

        // imageFile: _imageFile!,
      );

      if (result == null) {
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text("Success"),
            content: const Text("Employee registered successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: AppColors.appColor),
                ),
              ),
            ],
          ),
        );

        setState(() {
          createdUserName = nameController.text.trim();
          createdUserRole = selectedRole;
          createdUserImage = null;
          index = 2; // Switch to profile tab after creation
          _imageFile = "";
        });

        _formKey.currentState!.reset();
      }
    }
  }

  String? createdUserName;
  String? createdUserRole;
  File? createdUserImage;

  int index = 1;
  String? selectedRole;

  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          //Get.back();
                          Get.offNamed('/adminpage');
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const Text(
                        "Employees",
                        style: AppTextStyles.appBarWhite21bold,
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.addEmployee);
                        },
                        child: Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  elevation: 5,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value.trim().toLowerCase();
                      });
                    },
                    cursorColor: Colors.grey.shade800,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffixIcon:
                          searchText.isNotEmpty
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
                                  color: AppColors.appColor,
                                ),
                                onPressed: () {},
                              ),
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              /// Form Body
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream:
                                  FirebaseFirestore.instance
                                      .collection('subscription')
                                      .doc(AppConstants.companyName)
                                      .collection("users")
                                      .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.appColor,
                                    ),
                                  );
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                    child: Text("No users found."),
                                  );
                                }

                                final allData =
                                    snapshot.data!.docs.map((doc) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
                                      data['id'] = doc.id;
                                      return data;
                                    }).toList();

                                final filtered =
                                    allData.where((user) {
                                      final name =
                                          (user['name'] ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final empId =
                                          (user['employee_id'] ?? '')
                                              .toString()
                                              .toLowerCase();
                                      final status =
                                          (user['status'] ?? '')
                                              .toString()
                                              .toLowerCase();

                                      return searchText.isEmpty ||
                                          name.contains(
                                            searchText.toLowerCase(),
                                          ) ||
                                          empId.contains(
                                            searchText.toLowerCase(),
                                          ) ||
                                          status.contains(
                                            searchText.toLowerCase(),
                                          );
                                    }).toList();

                                if (filtered.isEmpty) {
                                  return const Center(
                                    child: Text('No users found'),
                                  );
                                }

                                return Column(
                                  children: [
                                    ListView.separated(
                                      separatorBuilder:
                                          (context, index) =>
                                              const SizedBox(height: 10),
                                      itemCount: filtered.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      itemBuilder: (context, index) {
                                        final user = filtered[index];

                                        if (user['role'] != "Super Admin") {
                                          return InkWell(
                                            onTap: () {
                                              Get.toNamed(
                                                Routes.userProfile,
                                                arguments: {
                                                  "id": user["id"],
                                                  ...user,
                                                },
                                              );
                                            },
                                            child: UserCard(
                                              name: user['name'] ?? '',
                                              role: user['employee_id'] ?? '',
                                              target: 0,
                                              completed: 0,
                                              close: 0,
                                              noResponse: 0,
                                              image: user['image_path'] ?? "",
                                              status: user["status"],
                                              uid: user["uid"],
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 50),
                                  ],
                                );
                              },
                            ),
                          ],
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
    );
  }
}

class UserCard extends StatefulWidget {
  final String name;
  final String role;
  final int target;
  final int completed;
  final int close;
  final int noResponse;
  final String image;
  final String status;
  final String uid;

  const UserCard({
    super.key,
    required this.name,
    required this.role,
    required this.target,
    required this.completed,
    required this.close,
    required this.noResponse,
    this.image = "",
    required this.status,
    required this.uid,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                            image:
                                widget.image.trim().isNotEmpty
                                    ? DecorationImage(
                                      image: NetworkImage(widget.image),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              widget.image.trim().isEmpty
                                  ? const Icon(Icons.person, size: 40)
                                  : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              Text(
                                widget.role,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.deepPurple,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          widget.status.toLowerCase() == "active"
                              ? Colors.green
                              : Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      widget.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection("subscription")
                                    .doc(AppConstants.companyName)
                                    .collection("enquiry")
                                    .where("user_uid", isEqualTo: widget.uid)
                                    .where(
                                      "status",
                                      isEqualTo: "Open",
                                    ) // filter by status
                                    // optional, if multiple users' data exist
                                    .snapshots(),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _buildStat(
                                  "Open",
                                  "...",
                                ); // loading indicator
                              }

                              final int openCount =
                                  snapshot.data?.docs.length ?? 0;

                              return _buildStat("Open", openCount.toString());
                            },
                          ),

                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection("subscription")
                                    .doc(AppConstants.companyName)
                                    .collection("enquiry")
                                    .where("user_uid", isEqualTo: widget.uid)
                                    .where("status", isEqualTo: "Completed")
                                    .snapshots(),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _buildStat(
                                  "Completed",
                                  "...",
                                  color: Colors.green,
                                ); // loading indicator
                              }

                              final int completedCount =
                                  snapshot.data?.docs.length ?? 0;

                              return _buildStat(
                                "Completed",
                                completedCount.toString(),
                                color: Colors.green,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection("subscription")
                                    .doc(AppConstants.companyName)
                                    .collection("enquiry")
                                    .where("user_uid", isEqualTo: widget.uid)
                                    .where("status", isEqualTo: "No Response")
                                    .snapshots(),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _buildStat(
                                  "No Response",
                                  "...",
                                  color: Colors.blue,
                                ); // loading indicator
                              }

                              final int noResponseCount =
                                  snapshot.data?.docs.length ?? 0;

                              return _buildStat(
                                "No Response",
                                noResponseCount.toString(),
                                color: Colors.blue,
                              );
                            },
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection("subscription")
                                    .doc(AppConstants.companyName)
                                    .collection("enquiry")
                                    .where("user_uid", isEqualTo: widget.uid)
                                    .where("status", isEqualTo: "Close")
                                    .snapshots(),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _buildStat(
                                  "Close",
                                  "...",
                                  color: Colors.red,
                                ); // loading indicator
                              }

                              final int closeCount =
                                  snapshot.data?.docs.length ?? 0;

                              return _buildStat(
                                "Close",
                                closeCount.toString(),
                                color: Colors.red,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, {Color? color}) {
    return Row(
      children: [
        Text("$label - ", style: TextStyle(fontSize: 16, color: Colors.black)),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: color ?? Colors.black),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}

// Card(
// elevation: 3,
// color: Colors.white,
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
// child: Container(
// height: 130,
// //padding: const EdgeInsets.all(10),
// //margin: const EdgeInsets.symmetric(vertical: 5),
// decoration: BoxDecoration(
// //border: Border.all(color: Colors.black),
// borderRadius: BorderRadius.circular(10),
// ),
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Container(
// width: 60,
// height: 60,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// border: Border.all(color: Colors.black),
// image:
// (widget.image.trim().isNotEmpty)
// ? DecorationImage(
// image: NetworkImage(widget.image),
// fit: BoxFit.cover,
// )
//     : null,
// ),
// child:
// (widget.image.trim().isEmpty)
// ? const Icon(Icons.person, size: 40)
//     : null,
// ),
//
// SizedBox(height: 10),
// Column(
// children: [
// Text(widget.name, style: const TextStyle(fontSize: 20)),
// const SizedBox(width: 10),
// Text(
// widget.role,
// style: TextStyle(fontSize: 16, color: Colors.deepPurple),
// ),
// ],
// ),
// // Row(
// //   children: [
// //     Text("Status : "),
// //     Text(
// //       widget.status,
// //       style: TextStyle(
// //         color:
// //             widget.status.toLowerCase() == "active"
// //                 ? Colors.green
// //                 : Colors.red,
// //         fontWeight: FontWeight.bold,
// //       ),
// //     ),
// //   ],
// // ),
// ],
// ),
// const SizedBox(width: 15),
// Expanded(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// // Row(
// //   children: [
// //     Text(widget.name, style: const TextStyle(fontSize: 20)),
// //     const SizedBox(width: 10),
// //     Text(
// //       '( ${widget.role} )',
// //       style: TextStyle(
// //         fontSize: 16,
// //         color: Colors.deepPurple,
// //       ),
// //     ),
// //   ],
// // ),
// SizedBox(height: 10),
// // Row(
// //   children: [
// //     const Text("Open - ", style: TextStyle(fontSize: 15)),
// //     Text(
// //       '${widget.target}',
// //       style: const TextStyle(fontSize: 15),
// //     ),
// //     const SizedBox(width: 30),
// //     Text(
// //       "Completed - ",
// //       style: TextStyle(fontSize: 15, color: Colors.green),
// //     ),
// //     Text(
// //       '${widget.completed}',
// //       style: const TextStyle(fontSize: 15),
// //     ),
// //   ],
// // ),
// // const SizedBox(height: 8),
// // Row(
// //   children: [
// //     Text(
// //       "No response - ",
// //       style: TextStyle(fontSize: 15, color: Colors.blue),
// //     ),
// //     Text(
// //       '${widget.noResponse}',
// //       style: const TextStyle(fontSize: 15),
// //     ),
// //     const SizedBox(width: 30),
// //     Text(
// //       "Close - ",
// //       style: TextStyle(fontSize: 15, color: Colors.red),
// //     ),
// //     Text(
// //       '${widget.close}',
// //       style: const TextStyle(fontSize: 15),
// //     ),
// //   ],
// // ),
// ],
// ),
// ),
//
// Column(
// crossAxisAlignment: CrossAxisAlignment.end,
// children: [
// Row(
// // crossAxisAlignment: CrossAxisAlignment.end,
// // mainAxisAlignment: MainAxisAlignment.end,
// children: [
// Container(
// width: 100,
// height: 30,
// alignment: Alignment.center,
// decoration: BoxDecoration(
// color:
// widget.status.toLowerCase() == "active"
// ? Colors.green
//     : Colors.red,
// borderRadius: BorderRadius.only(
// bottomLeft: Radius.circular(15),
// topRight: Radius.circular(15),
// ),
// ),
// child: Text(
// widget.status,
// style: TextStyle(
// color: Colors.white,
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ],
// ),
// Center(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Row(
// children: [
// const Text("Open - ", style: TextStyle(fontSize: 15)),
// Text(
// '${widget.target}',
// style: const TextStyle(fontSize: 15),
// ),
// const SizedBox(width: 30),
// Text(
// "Completed - ",
// style: TextStyle(fontSize: 15, color: Colors.green),
// ),
// Text(
// '${widget.completed}',
// style: const TextStyle(fontSize: 15),
// ),
// ],
// ),
// const SizedBox(height: 8),
// Row(
// children: [
// Text(
// "No response - ",
// style: TextStyle(fontSize: 15, color: Colors.blue),
// ),
// Text(
// '${widget.noResponse}',
// style: const TextStyle(fontSize: 15),
// ),
// const SizedBox(width: 30),
// Text(
// "Close - ",
// style: TextStyle(fontSize: 15, color: Colors.red),
// ),
// Text(
// '${widget.close}',
// style: const TextStyle(fontSize: 15),
// ),
// ],
// ),
// ],
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// );
