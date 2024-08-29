import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/role_method/select_role_screen.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import '../doctor_login.dart';

class AccountDeleteScreen extends StatelessWidget {
  const AccountDeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text("Delete Account", style: AppTextStyles.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              onPressed: () async {
                await _deleteAccount(context);
                Get.to(SelectRoleScreen());
              },
              text: "Delete Account",
            ),
            SizedBox(height: 10.h),
            CustomButton(
              onPressed: () {
                Get.back(); // Navigate back to the settings screen
              },
              text: 'Cancel',
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar(
        'Error',
        'No user is currently logged in',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection('Users')
          .doc(user.uid)
          .delete();
      await user.delete();
      Get.snackbar(
        'Success',
        'Account and data deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to the role selection screen
      Get.off(() => SelectRoleScreen());
    } catch (e) {
      print('Error deleting account: $e');
      Get.snackbar(
        'Error',
        'Failed to delete account and data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
