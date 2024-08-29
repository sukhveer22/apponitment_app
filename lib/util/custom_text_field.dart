import 'package:app_apponitmnet/util/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLine;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool isPasswordHidden;
  final VoidCallback? togglePasswordVisibility;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Widget? prefixIcon;
  final TextStyle? helperStyle;
  final TextStyle? floatingLabelStyle;
  final TextStyle? hintStyle;
  final TextStyle? counterStyle;

  CustomTextField({
    required this.controller,
    this.hintText,
    this.isPassword = false,
    this.isPasswordHidden = false,
    this.togglePasswordVisibility,
    this.onChanged,
    this.validator,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.prefixIcon,
    this.keyboardType,
    this.maxLine = 1,
    this.helperStyle,
    this.floatingLabelStyle,
    this.hintStyle,
    this.counterStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLine,
      obscureText: isPassword ? isPasswordHidden : false,
      decoration: InputDecoration(
        hintText: hintText,
        helperStyle: helperStyle ?? TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700
        ),
        floatingLabelStyle: floatingLabelStyle ?? TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700
        ),
        hintStyle: hintStyle ?? TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700
        ),
        prefixIcon: prefixIcon,
        counterStyle: counterStyle ?? TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            color: Colors.black,
            isPasswordHidden ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: togglePasswordVisibility,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 2.w,
            color: borderColor ?? Colors.black87,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 2.w,
            color: borderColor ?? Colors.black87,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 2.w,
            color: focusedBorderColor ?? AppColors.primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 2.w,
            color: errorBorderColor ?? Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 2.w,
            color: errorBorderColor ?? Colors.red,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
