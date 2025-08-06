
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:relie_nquiry/constants/app_colors.dart';

class AppDropDownButton extends StatefulWidget {
  final String hintText;
  final List<String> itemList;
  final double? height;
  final double? width;
  String? selectedValue;
  Widget? label;
  ValueChanged<String?>? onChanged;
  FormFieldValidator<String>? validator;
  bool isSearch;
  Color fillColor;
  Color hoverColor;
  Color focusColor;
  TextStyle? hintStyle;
  TextStyle? labelStyle;

  AppDropDownButton({
    super.key,
    required this.hintText,
    required this.itemList,
    this.width,
    this.height,
    this.selectedValue,
    this.onChanged,
    this.validator,
    this.isSearch = true,
    this.fillColor = AppColors.white,
    this.hoverColor = AppColors.white,
    this.focusColor = AppColors.white,
    this.hintStyle,
    this.labelStyle,
    this.label,
  });

  @override
  State<AppDropDownButton> createState() => _AppDropDownButtonState();
}

class _AppDropDownButtonState extends State<AppDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DropdownButtonFormField2<String>(
        style: TextStyle(fontSize: 16, color: AppColors.black),
        isExpanded: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          // fillColor: widget.fillColor,
          hoverColor: widget.hoverColor,
          focusColor: widget.focusColor,
         // filled: true,
          isDense: true,
          labelStyle: widget.labelStyle,
          label: widget.label,
          hintStyle: widget.hintStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: AppColors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: AppColors.appColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(color: AppColors.black, width: 1),
          ),
        ),
        hint: Text(
          widget.hintText,
          style: widget.hintStyle,
          overflow: TextOverflow.ellipsis,
        ),
        items:
            widget.itemList
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 16, color: AppColors.black),
                    ),
                  ),
                )
                .toList(),
        value: widget.selectedValue,
        validator: widget.validator,
        onChanged: widget.onChanged,
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
          height: 48,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),color: Colors.white),
        ),
        menuItemStyleData: const MenuItemStyleData(

          overlayColor: WidgetStatePropertyAll<Color>(Colors.white),
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
