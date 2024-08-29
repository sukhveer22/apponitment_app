import 'package:app_apponitmnet/util/doctor_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import '../../controllers/doctor-tap-controller.dart';

class DoctorTapScreen extends StatefulWidget {
  @override
  State<DoctorTapScreen> createState() => _DoctorTapScreenState();
}


class _DoctorTapScreenState extends State<DoctorTapScreen> {
    final DoctorTapController controller = Get.put(DoctorTapController());

  @override
  void initState() {
    super.initState();
    controller.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Dentist",
          style: AppTextStyles.title,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.doctors.isEmpty) {
                return Center(child: Text("No doctors available."));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.doctors.length,
                itemBuilder: (context, index) {
                  final doctor = controller.doctors[index];
                  return DoctorCard(
                    doctorName: controller.nameDoctors[index],
                    doctorImageUrl: controller.activeDoctors[index],
                    rating: 2.0,
                    doctorTap: controller.tapDoctors[index],
                    doctor: controller.numberDoctors[index], doctorId:controller.idDoctors[index],
                  );
                },
              );
            }),
          ),
        ],
      ).paddingSymmetric(horizontal: 20, vertical: 20),
    );
  }
}
