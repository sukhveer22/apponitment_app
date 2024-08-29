import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DoctorScheduleController extends GetxController {
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var selectedStartTime = Rxn<TimeOfDay>();
  var selectedEndTime = Rxn<TimeOfDay>();
  var saveDataLoading = false.obs; // Make it observable

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  void setStartTime(TimeOfDay? time) {
    selectedStartTime.value = time;
  }

  void setEndTime(TimeOfDay? time) {
    selectedEndTime.value = time;
  }

  Future<void> saveToFirebase(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Check if any date or time is empty
    if (startDate.value == null ||
        endDate.value == null ||
        selectedStartTime.value == null ||
        selectedEndTime.value == null) {
      Get.snackbar(
        'Error',
        'Please select both date and time',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    saveDataLoading.value = true; // Set loading state

    // Format dates and times
    final String formattedStartDate = DateFormat('MM-dd-yyyy').format(startDate.value);
    final String formattedEndDate = DateFormat('MM-dd-yyyy').format(endDate.value);
    final String? formattedStartTime = selectedStartTime.value?.format(context);
    final String? formattedEndTime = selectedEndTime.value?.format(context);

    // Combine date and time for comparison
    final DateTime startDateTime = DateTime(
      startDate.value.year,
      startDate.value.month,
      startDate.value.day,
      selectedStartTime.value?.hour ?? 0,
      selectedStartTime.value?.minute ?? 0,
    );

    final DateTime endDateTime = DateTime(
      endDate.value.year,
      endDate.value.month,
      endDate.value.day,
      selectedEndTime.value?.hour ?? 0,
      selectedEndTime.value?.minute ?? 0,
    );

    // Compare dates and times
    if (startDateTime.isBefore(endDateTime)) {
      try {
        await FirebaseFirestore.instance.collection('Users').doc(userId).set({
          'startDate': formattedStartDate,
          'endDate': formattedEndDate,
          'startTime': formattedStartTime ?? '',
          'endTime': formattedEndTime ?? '',
        }, SetOptions(merge: true));

        Get.snackbar(
          'Success',
          'Data saved successfully',
          snackPosition: SnackPosition.TOP,
        );
        Navigator.pop(context);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to save data',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        saveDataLoading.value = false; // Reset loading state
      }
    } else {
      Get.snackbar(
        'Error',
        'End date and time must be after start date and time',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      saveDataLoading.value = false; // Reset loading state
    }
  }


}
