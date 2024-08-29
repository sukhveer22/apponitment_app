import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String? appointmentId;
  final String? location;
  final String? type;
  final String? doctorName;
  final String? userName;
  final String? userImage;
  final String? doctorId;
  final String? appointmentDate;
  final String? appointmentTime;
  final String? doctorImage;
  final bool? isConfirmed;

  AppointmentModel({
    this.appointmentId,
    this.location,
    this.type,
    this.doctorName,
    this.userName,
    this.userImage,
    this.doctorId,
    this.appointmentDate,
    this.appointmentTime,
    this.doctorImage,
    this.isConfirmed,
  });

  // Factory method to create an instance from a Firestore document
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      appointmentId: map['appointmentId'] as String?,
      location: map['location'] as String?,
      type: map['type'] as String?,
      doctorName: map['doctorName'] as String?,
      userName: map['userName'] as String?,
      userImage: map['userImage'] as String?,
      doctorId: map['doctorId'] as String?,
      appointmentDate: map['appointmentDate'] is Timestamp
          ? (map['appointmentDate'] as Timestamp).toDate().toIso8601String()
          : map['appointmentDate'] as String?,
      appointmentTime: map['appointmentTime'] as String?,
      doctorImage: map['doctorImage'] as String?,
      isConfirmed: map['isConfirmed'] as bool?,
    );
  }

  // Convert the model instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'location': location,
      'type': type,
      'doctorName': doctorName,
      'userName': userName,
      'userImage': userImage,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'doctorImage': doctorImage,
      'isConfirmed': isConfirmed,
    };
  }

  // Method to create an instance from a Firestore DocumentSnapshot
  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      appointmentId: doc.id,
      location: data['location'] as String?,
      type: data['type'] as String?,
      doctorName: data['doctorName'] as String?,
      userName: data['userName'] as String?,
      userImage: data['userImage'] as String?,
      doctorId: data['doctorId'] as String?,
      appointmentDate: data['appointmentDate'] is Timestamp
          ? (data['appointmentDate'] as Timestamp).toDate().toIso8601String()
          : data['appointmentDate'] as String?,
      appointmentTime: data['appointmentTime'] as String?,
      doctorImage: data['doctorImage'] as String?,
      isConfirmed: data['isConfirmed'] as bool?,
    );
  }
}
