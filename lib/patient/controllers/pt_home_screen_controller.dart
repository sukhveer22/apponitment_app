import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/patient/screens/doctor-tap-screen/doctor-dentist-screen.dart';
import 'package:app_apponitmnet/patient/screens/doctor-tap-screen/doctor-eye-screen.dart';
import 'package:app_apponitmnet/patient/screens/doctor-tap-screen/doctor-tap-screen.dart';
import 'package:app_apponitmnet/patient/screens/doctor-tap-screen/doctorheart-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final TextEditingController searchText = TextEditingController();
  final RxList<String> filteredDoctors = <String>[].obs;
  final RxList<String> activeDoctors = <String>[].obs;
  final RxList<String> nameDoctors = <String>[].obs;
  final RxList<String> tapDoctors = <String>[].obs;
  final RxList<String> numberDoctors = <String>[].obs;
  final RxList<String> sactiveDoctors = <String>[].obs;
  final RxList<String> snameDoctors = <String>[].obs;
  final RxList<String> stapDoctors = <String>[].obs;
  final RxList<String> snumberDoctors = <String>[].obs;
  final RxList<String> sIdDoctors = <String>[].obs;
  final RxList<String> idDoctors = <String>[].obs;
  final RxList<Widget> screens = [
    DentistTapScreen(),
    HerarttTapScreen(),
    EyesTapScreen(),
    DoctorTapScreen()
  ].obs;
  final RxList<String> imageList = [
    "assets/s-1.png",
    "assets/s-2.png",
    "assets/s-3.png",
    "assets/s-4.png"
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveDoctors();
  }

  Future<void> fetchActiveDoctors() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('role', isEqualTo: 'Doctor') // Filter only doctors
          .get();
      var docs = snapshot.docs;

      activeDoctors.value =
          docs.map((doc) => doc['profilePictureUrl'] as String).toList();
      nameDoctors.value = docs.map((doc) => doc['name'] as String).toList();
      tapDoctors.value =
          docs.map((doc) => doc['categoryId'] as String).toList();
      numberDoctors.value =
          docs.map((doc) => doc['phoneNumber'] as String).toList();
      filteredDoctors.value =
          List.from(activeDoctors); // Initialize filteredDoctors
      idDoctors.value = docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }

  Future<void> updateSearchText(String text) async {
    searchText.text = text;
    try {
      if (text.isEmpty) {
        filteredDoctors.value =
            List.from(activeDoctors); // Show all doctors if search is empty
      } else {
        var snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('role', isEqualTo: 'Doctor') // Filter only doctors
            .where('name', isGreaterThanOrEqualTo: text)
            .where('name', isLessThanOrEqualTo: text + '\uf8ff')
            .get();
        var docs = snapshot.docs;

        sactiveDoctors.value =
            docs.map((doc) => doc['profilePictureUrl'] as String).toList();
        snameDoctors.value = docs.map((doc) => doc['name'] as String).toList();
        stapDoctors.value =
            docs.map((doc) => doc['categoryId'] as String).toList();
        snumberDoctors.value =
            docs.map((doc) => doc['phoneNumber'] as String).toList();
        sIdDoctors.value = docs.map((doc) => doc.id).toList();
        filteredDoctors.value =
            List.from(sactiveDoctors); // Update filteredDoctors based on search
      }
    } catch (e, s) {
      print('Error updating search text: $e');
      print(s);
    }
  }
}
