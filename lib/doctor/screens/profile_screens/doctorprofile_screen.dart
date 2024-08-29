import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/doctor/controllers/profile_controller.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/profile-edit-screen.dart';
import 'package:app_apponitmnet/models/doctor_model.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DoctorProfileScreen extends StatelessWidget {
  final String doctorId;
  final ProfileController profileController = ProfileController(); // Instantiate the ProfileController

  DoctorProfileScreen({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(doctorId: doctorId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Doctors>(
          future: profileController.fetchDoctorProfile(doctorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return Center(child: Text('Doctor not found'));
            }

            final doctor = snapshot.data!;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2.w),
                      ),
                      child: CircleAvatar(
                        backgroundImage: doctor.profilePictureUrl != null
                            ? NetworkImage(doctor.profilePictureUrl!)
                            : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                        radius: 50.r,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildDetailSection('Full Name', doctor.name),
                  _buildDetailSection('Category Name', doctor.categoryId),
                  _buildDetailSection('Email', doctor.email),
                  _buildDetailSection('Phone Number', doctor.phoneNumber),
                  _buildDetailSection('Specialty', doctor.specialty),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          width: AppConfig.screenWidth,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withAlpha(80),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value ?? 'N/A',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
