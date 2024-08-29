import 'package:app_apponitmnet/doctor/controllers/change-password-controller.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:app_apponitmnet/util/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  ChangePasswordController changePasswordController =
      Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text("Change Password", style: AppTextStyles.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: changePasswordController.currentPasswordController,
                hintText: 'Current Password',
                isPassword: true,
                borderColor: AppColors.primaryColor,
                togglePasswordVisibility:
                    changePasswordController.togglePasswordVisibility,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: changePasswordController.newPasswordController,
                hintText: 'New Password',
                isPassword: true,
                borderColor: AppColors.primaryColor,
                togglePasswordVisibility:
                    changePasswordController.togglePasswordVisibility,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: changePasswordController.confirmPasswordController,
                hintText: 'Confirm New Password',
                isPassword: true,
                borderColor: AppColors.primaryColor,
                togglePasswordVisibility:
                    changePasswordController.togglePasswordVisibility,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value !=
                      changePasswordController.newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 70.h),
              CustomButton(
                onPressed: () {
                  changePasswordController.changePassword(_formKey);
                },
                text: "Change Password",
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty(
        'ChangePasswordController', ChangePasswordController));
  }
}
