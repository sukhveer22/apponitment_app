import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/models/doctor_model.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Doctors> fetchDoctorProfile(String doctorId) async {
    final docSnapshot = await _firestore.collection('Users').doc(doctorId).get();
    if (docSnapshot.exists) {
      return Doctors.fromMap(docSnapshot.data()!);
    } else {
      throw Exception('Doctor not found');
    }
  }

  Future<void> updateDoctorProfile(String doctorId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('Users').doc(doctorId).update(updatedData);
  }
}
