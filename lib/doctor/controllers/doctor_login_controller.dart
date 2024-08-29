import 'package:app_apponitmnet/doctor/screens/dahsborad/doctor-dashborad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/get_rx.dart';

class DoctorLoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observables
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  // Method to handle login
  Future<void> login() async {
    if (isLoading.value) return; // Prevent multiple submissions

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    isLoading.value = true;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (userCredential.user?.email != null) {
        Get.off(DoctorDashboard());
        Get.snackbar('Success', 'Login successful');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to login: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
