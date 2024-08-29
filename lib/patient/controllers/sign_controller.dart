import 'dart:io';
import 'package:app_apponitmnet/patient/dashborad/dashboard.dart';
import 'package:app_apponitmnet/util/user-data-get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/models/user_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController(text: "21@gmail.com");
  var passwordController = TextEditingController(text: "123456");
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;
  String? profilePictureUrl;
  Rx<CroppedFile?> imageFile = Rx<CroppedFile?>(null);

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> signUp() async {
    try {
      isLoading.value = true;

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );


      if (imageFile.value != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profilePictureUrl/${userCredential.user!.uid}');
        final uploadTask = storageRef.putFile(File(imageFile.value!.path));
        final snapshot = await uploadTask.whenComplete(() {});
        profilePictureUrl = await snapshot.ref.getDownloadURL();

      }
      await userCredential.user?.updatePhotoURL(profilePictureUrl);
      await userCredential.user?.updateDisplayName(nameController.text.trim());
      UserModel user = UserModel(
        id: userCredential.user!.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        profilePictureUrl: profilePictureUrl.toString(),
        role: "patient", // Sav
      );
      UserModel? users = await FirebaseHelper.getUserModelById(user.id.toString());
      await saveUserToFirestore(user);
      await saveUserToPreferences(user);


      Get.off(DashboardScreen());
      Get.snackbar('Success', 'Signed up successfully');
    } catch (e) {
      Get.snackbar('Error', _getErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('Users').doc(user.id);
      await userRef.set(user.toMap());
    } catch (e) {
      print('Error saving user to Firestore: $e');
    }
  }



  Future<UserModel?> getUserFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('userId');
      final name = prefs.getString('userName');
      final email = prefs.getString('userEmail');

      if (id != null && name != null && email != null) {
        return UserModel(id: id, name: name, email: email);
      }
      return null;
    } catch (e) {
      print('Error retrieving user from SharedPreferences: $e');
      return null;
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already in use.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'operation-not-allowed':
          return 'Operation not allowed. Please contact support.';
        case 'weak-password':
          return 'The password is too weak.';
        default:
          return 'An unknown error occurred. Please try again.';
      }
    }
    return 'An error occurred. Please try again.';
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
        imageFile.value = croppedImage;
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
Future<void> saveUserToPreferences(UserModel user) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id.toString());
    await prefs.setString('userName', user.name.toString());
    await prefs.setString('userEmail', user.email.toString());
  } catch (e) {
    print('Error saving user to SharedPreferences: $e');
  }
}