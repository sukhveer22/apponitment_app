import 'package:app_apponitmnet/doctor/screens/profile_screens/change-password.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/delete-account-screen.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/notificatio-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import '../doctor_login.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text("Settings", style: AppTextStyles.title),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
            ),
            _buildSettingsOption(
              context,
              icon: Icons.lock,
              text: "Change Password",
              onTap: () {
                Get.to(() => ChangePasswordScreen());
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.person,
              text: "Account Delete",
              onTap: () {
                Get.to(() => AccountDeleteScreen());
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.notifications,
              text: "Notification Settings",
              onTap: () {
                Get.to(() => NotificationSettingsScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withAlpha(80),
            ),
            child: Center(
              child: Icon(icon, color: Colors.white),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: AppTextStyles.header,
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios_sharp,
            color: AppColors.primaryColor.withAlpha(80),
          ),
        ],
      ).paddingOnly(bottom: 20.h),
    );
  }
}
