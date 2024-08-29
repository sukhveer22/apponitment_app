import 'package:app_apponitmnet/util/app_config.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/custom_text_field.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Contact Support",
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
                "Contact Us",
                style: AppTextStyles.header.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "If you need assistance, please fill out the contact form below, and our support team will get back to you as soon as possible.",
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: nameController,
                hintText: "Name",
                borderColor: AppColors.primaryColor,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                borderColor: AppColors.primaryColor,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: messageController,
                hintText: "Message",
                maxLine: 5,
                borderColor: AppColors.primaryColor,
              ),
              SizedBox(height: 20.h),
              Center(
                child: CustomButton(
                  text: "Send Message",
                  onPressed: () {},
                  color: AppColors.primaryColor,
                  textColor: Colors.white,
                  width: AppConfig.screenWidth * 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
