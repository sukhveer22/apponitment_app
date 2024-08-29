import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

enum UserRole { doctor, patient }

class SelectRoleController extends GetxController {
  var selectedRole = UserRole.doctor.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void selectRole(UserRole role) {
    selectedRole.value = role;
  }

  Future<void> setActiveStatus(bool isActive) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection("Users").doc(user.uid).set(
          {"Active": isActive},
          SetOptions(merge: true),
        );
      } else {
        print('No user is currently logged in.');
      }
    } catch (e, s) {
      print('Error setting active status: $e');
      print(s);
    }
  }
}
