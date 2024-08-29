import 'dart:io';

import 'package:app_apponitmnet/patient/controllers/add_doctor_controller.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:app_apponitmnet/util/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final DoctorController _doctorController = Get.put(DoctorController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Add Doctor',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 29.sp,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  final imageFile = _doctorController.imageFile.value;
                  return Container(
                    width: 130,
                    height: 130,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CupertinoButton(
                      onPressed: () {
                        _doctorController.showPhotoOptions();
                      },
                      padding: EdgeInsets.zero,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        radius: 65.r,
                        child: imageFile != null
                            ? Image.file(File(imageFile.path))
                            : Image.asset(
                                "assets/home_screen_image/doctor-images/doctor5.png",
                              ),
                      ),
                    ).paddingAll(2),
                  );
                }),
                const SizedBox(height: 40),
                CustomTextField(
                  hintText: "Title",
                  controller: _titleController,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: "Rating..",
                  controller: _ratingController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  maxLine: 8,
                  hintText: "Description...",
                  controller: _descriptionController,
                ),
                const SizedBox(height: 60),
                CustomButton(
                  onPressed: () async {
                    final title = _titleController.text;
                    final description = _descriptionController.text;
                    final rating =
                        double.tryParse(_ratingController.text) ?? 0.0;
                    final imageFile = _doctorController.imageFile.value;

                    if (title.isNotEmpty &&
                        description.isNotEmpty &&
                        rating > 0 &&
                        imageFile != null) {
                      await _doctorController.addDoctor(
                        imagePath: imageFile.path,
                        title: title,
                        description: description,
                        rating: rating,
                      );
                      Get.back();
                    } else {
                      Get.snackbar('Error', 'Please fill all fields correctly');
                    }
                  },
                  text: "Save",
                  textStyle: TextStyle(),
                ),
              ],
            ).paddingSymmetric(horizontal: 20, vertical: 20),
          ),
        ),
      ),
    );
  }
}
