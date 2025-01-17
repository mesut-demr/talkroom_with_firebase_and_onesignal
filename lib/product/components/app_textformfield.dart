import 'package:comment_system/product/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//? app textformfield
class AppTextFormField extends StatelessWidget {
  final String? Function(String?) validator;
  final TextEditingController controller;
  final String? labelText;
  final Color? labelColor;
  final Color? textColor;
  final Color? errorColor;
  final Color? focusedErrorColor;
  final Color? enabledColor;
  final Color? focusedColor;
  final Widget? suffixIcon;
  final bool obscureText;
  final String obscuringCharacter;
  final String? hintText;
  final TextInputType? keyboardType;
  final double? height;
  final double? width;
  final int? maxLength;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? minLines;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;

  const AppTextFormField({
    super.key,
    required this.validator,
    required this.controller,
    this.labelText,
    this.labelColor,
    this.textColor,
    this.errorColor,
    this.focusedErrorColor,
    this.enabledColor,
    this.focusedColor,
    this.suffixIcon,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.hintText,
    this.keyboardType,
    this.height,
    this.width,
    this.maxLength,
    this.prefixIcon,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 0.07.sh,
      width: width ?? 1.sw,
      child: TextFormField(
        textInputAction: textInputAction,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: textColor),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            prefixIcon: prefixIcon,
            fillColor: const Color.fromARGB(255, 196, 208, 231),
            filled: true,
            suffixIcon: suffixIcon,
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r), borderSide: BorderSide(color: errorColor ?? redColor, width: 0)),
            focusedErrorBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(6.r), borderSide: BorderSide(color: focusedErrorColor ?? darkBlueColor, width: 0)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r), borderSide: BorderSide(color: enabledColor ?? darkBlueColor, width: 0)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r), borderSide: BorderSide(color: focusedColor ?? darkBlueColor, width: 1)),
            labelText: labelText,
            hintText: hintText,
            hintStyle: TextStyle(color: lightBlackColor, fontSize: 8.sp, fontWeight: FontWeight.w300),
            labelStyle: TextStyle(
              color: labelColor,
              fontSize: 10.sp,
            ),
            errorStyle: TextStyle(color: redColor, fontSize: 8.sp, fontWeight: FontWeight.bold)),
        onChanged: onChanged,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
      ),
    );
  }
}
