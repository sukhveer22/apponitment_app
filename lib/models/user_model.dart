import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? profilePictureUrl;
  String? role;

  UserModel({this.id, this.name, this.email, this.profilePictureUrl, this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'role': role,
    };
  }

  UserModel.fromMap(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        email = json["email"],
        profilePictureUrl = json['profilePictureUrl'],
        role = json['role'];
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      profilePictureUrl: data['profilePictureUrl'],
      role: data['role'],
    );
  }
}
