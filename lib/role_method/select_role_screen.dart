import 'package:app_apponitmnet/doctor/screens/doctor_login.dart';
import 'package:app_apponitmnet/doctor/screens/doctor_sign-up.dart';
import 'package:app_apponitmnet/patient/screens/sign_screen.dart';
import 'package:app_apponitmnet/role_method/select_role_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:app_apponitmnet/patient/screens/login_screen.dart'; // Import your login screen

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectRoleController selectRoleController =
        Get.put(SelectRoleController());

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        width: AppConfig.screenWidth,
        color: AppColors.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select Your Role",
              style: TextStyle(
                fontSize: 22.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30.h),
            Container(
              height: AppConfig.screenHeight * 0.6,
              width: AppConfig.screenWidth * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Doctor Role Selection
                  GestureDetector(
                    onTap: () {
                      selectRoleController.selectRole(UserRole.doctor);
                    },
                    child: Obx(() => Container(
                      height:170.h,
                          width: AppConfig.screenWidth * 0.5,
                          decoration: BoxDecoration(
                            color: selectRoleController.selectedRole.value ==
                                    UserRole.doctor
                                ? Colors.deepPurpleAccent.withAlpha(30)
                                : Colors.white,
                            border: Border.all(
                              color: selectRoleController.selectedRole.value ==
                                      UserRole.doctor
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/role_doctor.png',
                                height: 70.h,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "I'm a Doctor",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      selectRoleController.selectedRole.value ==
                                              UserRole.doctor
                                          ? AppColors.primaryColor
                                          : Colors.grey,
                                ),
                              ),
                              if (selectRoleController.selectedRole.value ==
                                  UserRole.doctor)
                                Icon(Icons.check_circle,
                                    color: AppColors.primaryColor, size: 20.sp),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(height: 25.h),
                  // Patient Role Selection
                  GestureDetector(
                    onTap: () {
                      selectRoleController.selectRole(UserRole.patient);
                    },
                    child: Obx(() => Container(
                          height:170.h,
                          width: AppConfig.screenWidth * 0.5,
                          decoration: BoxDecoration(
                            color: selectRoleController.selectedRole.value ==
                                    UserRole.patient
                                ? Colors.deepPurpleAccent.withAlpha(30)
                                : Colors.white,
                            border: Border.all(
                              color: selectRoleController.selectedRole.value ==
                                      UserRole.patient
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/role_patient.png',
                                height: 70.h,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "I'm a Patient",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      selectRoleController.selectedRole.value ==
                                              UserRole.patient
                                          ? AppColors.primaryColor
                                          : Colors.grey,
                                ),
                              ),
                              if (selectRoleController.selectedRole.value ==
                                  UserRole.patient)
                                Icon(Icons.check_circle,
                                    color: AppColors.primaryColor, size: 20.sp),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            CustomButton(
              text: "Proceed",
              textColor: AppColors.primaryColor,
              fontSize: 20.sp,
              width: AppConfig.screenWidth * 0.6,
              color: Colors.white,
              onPressed: () {
                if (selectRoleController.selectedRole.value != null) {
                  if (selectRoleController.selectedRole.value ==
                      UserRole.doctor) {
                    Get.to(() => DoctorSign());
                  } else {
                    Get.to(SignUpScreen());
                  }
                } else {
                  Get.snackbar(
                    'Error',
                    'Please select a role',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: TextButton(
          onPressed: () {
            if (selectRoleController.selectedRole.value != null) {
              if (selectRoleController.selectedRole.value ==
                  UserRole.doctor) {
                Get.to(() => DoctorLogin());
              } else {
                Get.to(LoginScreen());
              }
            } else {
              Get.snackbar(
                'Error',
                'Please select a role',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: Text(
            "Already have an account? Login",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
