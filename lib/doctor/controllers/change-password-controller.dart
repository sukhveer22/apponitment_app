import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  RxBool isPasswordHidden = true.obs;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> changePassword(formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      // Show success message
      Get.snackbar(
        'Success',
        'Password updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back to the previous screen
      Get.back();
    } catch (e) {
      print('Error changing password: $e');
      Get.snackbar(
        'Error',
        'Failed to update password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
