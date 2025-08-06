import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:relie_nquiry/constants/app_button.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:relie_nquiry/constants/app_funtion.dart';
import 'package:relie_nquiry/constants/app_popups.dart';
import 'package:relie_nquiry/constants/app_text_styles.dart';
import 'package:relie_nquiry/constants/text_fields.dart' show AppTextFields;
import 'package:relie_nquiry/constants/uppercase_formatter.dart';
import 'package:relie_nquiry/routes/app_routes.dart';

class ProfileEditPage extends StatefulWidget {
  // final snapshot;
  //
  // const ProfileEditPage({super.key, required this.snapshot});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final profileFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final designationController = TextEditingController();

  String _imageFile = "";

  Future<void> editProfile() async {
    AppPopups.circularProgressIndicator(context);

    final docRef = FirebaseFirestore.instance
        .collection("subscription")
        .doc(AppConstants.companyName)
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid);

    final doc = await docRef.get();
    final oldData = doc.data();

    String oldImageUrl = oldData?['image_path'] ?? "";
    String newImageUrl = _imageFile;

    if (newImageUrl.isEmpty) {
      newImageUrl = oldImageUrl;
    }

    final newName = nameController.text.trim();
    final newMobile = mobileController.text.trim();
    final newAddress = addressController.text.trim();
    final newDesignation = designationController.text.trim();

    // Compare with existing values
    final noChanges =
        (oldData?['name'] ?? "") == newName &&
        (oldData?['mobile'] ?? "") == newMobile &&
        (oldData?['address'] ?? "") == newAddress &&
        (oldData?['designation'] ?? "") == newDesignation &&
        oldImageUrl == newImageUrl;

    if (noChanges) {
      Navigator.pop(context);
      AppPopups.infoPopup(context: context, title: "No changes made");
      return;
    }

    // Build only changed fields
    Map<String, dynamic> updates = {};

    if ((oldData?['name'] ?? "") != newName) updates['name'] = newName;
    if ((oldData?['mobile'] ?? "") != newMobile) updates['mobile'] = newMobile;
    if ((oldData?['address'] ?? "") != newAddress)
      updates['address'] = newAddress;
    if ((oldData?['designation'] ?? "") != newDesignation)
      updates['designation'] = newDesignation;
    if (oldImageUrl != newImageUrl) updates['image_path'] = newImageUrl;

    await docRef
        .update(updates)
        .then((_) {
          Navigator.pop(context);
          AppPopups.infoPopupWithOnPressed(
            context: context,
            onPressed: () {
              Get.offNamed('/profile');
              // Get.toNamed(
              //   Routes.profile,
              // );
            },
            title: "Updated Successfully",
          );
        })
        .catchError((error) {
          Navigator.pop(context);
          AppPopups.infoPopup(context: context, title: "Update failed");
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userDoc = Get.arguments;
    nameController.text = userDoc['name'];
    mobileController.text = userDoc['mobile'];
    designationController.text = userDoc['designation'];
    addressController.text = userDoc['address'];
    _imageFile = userDoc["image_path"];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: profileFormKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.themeBlue,
                  // gradient: LinearGradient(
                  //   colors: [
                  //     Color(0xFF229CB8),
                  //     Color(0xFF2098B3),
                  //     Color(0xFF13859f),
                  //     Color(0xFF066a81),
                  //   ],
                  //   begin: Alignment.centerRight,
                  //   end: Alignment.centerLeft,
                  // ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back button aligned to the start (left)
                    Row(
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
                      ],
                    ),
                    // Centered text
                    const Center(
                      child: Text(
                        "Edit Personal Info.",
                        style: AppTextStyles.appBarWhite21bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          // onTap: () async {
                          //   String? imageUrl =
                          //       await AppFunctions.pickImageWithoutCrop(
                          //         pathName: 'UserImages',
                          //         context: context,
                          //       );
                          //
                          //   if (imageUrl != null) {
                          //     print("Image uploaded: $imageUrl");
                          //     setState(
                          //       () => _imageFile = imageUrl,
                          //     ); // if you need to show it
                          //   } else {
                          //     print("Image selection canceled or failed.");
                          //   }
                          //   setState(() {});
                          // },
                          onTap: () async {
                            String? croppedFile =
                            await AppFunctions.pickImageWithImageCropper(
                              pathName: "MemberImage",
                              context: context,
                              cropStyle: CropStyle.rectangle,
                            );
                            setState(() => _imageFile = croppedFile!);
                            setState(() {});
                          },
                          child: Container(
                            height: 140,
                            width: 140,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child:
                                _imageFile == ""
                                    ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.cloud_upload,
                                          color: Colors.grey.shade500,),
                                        Text(textAlign: TextAlign.center,
                                          "Upload image",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        _imageFile,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        /// Name
                        AppTextFields.textFormFieldHeading(
                          context: context,
                          controller: nameController,
                          headingText: "Name",
                          inputFormatters: [UpperCaseTextFormatter()],
                          hintText: "Enter name",
                        ),
                        const SizedBox(height: 10),

                        /// Designation
                        AppTextFields.textFormFieldHeading(
                          context: context,
                          controller: designationController,
                          headingText: "Designation",
                        ),
                        const SizedBox(height: 10),

                        /// Mobile
                        AppTextFields.textFormFieldHeading(
                          context: context,
                          controller: mobileController,
                          headingText: "Phone",
                          hintText: "Enter phone number",

                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter phone";
                            }
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return "Enter valid 10-digit number";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        /// Address
                        AppTextFields.textFormFieldHeading(
                          context: context,
                          controller: addressController,
                          headingText: "Address",
                          hintText: "Enter address",
                          maxLines: 3,
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            child: AppButton.AppCustomButton(
                              paddingVertical: 8,
                              paddingHorizontal: 20,
                             // width: 100,
                              onTap: () {
                                editProfile();
                              },
                              text: "Submit",
                              style: AppTextStyles.white20bold,
                              color: AppColors.appColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
