import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppButton {
  /// AppMaterialButton

  static MaterialButton AppMaterialButton({
    required Function()? onPressed,
    required String text,
    required TextStyle? style,
    required Color? color,
    double? height,
    double? elevation,
    double paddingVertical = 0.0,
    double paddingHorizontal = 0.0,
  }) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(
        vertical: paddingVertical,
        horizontal: paddingHorizontal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: elevation,
      onPressed: onPressed,
      color: color,
      child: Text(text, style: style),
    );
  }

  static MaterialButton AppSubmitButton({
    required Function()? onPressed,
    required String text,
    // required TextStyle? style,
    // required Color? color,
    // double? height,
    double? elevation,
    double paddingVertical = 0.0,
    double paddingHorizontal = 0.0,
  }) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(
        vertical: paddingVertical,
        horizontal: paddingHorizontal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: elevation,
      onPressed: onPressed,
      color: AppColors.appColor,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// AppCustomButtonAppButton.AppCustomButton(

  static Widget AppCustomButton({
    required Function()? onTap,
    required String text,
    required TextStyle? style,
    required Color? color,
    double? width,
    double? height,
    double paddingVertical = 0.0,
    double paddingHorizontal = 0.0,
  }) {
    return InkWell(
      overlayColor: MaterialStatePropertyAll<Color>(Colors.transparent),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
        decoration: BoxDecoration(
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
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(text, style: style),
      ),
    );
  }
}
