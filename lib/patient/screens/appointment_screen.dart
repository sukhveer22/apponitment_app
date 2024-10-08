import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/models/chat_model.dart';
import 'package:app_apponitmnet/patient/controllers/chat-room_controller.dart';
import 'package:app_apponitmnet/patient/screens/chat_screen.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/patient/controllers/appointment_controller.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:uuid/uuid.dart';

import '../../util/Date-time-show-class.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorId;

  AppointmentScreen({super.key, required this.doctorId});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late String selectedDates = "";

  String selectedTimes = "";

  User? firebaseuid = FirebaseAuth.instance.currentUser;

  final AppointmentController controller = Get.put(AppointmentController());

  void initState() {
    super.initState();
    _checkAppointment();
  }

  Future<void> _checkAppointment() async {
    var appointmentDoc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.doctorId + firebaseuid!.uid.toString())
        .get();
    if (appointmentDoc.exists) {
      controller.buttonname.value = true;
    } else {
      controller.buttonname.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(widget.doctorId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('Doctor not found'));
              }

              var doctorData = snapshot.data!.data() as Map<String, dynamic>;
              String profilePictureUrl = doctorData["profilePictureUrl"] ?? '';
              String name = doctorData["name"] ?? 'No Name';
              String startDateStr = doctorData["startDate"] ?? '';
              String endDateStr = doctorData["endDate"] ?? '';

              String specialty = doctorData["specialty"] ?? 'No specialty';
              String categoryId = doctorData["categoryId"]
                      ?.toString()
                      .replaceAll("Category.", "") ??
                  'No Category';
              DateTime startDate;
              DateTime endDate;

              try {
                startDate = DateTime.parse(startDateStr);
                endDate = DateTime.parse(endDateStr);
              } catch (e) {
                startDate = DateTime.now();
                endDate = startDate.add(
                    Duration(days: 30)); // Default to 30 days if parse fails
              }

              int totalDays = endDate.difference(startDate).inDays + 1;

              List<int> timeSlots = List.generate(12, (index) => index + 1);

              return Container(
                height: AppConfig.screenHeight,
                width: AppConfig.screenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.topCenter,
                    colors: const [AppColors.primaryColor, Colors.white],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 60),
                    if (profilePictureUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.network(
                          height: 200,
                          profilePictureUrl,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, size: 100.w);
                          },
                        ),
                      )
                    else
                      Icon(Icons.account_circle, size: 100.w),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        width: AppConfig.screenWidth,
                        padding: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 5.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(35.r),
                            topLeft: Radius.circular(35.r),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Name: ",
                                    style: AppTextStyles.header,
                                  ),
                                  Text(
                                    name,
                                    style: AppTextStyles.body,
                                  ),
                                ],
                              ),
                              Divider(),

                              Row(
                                children: [
                                  Text(
                                    "Category: ",
                                    style: AppTextStyles.header,
                                  ),
                                  Text(
                                    categoryId,
                                    style: AppTextStyles.body,
                                  ),
                                ],
                              ),
                              Text(
                                "Specialty:",
                                style: AppTextStyles.header,
                              ),
                              Text(
                                specialty,
                                style: AppTextStyles.body,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(),
                              ),
                              Text(
                                "Select Date:",
                                style: AppTextStyles.header,
                              ),
                              Container(
                                height: 80,
                                width: AppConfig.screenWidth,
                                child: Center(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: totalDays,
                                    itemBuilder: (context, index) {
                                      DateTime date =
                                          startDate.add(Duration(days: index));
                                      return Center(
                                        child: DateCapsule(
                                          date: date,
                                          isSelected: false,
                                          dates: startDate.day + index,
                                          onTap: () {
                                            selectedDates =
                                                "${EasyDateFormatter.shortMonthName(date, "en_US")} ${startDate.day + index} ${EasyDateFormatter.shortDayName(date, "en_US")}";
                                          },
                                        ),
                                      ).paddingSymmetric(horizontal: 10);
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                "Select Time:",
                                style: AppTextStyles.header,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                width: AppConfig.screenWidth,
                                child: Center(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: timeSlots.length,
                                    itemBuilder: (context, index) {
                                      return TimeCapsule(
                                        time: timeSlots[index],
                                        isSelected:
                                            selectedTimes.endsWith('AM') &&
                                                timeSlots[index] ==
                                                    int.parse(selectedTimes
                                                        .split('AM')
                                                        .first),
                                        onTap: () {
                                          selectedTimes =
                                              "${timeSlots[index]}AM";
                                        },
                                        text: 'AM',
                                      ).paddingSymmetric(horizontal: 10);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                width: AppConfig.screenWidth,
                                child: Center(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: timeSlots.length,
                                    itemBuilder: (context, index) {
                                      return TimeCapsule(
                                        time: timeSlots[index],
                                        isSelected:
                                            selectedTimes.endsWith('PM') &&
                                                timeSlots[index] ==
                                                    int.parse(selectedTimes
                                                        .split('PM')
                                                        .first),
                                        onTap: () {
                                          selectedTimes =
                                              "${timeSlots[index]}PM";
                                        },
                                        text: 'PM',
                                      ).paddingSymmetric(horizontal: 10);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    width: 150.w,
                                    fontSize: 12.sp,
                                    text: "Send message",
                                    onPressed: () async {
                                      final chatroomModel =
                                          await getChatRoomModel(
                                              widget.doctorId);
                                      if (chatroomModel != null) {
                                        Get.to(
                                          () => ChatRoomPage(
                                            targetUserId: widget.doctorId,
                                            chatroom: chatroomModel,
                                          ),
                                        );
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'Unable to create or fetch chatroom.',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    },
                                  ),
                                  Obx(
                                    () => CustomButton(
                                      width: 150.w,
                                      text: controller.buttonname.value
                                          ? "Appointment Update"
                                          : "Book Appointment",
                                      fontSize: 12.sp,
                                      onPressed: () {
                                        _checkAppointment();
                                        if (selectedDates.isNotEmpty &&
                                            selectedTimes.isNotEmpty) {
                                          controller.saveAppointment(
                                            selectedDate: selectedDates,
                                            selectedTime: selectedTimes,
                                            doctoruid: widget.doctorId,
                                            doctorImage: profilePictureUrl,
                                            userImage: firebaseuid!.photoURL
                                                .toString(),
                                            doctorName: name,
                                          );
                                        } else {
                                          Get.snackbar('Error',
                                              'Please select a date and time.',
                                              colorText: Colors.white,
                                              backgroundColor: Colors.red,
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ).paddingAll(20),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 30,
            left: 10,
            child: Center(
              child: IconButton(
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
