import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorHomeController extends GetxController {
  RxString doctorName = ''.obs;
  RxString doctorImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctorDetails();
  }

  void fetchDoctorDetails() {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      doctorName.value = firebaseUser.displayName ?? 'Doctor';
      doctorImageUrl.value = firebaseUser.photoURL ?? '';
    }
  }
}
