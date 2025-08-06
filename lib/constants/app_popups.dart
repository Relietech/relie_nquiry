import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppPopups {
  /// circular progress indicator
  static circularProgressIndicator(BuildContext context) {
    return showDialog(
      context: context,
      builder:
          (context) => Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: AppColors.appColor),
          ),
    );
  }

  /// information popup
  static infoPopup({required BuildContext context, required String title}) {
    return showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                Text(title, style: AppTextStyles.showDialogTitleStyle),
                const SizedBox(height: 20),
              ],
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.appColor),
                ),

                onPressed: () {
                  Get.back();
                },
                child: Text("Ok", style: AppTextStyles.white16bold),
              ),
            ],
          ),
    );
  }

  /// information  popup with onPressed
  static infoPopupWithOnPressed({
    required BuildContext context,
    required String title,
    required VoidCallback? onPressed,
  }) {
    return showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                Text(title, style: AppTextStyles.showDialogTitleStyle),
                const SizedBox(height: 20),
              ],
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.appColor),
                ),

                onPressed: onPressed,
                child: const Text("Ok", style: AppTextStyles.white16bold),
              ),
            ],
          ),
    );
  }

  /// conformation popup
  static conformationPopup({
    required BuildContext context,
    required String title,
    required VoidCallback? onPressed,
  }) {
    return showCupertinoModalPopup(
      barrierColor: Colors.black45,
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                Text(title, style: AppTextStyles.showDialogTitleStyle),
                const SizedBox(height: 20),
              ],
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.green.shade100,
                  ),
                ),
                onPressed: onPressed,
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red.shade100),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "No",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Option popup
  static optionPopup({
    required BuildContext context,
    required String title,
    List<Widget>? actions,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                Text(title, style: AppTextStyles.showDialogTitleStyle),
                const SizedBox(height: 20),
              ],
            ),
            actions: actions,
          ),
    );
  }

  static rejectionsPopup(
    BuildContext context,
    VoidCallback onGoBack,
    Function(String) onReject,
  ) {
    final List<String> _reasons = ['Vehicle Issue', 'Personal Issue', 'Other'];
    String? _selectedReason;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(15),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Red header bar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Penalty may be applicable. Select the Reasons to Reject the Ride',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Radio options
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children:
                            _reasons.map((reason) {
                              return RadioListTile<String>(
                                title: Text(
                                  reason,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                value: reason,
                                groupValue: _selectedReason,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedReason = value;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Go Back button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Go Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Reject Ride button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: OutlinedButton(
                        onPressed:
                            _selectedReason != null
                                ? () => onReject(_selectedReason!)
                                : null,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          side: const BorderSide(color: Colors.red, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Reject Ride',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
