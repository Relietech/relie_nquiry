import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_constants.dart';
import 'app_text_styles.dart';

class AppTextFields {
  /// Text field for login page

  /// app text field
  static Widget textFormField({
    required BuildContext context,
    required TextEditingController controller,
    FocusNode? focusNode,
    double? size,
    bool enabled = true,
    String? hintText,
    String? labelText,
    GestureTapCallback? onTap,
    IconData? suffixIcon,
    int? maxLines,
    int? minLines,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    int? maxLength,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return SizedBox(
      width: size,

      child: TextFormField(
        inputFormatters: inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        cursorColor: AppColors.white,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        enabled: enabled,
        style: AppTextStyles.black14bold,
        onTap: onTap,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          suffixIcon:
              suffixIcon != null
                  ? Icon(suffixIcon, color: AppColors.black)
                  : null,
          fillColor: AppColors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.appColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.red, width: 0.09),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.red, width: 0.5),
          ),
        ),
      ),
    );
  }

  ///app text field with heading

  static Widget textFormFieldHeading({
    required BuildContext context,
    required TextEditingController controller,
    FocusNode? focusNode,

    bool enabled = true,
    String? hintText,
    bool obscureText = false,
    required String headingText,
    double? size,
    String? labelText,
    GestureTapCallback? onTap,
    Widget? suffixIcon,
    int? maxLines,
    int? minLines,
    bool readOnly = false,
    Function(String)? onChanged,

    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    int? maxLength,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headingText, style: AppTextStyles.black16bold),
        SizedBox(height: 6),
        SizedBox(
          width: size,

          child: TextFormField(
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: AppColors.black,
            controller: controller,
            onFieldSubmitted: onFieldSubmitted,
            enabled: enabled,
            style: AppTextStyles.black16,
            onTap: onTap,
            readOnly: readOnly,

            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onChanged: onChanged,

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              labelText: labelText,
              labelStyle: const TextStyle(color: Colors.grey),
              suffixIcon: suffixIcon,

              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.black, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: AppColors.appColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColors.red, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// dummy function

  static dummyFunction() {}

  /// text field with suffix icon
  static Widget textFormFieldDate({
    required BuildContext context,
    required TextEditingController controller,
    hintText = "",
    enabled = true,
    String? headingText,
    double? size,

    List<TextInputFormatter>? inputFormatters,
    typingEnabled = true,
    required Icon icon,
    onTextFieldPressed = false,
    Function() onPressed = dummyFunction,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppConstants.appSizedBoxHeight,
        SizedBox(
          width: size,

          child: TextFormField(
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            style: TextStyle(color: Colors.black54),
            controller: controller,
            cursorColor: AppColors.black,

            onTap: onTextFieldPressed ? onPressed : dummyFunction,
            validator: validator,
            keyboardType:
                !typingEnabled ? TextInputType.none : TextInputType.text,
            showCursor: !typingEnabled ? false : true,
            enableInteractiveSelection: !typingEnabled ? false : true,
            decoration: InputDecoration(
              hintText: hintText,
              enabled: enabled,
              isDense: true,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              fillColor: AppColors.appColor.withOpacity(0.05),
              filled: true,
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: InkWell(onTap: onPressed, child: icon),
            ),
          ),
        ),
      ],
    );
  }
}
