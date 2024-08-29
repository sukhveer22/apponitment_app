import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/doctor/controllers/doctor_home_screen_controller.dart';
import 'package:app_apponitmnet/doctor/screens/doctor-notes-screen.dart';
import 'package:app_apponitmnet/doctor/screens/doctor_schedule_screen.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../role_method/select_role_controller.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final DoctorHomeController appointmentController =
        Get.put(DoctorHomeController());
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final SelectRoleController userrole = Get.put(SelectRoleController());
    @override
    void initState() {
      super.initState();
      // Set the user as active when the screen is initialized
      userrole.setActiveStatus(true);
    }

    @override
    void dispose() {
      // Set the user as inactive when the screen is disposed
      userrole.setActiveStatus(false);
      super.dispose();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomRight,
            colors: [
              Colors.white70,
              AppColors.primaryColor,
              AppColors.primaryColor,
              AppColors.primaryColor,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(appointmentController),
            _buildBody(userId),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DoctorHomeController appointmentController) {
    return Container(
      height: 240.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          end: Alignment.bottomCenter,
          colors: [
            Colors.white70,
            AppColors.primaryColor,
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(65.r)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 29.h, left: 10.w, right: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Container(
                        height: 60.h,
                        width: 60.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: appointmentController
                                    .doctorImageUrl.value.isNotEmpty
                                ? NetworkImage(
                                    appointmentController.doctorImageUrl.value)
                                : NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXy2ouPgmpbhCCFXtYVM5xKuX3e1-gGYWRFg&s'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                    Spacer(),
                    Container(
                      height: 40.h,
                      width: 40.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25.sp,
                        ),
                      ),
                      Text(
                        "${appointmentController.doctorName.value}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 23.sp,
                        ),
                      ),
                      Text(
                        "How are you today?",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10.w, vertical: 20.h);
                }),
              ],
            ),
          ),
          Positioned(
            bottom: 2.h,
            right: 16.w,
            child: Image(
              image: AssetImage("assets/doctor-image-backremove.png"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(String? userId) {
    return Flexible(
        child: Container(
      height: AppConfig.screenHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(65.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Color(0xffCAD6FF),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: StreamBuilder<DocumentSnapshot>(
                stream: userId != null
                    ? FirebaseFirestore.instance
                        .collection('Users')
                        .doc(userId)
                        .snapshots()
                    : Stream.empty(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(
                      child: Text('No schedule found.'),
                    );
                  }

                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  var startDateField = data['startDate'] ?? '';
                  var endDateField = data['endDate'] ?? '';
                  String startTimeString = data['startTime'] ?? '';
                  String endTimeString = data['endTime'] ?? '';

                  String formattedStartDate =
                      startDateField.isNotEmpty ? startDateField : 'N/A';
                  String formattedEndDate =
                      endDateField.isNotEmpty ? endDateField : 'N/A';

                  String formattedStartTime =
                      startTimeString.isNotEmpty ? startTimeString : 'N/A';
                  String formattedEndTime =
                      endTimeString.isNotEmpty ? endTimeString : 'N/A';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Schedule",
                            style: AppTextStyles.header,
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20.h,
                          ),
                        ],
                      ),
                      Text(
                        "Start",
                        style: AppTextStyles.header,
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16.h, color: Colors.blue),
                          SizedBox(width: 5.w),
                          Text(formattedStartDate),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16.h, color: Colors.blue),
                          SizedBox(width: 5.w),
                          Text(formattedStartTime),
                        ],
                      ),
                      Text(
                        "End",
                        style: AppTextStyles.header,
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16.h, color: Colors.red),
                          SizedBox(width: 5.w),
                          Text(formattedEndDate),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16.h, color: Colors.red),
                          SizedBox(width: 5.w),
                          Text(formattedEndTime),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Color(0xffCAD6FF),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(DoctorScheduleScreen());
                    },
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Schedule",
                            style: AppTextStyles.header,
                          ),
                          Image.asset(
                            "assets/ssff.png",
                            height: 50.h,
                            width: 50.w,
                          ),
                        ],
                      ).paddingAll(10.w),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => DoctorNotesScreen());
                    },
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Notes",
                            style: AppTextStyles.header,
                          ),
                          Image.asset(
                            "assets/schedule.png",
                            height: 50.h,
                            width: 50.w,
                          ),
                        ],
                      ).paddingAll(10.w),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 20.w, vertical: 20.h),
      ),
    ));
  }
}
