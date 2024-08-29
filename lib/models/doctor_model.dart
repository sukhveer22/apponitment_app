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
  final String? location; // New field
  final String? gender; // New field
  final int age; // New field

  Doctors({
    required this.id,
    required this.name,
    required this.specialty,
    required this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.categoryId,
    this.role,
    this.location,
    this.gender,
    required this.age,
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
      'location': location,
      'gender': gender,
      'age': age,
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
      location: data['location'],
      gender: data['gender'],
      age: data['age'] ?? 0, // Default to 0 if not present
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
      location: map['location'],
      gender: map['gender'],
      age: map['age'] ?? 0, // Default to 0 if not present
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
      location: doc['location'],
      gender: doc['gender'],
      age: doc['age'] ?? 0, // Default to 0 if not present
    );
  }
}
