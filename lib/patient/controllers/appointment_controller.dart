import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/models/appointent_model.dart';
import 'package:app_apponitmnet/models/chat_model.dart';
import 'package:app_apponitmnet/models/doctor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AppointmentController extends GetxController {
  var selectedDate = "".obs;
  var selectedTime = ''.obs;
  var doctors = "".obs;
  var activeDoctors = "".obs;
  var nameDoctors = "".obs;
  var tapDoctors = "".obs;
  var numberDoctors = "".obs;
  var idDoctors = "".obs;
  var doctorData = {}.obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  User? firebaseuid = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
  }

  void setSelectedDate(String date) {
    selectedDate.value = date;
  }

  void setSelectedTime(String time) {
    selectedTime.value = time;
  }

  String generateDoctorId() {
    return FirebaseFirestore.instance.collection('appointments').doc().id;
  }


  Future<void> saveAppointmentToFirestore(
      AppointmentModel appointment, String doctoruid) async {
    try {
      final appointmentRef =
          FirebaseFirestore.instance.collection('appointments').doc(doctoruid);
      await appointmentRef.set(appointment.toMap());

      Get.snackbar('Success', 'Appointment booked successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save appointment: $e',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> saveAppointment(
      {required String selectedDate,
      required String selectedTime,
      required String doctorImage,
      required String doctoruid}) async {
    if (selectedTime.isEmpty) {
      Get.snackbar('Error', 'Please select a time.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    AppointmentModel appointment = AppointmentModel(
      appointmentId: firebaseuid?.uid.toString(),
      doctorImage: doctorImage,
      userImage: firebaseuid?.photoURL.toString(),
      userName: firebaseuid?.displayName.toString(),
      doctorName: doctorData['name'] ?? '',
      appointmentDate: selectedDate.toString(),
      appointmentTime: selectedTime,
      doctorId: doctoruid,
      // Add other fields as needed
    );

    await saveAppointmentToFirestore(appointment, doctoruid);
  }

  Future<bool> isDateAvailable(DateTime selectedDate) async {
    try {
      final appointments =
          await FirebaseFirestore.instance.collection('appointments').get();

      for (var doc in appointments.docs) {
        final appointmentData = doc.data() as Map<String, dynamic>;
        dynamic appointmentDateValue = appointmentData['appointmentDate'];
        DateTime appointmentDate;

        if (appointmentDateValue is Timestamp) {
          appointmentDate = appointmentDateValue.toDate();
        } else if (appointmentDateValue is String) {
          try {
            appointmentDate = DateTime.parse(appointmentDateValue);
          } catch (e) {
            print('Error parsing date: $e');
            continue;
          }
        } else {
          print('Unexpected date type: ${appointmentDateValue.runtimeType}');
          continue;
        }

        if (DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
        ).isAtSameMomentAs(DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        ))) {
          return false;
        }
      }
    } catch (e) {
      print('Error checking date availability: $e');
    }
    return true;
  }

  void dataDoctors(String uid) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data()!;

        activeDoctors.value = data['profilePictureUrl'] as String;
        nameDoctors.value = data['name'] as String;
        tapDoctors.value = data['categoryId'] as String;
        numberDoctors.value = data['phoneNumber'] as String;
        idDoctors.value = data['id'] as String;

        doctors.value = Doctors.fromDocumentSnapshot(snapshot) as String;
      } else {
        print('No data found for doctor with uid: $uid');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }
}
