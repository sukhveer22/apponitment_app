import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class DoctorController extends GetxController {
  Rx<CroppedFile?> imageFile = Rx<CroppedFile?>(null);

  // Method to add a doctor to Firestore
  Future<void> addDoctor({
    required String imagePath,
    required String title,
    required String description,
    required double rating, // Changed to double
  }) async {
    final doctor = {
      'imagePath': imagePath,
      'title': title,
      'description': description,
      'rating': rating.toString(), // Convert to String for Firestore
    };

    try {
      await FirebaseFirestore.instance.collection('Users').add(doctor);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add doctor: ${e.toString()}');
    }
  }

  // Method to select an image
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  // Method to crop an image
  void cropImage(XFile file) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
      );

      if (croppedImage != null) {
        imageFile.value = croppedImage;
      }
    } catch (e) {
      Get.snackbar("Error", "Error cropping image: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to show photo options (gallery or camera)
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
              title: Text("Take a photo"),
            ),
          ],
        ),
      ),
    );
  }
}
