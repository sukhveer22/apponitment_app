import 'package:app_apponitmnet/doctor/screens/doctor-notes-screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/models/appointent_model.dart';
import 'package:app_apponitmnet/models/chat_model.dart';
import 'package:app_apponitmnet/models/doctor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../util/app_color.dart';
import 'chat-room_controller.dart';

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
  RxBool buttonname = false.obs;
  User? firebaseuid = FirebaseAuth.instance.currentUser;

  // Removed ChatRoomModel as it's not needed for appointment saving

  @override
  void onInit() {
    super.onInit();
    dataDoctors(idDoctors.value);
    // Ensure chatroom is initialized here or when needed
    getChatRoomModel(idDoctors.value);
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

  void _onAppointmentBooked() {
    Get.defaultDialog(
      title: 'Success',
      titleStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w900,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: ClipRRect(
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfz3upZJUzgki4bn27faJf6gPIIo7Yo5HxZg&s',
                // Replace with your image URL
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Appointment booked successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textColor),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Get.back();
              // buttonname.value = true;
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      barrierDismissible: false,
      radius: 10,
      contentPadding: EdgeInsets.all(20),
    );
  }

  Future<void> saveAppointmentToFirestore(AppointmentModel appointment,
      String doctoruid, String appointmentId) async {
    final chatroomModel = await getChatRoomModel(doctoruid);

    try {
      final appointmentRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc(doctoruid + appointmentId); // Use doctoruid for document ID
      await appointmentRef.set(appointment.toMap());
      _onAppointmentBooked();
    } catch (e) {
      print(e);
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
      required String userImage,
      required String doctorName,
      required String doctoruid}) async {
    if (selectedTime.isEmpty) {
      Get.snackbar('Error', 'Please select a time.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (firebaseuid?.photoURL == null) {
      Get.snackbar(
        "Error",
        "User Image null",
      );
      return;
    }
    AppointmentModel appointment = AppointmentModel(
      isConfirmed: false,
      appointmentId: firebaseuid?.uid.toString(),
      doctorImage: doctorImage,
      userImage: userImage,
      userName: firebaseuid?.displayName.toString(),
      doctorName: doctorName ?? '',
      appointmentDate: selectedDate.toString(),
      appointmentTime: selectedTime,
      doctorId: doctoruid,
    );

    await saveAppointmentToFirestore(
        appointment, doctoruid, firebaseuid!.uid.toString());
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
