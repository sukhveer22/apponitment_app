import 'dart:io';
import 'package:app_apponitmnet/doctor/controllers/doctor_sgin_controller.dart';
import 'package:app_apponitmnet/doctor/controllers/doctor_sgin_controller.dart';
import 'package:app_apponitmnet/doctor/controllers/doctor_sgin_controller.dart';
import 'package:app_apponitmnet/role_method/select_role_controller.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:app_apponitmnet/util/custom_text_field.dart';
import 'package:app_apponitmnet/util/extension_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/doctor_sgin_controller.dart';
import '../controllers/doctor_sgin_controller.dart';
import '../controllers/doctor_sgin_controller.dart';
import 'doctor_login.dart';

class DoctorSign extends StatelessWidget {
  final DoctorSignController controller = Get.put(DoctorSignController());
  final SelectRoleController userrole = Get.put(SelectRoleController());

  DoctorSign({super.key});

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>${userrole.selectedRole}");
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
                SizedBox(height: 10),
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
                  image: AssetImage("assets/welcome-removebg-preview.png"),
                  fit: BoxFit.fitWidth,
                ),
                Center(
                  child: Obx(() {
                    final imageFile = controller.imageFile.value;
                    return Container(
                      width: 100.w,
                      height: 100.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3.w),
                          shape: BoxShape.circle),
                      child: CupertinoButton(
                        onPressed: () {
                          controller.showPhotoOptions();
                        },
                        padding: EdgeInsets.zero,
                        child: imageFile != null
                            ? CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 65.r,
                                backgroundImage:
                                    FileImage(File(imageFile.path)),
                              )
                            : Icon(
                                Icons.image,
                                size: 60.sp,
                                color: Colors.black45,
                              ),
                      ).paddingAll(2),
                    );
                  }).paddingSymmetric(vertical: 10.h),
                ),
                _buildTextField(
                    'Name', controller.nameController, 'Enter your Name'),
                _buildTextField(
                    'Email', controller.emailController, 'Enter your Email'),
                _buildTextField('Specialty', controller.specialtyController,
                    'Enter your Specialty'),
                _buildTextField(
                    'Current Location',
                    controller.locationController,
                    'Enter your Current Location'),
                Text(
                  'Gender',
                  style: AppTextStyles.header,
                ),
                Obx(
                  () => _buildDropdownField(
                    controller.selectedGender.value,
                    controller.setGender,
                    Gender.values,
                  ),
                ),
                _buildTextField(
                  'Age',
                  controller.ageController,
                  'Enter your Age',
                  textInputType: TextInputType.phone,
                ),
                _buildTextField(
                    'Phone Number',
                    controller.phoneNumberController,
                    'Enter your Phone Number',   textInputType: TextInputType.phone,),
                Text(
                  'Category',
                  style: AppTextStyles.header,
                ),
                Obx(
                  () => _buildDropdownField(
                    controller.selectedCategory.value,
                    controller.setCategory,
                    Category.values,
                  ),
                ),
                _buildTextField('Description', controller.specialtyController,
                    'Enter your Description',
                    maxLines: 5),
                SizedBox(height: 10.h),
                Text(
                  "Password",
                ).paddingOnly(bottom: 5.h),
                Obx(
                  () => CustomTextField(
                    controller: controller.passwordController,
                    borderColor: Colors.white,
                    focusedBorderColor: Colors.white,
                    hintText: 'Enter your Password',
                    isPassword: true,
                    isPasswordHidden: controller.isPasswordHidden.value,
                    togglePasswordVisibility:
                        controller.togglePasswordVisibility,
                    hintStyle: AppTextStyles.hint,
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Obx(
                    () => CustomButton(
                      text: 'Sign Up',
                      color: Colors.white,
                      onPressed: controller.signUp,
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
                          Get.to(() => DoctorLogin());
                        },
                        child: Text(
                          'Log In',
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
      {int maxLines = 1, TextInputType? textInputType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.header,
        ).paddingOnly(bottom: 5.h),
        CustomTextField(
          focusedBorderColor: Colors.white,
          borderColor: Colors.white,
          controller: controller,
          hintText: hint,
          maxLine: maxLines,
          keyboardType: textInputType,
          hintStyle: AppTextStyles.hint,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildDropdownField<T>(
    T selectedValue,
    void Function(T) onChanged,
    List<T> values,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          focusColor: AppColors.textColor,
          hoverColor: AppColors.textColor,
          fillColor: AppColors.textColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
            borderSide: BorderSide(
                color: Colors.white, width: 2), // Custom border color and width
          ),
        ),
        value: selectedValue,
        dropdownColor: Colors.white,
        onChanged: (T? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: values.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              value.toString().split('.').last,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
            ),
          );
        }).toList(),
      ),
    );
  }
}
