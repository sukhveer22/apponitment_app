import 'package:app_apponitmnet/doctor/screens/profile_screens/contact-support-screen.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:get/get.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Help",
          style: AppTextStyles.title,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Help & Support",
                style: AppTextStyles.header.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Welcome to the Help & Support section. Here you can find answers to frequently asked questions, get support, or contact us for additional help.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "1. **FAQs**",
                style: AppTextStyles.header.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Find answers to common questions and issues related to our services.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "2. **Contact Support**",
                style: AppTextStyles.header.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "If you need further assistance, you can reach out to our support team via email or phone.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: CustomButton(
                  text: "Contact Support",
                  onPressed: () {
                    Get.to(ContactSupportScreen());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
