import 'package:cloud_firestore/cloud_firestore.dart';

class Doctors {
  final String id;
  final String name;
  final String specialty;
  final String email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final String? role;

  final String? categoryId;

  Doctors({
    required this.id,
    required this.name,
    required this.specialty,
    required this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.categoryId,
    this.role,
  });

  // Convert a Doctor object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'specialty': specialty,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'categoryId': categoryId,
    };
  }

  // Create a Doctor object from a Firestore document snapshot
  factory Doctors.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Doctors(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      specialty: data['specialty'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'],
      role: data['role'],
      profilePictureUrl: data['profilePictureUrl'],
      categoryId: data['categoryId'],
    );
  }

  // Create a Doctor object from a map
  factory Doctors.fromMap(Map<String, dynamic> map) {
    return Doctors(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      profilePictureUrl: map['profilePictureUrl'],
      categoryId: map['categoryId'],
    );
  }
  factory Doctors.fromDocument(Map<String, dynamic> doc) {
    return Doctors(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      role: doc['role'] ?? '',
      phoneNumber: doc['phoneNumber'] ?? '',
      profilePictureUrl: doc['profilePictureUrl'] ?? '',
      specialty: doc['specialty'] ?? '',
    );
  }
}
