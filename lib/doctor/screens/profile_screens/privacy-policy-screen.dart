import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Privacy Policy",
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
                "Privacy Policy",
                style: AppTextStyles.header.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Your privacy is important to us. This privacy statement explains the personal data our app processes, how we process it, and for what purposes.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "1. **Data Collection**\n\nWe collect personal data you provide to us directly, such as your name, email address, phone number, and other contact details.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "2. **Data Usage**\n\nWe use the data we collect to provide, improve, and personalize our services, communicate with you, and comply with legal obligations.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "3. **Data Sharing**\n\nWe do not share your personal data with third parties without your consent, except as required by law or as necessary to provide our services.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "4. **Security**\n\nWe implement various security measures to protect your data from unauthorized access, use, or disclosure.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "5. **Changes to this Policy**\n\nWe may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "If you have any questions about this privacy policy, please contact us at [your-email@example.com].",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
