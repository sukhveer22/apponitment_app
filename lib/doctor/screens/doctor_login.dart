import 'package:app_apponitmnet/doctor/controllers/doctor_login_controller.dart';
import 'package:app_apponitmnet/doctor/screens/doctor_sign-up.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:app_apponitmnet/util/custom_text_field.dart';
import 'package:app_apponitmnet/util/extension_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DoctorLogin extends StatelessWidget {
  final DoctorLoginController controller = Get.put(DoctorLoginController());

  DoctorLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                Image(
                  image: AssetImage(
                    "assets/login-removebg-preview.png",
                  ),
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 25.h),
                _buildTextField(
                    'Email', controller.emailController, 'Enter your Email',
                    condd: controller),
                _buildTextField('Password', controller.passwordController,
                    'Enter your Password',
                    isPassword: true, condd: controller),
                SizedBox(height: 20.h),
                Center(
                  child: Obx(
                    () => CustomButton(
                      text: 'Log In',
                      color: Colors.white,
                      onPressed: controller.login,
                      isLoading: controller.isLoading.value,
                      textStyle: AppTextStyles.header,
                      textColor: Colors.black,
                      fontSize: 20,
                    ),
                  ).withSymmetricPadding(vertical: 20.h),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account? ',
                        style: AppTextStyles.header,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => DoctorSign());
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.header.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {int maxLines = 1,
      bool isPassword = false,
      required DoctorLoginController condd}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.header,
        ).paddingOnly(bottom: 5.h),
        CustomTextField(
          togglePasswordVisibility: condd.isPasswordHidden,
          focusedBorderColor: Colors.white,
          borderColor: Colors.white,
          controller: controller,
          hintText: hint,
          maxLine: maxLines,
          isPassword: isPassword,
          hintStyle: AppTextStyles.hint,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
