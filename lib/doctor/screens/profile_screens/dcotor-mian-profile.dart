import 'package:app_apponitmnet/doctor/screens/doctor_login.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/doctorprofile_screen.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/privacy-policy-screen.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/profile-edit-screen.dart';
import 'package:app_apponitmnet/doctor/screens/profile_screens/settings_screen.dart';
import 'package:app_apponitmnet/models/doctor_model.dart';
import 'package:app_apponitmnet/patient/screens/login_screen.dart';
import 'package:app_apponitmnet/role_method/select_role_controller.dart';
import 'package:app_apponitmnet/role_method/select_role_screen.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'help-screen.dart';

class AllProfile extends StatefulWidget {
  const AllProfile({Key? key}) : super(key: key);

  @override
  _AllProfileState createState() => _AllProfileState();
}

class _AllProfileState extends State<AllProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SelectRoleController userrole = Get.put(SelectRoleController());

  Future<Doctors> fetchDoctorProfile(String doctorId) async {
    final docSnapshot =
        await _firestore.collection('Users').doc(doctorId).get();
    if (docSnapshot.exists) {
      return Doctors.fromMap(docSnapshot.data()!);
    } else {
      throw Exception('Doctor not found');
    }
  }

  Future<Doctors> fetchUserProfile(String doctorId) async {
    final docSnapshot =
        await _firestore.collection('Users').doc(doctorId).get();
    if (docSnapshot.exists) {
      return Doctors.fromMap(docSnapshot.data()!);
    } else {
      throw Exception('Doctor not found');
    }
  }

  Future<void> _onRefresh() async {
    // Trigger a rebuild by calling setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = _auth.currentUser;
    return FutureBuilder<Doctors>(
      future: userrole.selectedRole.value == UserRole.doctor
          ? firebaseUser != null
              ? fetchDoctorProfile(firebaseUser.uid)
              : Future.value(null)
          : firebaseUser != null
              ? fetchUserProfile(firebaseUser.uid)
              : Future.value(null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final doctor = snapshot.data;

        return _buildProfileScreen(context, firebaseUser!.uid, doctor);
      },
    );
  }

  Widget _buildProfileScreen(
      BuildContext context, String doctorId, Doctors? doctor) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text("My Profile", style: AppTextStyles.title),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.center,
              colors: [
                Colors.white,
                Colors.white,
                Colors.white,
                AppColors.primaryColor
              ],
            ),
          ),
          child: Column(
            children: [
              _buildProfileHeader(context, doctor),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(70.r)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 30.h),
                        _buildOptionRow(
                          context,
                          icon: Icons.person,
                          text: "Profile",
                          onTap: () => Get.to(
                              () => DoctorProfileScreen(doctorId: doctorId)),
                        ),
                        _buildOptionRow(
                          context,
                          icon: Icons.policy,
                          text: "Privacy Policy",
                          onTap: () => Get.to(() => PrivacyPolicyScreen()),
                        ),
                        _buildOptionRow(
                          context,
                          icon: Icons.settings,
                          text: "Settings",
                          onTap: () => Get.to(SettingsScreen()),
                        ),
                        _buildOptionRow(
                          context,
                          icon: Icons.help,
                          text: "Help",
                          onTap: () => Get.to(() => HelpScreen()),
                        ),
                        SizedBox(height: 20.h),
                        _buildLogoutRow(context),
                      ],
                    ).paddingSymmetric(horizontal: 20.w),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Doctors? doctor) {
    final User? firebaseUser = _auth.currentUser;
    return Container(
      width: AppConfig.screenWidth,
      height: 140.h,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(65.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(
                      doctor?.profilePictureUrl ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXy2ouPgmpbhCCFXtYVM5xKuX3e1-gGYWRFg&s',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: () => Get.to(() =>
                      EditProfileScreen(doctorId: firebaseUser?.uid ?? '')),
                  child: Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 20.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor?.name ?? 'Name not available',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
              Text(
                doctor?.phoneNumber ?? 'Phone number not available',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                doctor?.email ?? 'Email not available',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 60.h,
            width: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withAlpha(80),
            ),
            child: Center(
              child: Icon(icon, color: Colors.white),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: AppTextStyles.header,
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios_sharp,
            color: AppColors.primaryColor.withAlpha(80),
          ),
        ],
      ).paddingOnly(bottom: 20),
    );
  }

  Widget _buildLogoutRow(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutConfirmationDialog(context),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withAlpha(80),
            ),
            child: Center(
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            "Logout",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.to(SelectRoleScreen());
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
