import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/models/doctor_model.dart';
import 'package:get/get.dart';

class HerarttTapController extends GetxController {
  var doctors = <Doctors>[].obs; // List of doctors to be displayed
  var activeDoctors = <String>[].obs;
  var nameDoctors = <String>[].obs;
  var tapDoctors = <String>[].obs;
  var numberDoctors = <String>[].obs;
  var idDoctors = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  void fetchDoctors() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('categoryId', isEqualTo: 'Category.Heart')
          .get();
      activeDoctors.value = snapshot.docs
          .map((doc) => doc['profilePictureUrl'] as String)
          .toList();
      nameDoctors.value =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      tapDoctors.value =
          snapshot.docs.map((doc) => doc['categoryId'] as String).toList();
      numberDoctors.value =
          snapshot.docs.map((doc) => doc['phoneNumber'] as String).toList();
      idDoctors.value =
          snapshot.docs.map((doc) => doc['id'] as String).toList();
      doctors.value = snapshot.docs
          .map((doc) => Doctors.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }
}

class EyesTapController extends GetxController {
  var doctors = <Doctors>[].obs; // List of doctors to be displayed
  var activeDoctors = <String>[].obs;
  var nameDoctors = <String>[].obs;
  var tapDoctors = <String>[].obs;
  var numberDoctors = <String>[].obs;
  var idDoctors = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  void fetchDoctors() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('categoryId', isEqualTo: 'Category.Eyes')
          .get();
      activeDoctors.value = snapshot.docs
          .map((doc) => doc['profilePictureUrl'] as String)
          .toList();
      nameDoctors.value =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      tapDoctors.value =
          snapshot.docs.map((doc) => doc['categoryId'] as String).toList();
      numberDoctors.value =
          snapshot.docs.map((doc) => doc['phoneNumber'] as String).toList();
      idDoctors.value =
          snapshot.docs.map((doc) => doc['id'] as String).toList();
      doctors.value = snapshot.docs
          .map((doc) => Doctors.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }
}

class DoctorTapController extends GetxController {
  var doctors = <Doctors>[].obs; // List of doctors to be displayed
  var activeDoctors = <String>[].obs;
  var nameDoctors = <String>[].obs;
  var tapDoctors = <String>[].obs;
  var numberDoctors = <String>[].obs;
  var idDoctors = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  void fetchDoctors() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('categoryId', isEqualTo: 'Category.Doctor')
          .get();
      activeDoctors.value = snapshot.docs
          .map((doc) => doc['profilePictureUrl'] as String)
          .toList();
      nameDoctors.value =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      tapDoctors.value =
          snapshot.docs.map((doc) => doc['categoryId'] as String).toList();
      numberDoctors.value =
          snapshot.docs.map((doc) => doc['phoneNumber'] as String).toList();
      idDoctors.value =
          snapshot.docs.map((doc) => doc['id'] as String).toList();
      doctors.value = snapshot.docs
          .map((doc) => Doctors.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }
}

class DentistTapController extends GetxController {
  var doctors = <Doctors>[].obs; // List of doctors to be displayed
  var activeDoctors = <String>[].obs;
  var nameDoctors = <String>[].obs;
  var tapDoctors = <String>[].obs;
  var numberDoctors = <String>[].obs;
  var idDoctors = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  void fetchDoctors() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('categoryId', isEqualTo: 'Category.Dentist')
          .get();
      activeDoctors.value = snapshot.docs
          .map((doc) => doc['profilePictureUrl'] as String)
          .toList();
      nameDoctors.value =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      tapDoctors.value =
          snapshot.docs.map((doc) => doc['categoryId'] as String).toList();
      numberDoctors.value =
          snapshot.docs.map((doc) => doc['phoneNumber'] as String).toList();
      idDoctors.value =
          snapshot.docs.map((doc) => doc['id'] as String).toList();
      doctors.value = snapshot.docs
          .map((doc) => Doctors.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }
}
