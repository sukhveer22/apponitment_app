import 'dart:io';
import 'package:app_apponitmnet/doctor/controllers/profile_controller.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:app_apponitmnet/util/custom_button.dart';
import 'package:app_apponitmnet/util/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileScreen extends StatefulWidget {
  final String doctorId;

        const EditProfileScreen({super.key, required this.doctorId});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController _profileController = ProfileController();
  final _formKey = GlobalKey<FormState>();
  final Rxn<CroppedFile> _imageFile = Rxn<CroppedFile>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _specialtyController;
  late TextEditingController _categoryIdController;
  late String imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _specialtyController = TextEditingController();
    _categoryIdController = TextEditingController();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final doctor =
          await _profileController.fetchDoctorProfile(widget.doctorId);
      setState(() {
        _nameController.text = doctor.name;
        _emailController.text = doctor.email;
        _phoneNumberController.text = doctor.phoneNumber ?? '';
        _specialtyController.text = doctor.specialty;
        _categoryIdController.text = doctor.categoryId ?? '';
        imagePath = doctor.profilePictureUrl ?? '';

        if (doctor.profilePictureUrl != null) {
          _imageFile.value = CroppedFile(doctor.profilePictureUrl!);
        }
      });
    } catch (e) {
      print('Error fetching profile: $e');
      Get.snackbar("Error", "Error fetching profile: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _specialtyController.dispose();
    _categoryIdController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final updatedData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'specialty': _specialtyController.text,
        'categoryId': _categoryIdController.text,
        if (_imageFile.value != null)
          'profileImagePath': _imageFile.value!.path,
      };
      try {
        await _profileController.updateDoctorProfile(
            widget.doctorId, updatedData);
        Navigator.pop(context);
      } catch (e) {
        Get.snackbar("Error", "Error updating profile: $e",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: AppTextStyles.title),
         centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        actions: [

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Obx(() {
                    final imageFile = _imageFile.value;
                    return Container(
                      width: 100.w,
                      height: 100.h,
                      padding: EdgeInsets.all(3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.w),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showPhotoOptions();
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                          radius: 65.r,
                          backgroundImage: imageFile == null
                              ? imagePath.isNotEmpty
                                  ? FileImage(File(imagePath))
                                  : null
                              : FileImage(File(imageFile.path)),
                        ),
                      ),
                    );
                  }).paddingSymmetric(vertical: 10.h),
                ),
                SizedBox(height: 20.h),
                _buildTextField('Full Name', _nameController, 1),
                _buildTextField('Email', _emailController, 1),
                _buildTextField('Phone Number', _phoneNumberController, 1),
                _buildTextField('Specialty', _specialtyController, 3),
                _buildTextField('Category ID', _categoryIdController, 1),
                SizedBox(height: 20.h),
                Center(
                  child: CustomButton(
                    onPressed: _updateProfile,
                    text: 'Update Profile',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, int maxLine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          width: AppConfig.screenWidth,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withAlpha(80),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomTextField(
            controller: controller,
            hintText: label,
            maxLine: maxLine,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
      );

      if (croppedImage != null) {
        _imageFile.value = croppedImage;
      }
    } catch (e) {
      Get.snackbar("Error", "Error cropping image: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showPhotoOptions() {
    Get.dialog(
      AlertDialog(
        title: Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Get.back();
                selectImage(ImageSource.gallery);
              },
              leading: Icon(Icons.photo_album),
              title: Text("Select from Gallery"),
            ),
            ListTile(
              onTap: () {
                Get.back();
                selectImage(ImageSource.camera);
              },
              leading: Icon(Icons.camera_alt),
              title: Text("Select from Camera"),
            ),
          ],
        ),
      ),
    );
  }
}
