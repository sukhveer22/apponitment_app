import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String? appointmentId;
  final String? doctorName;
  final String? userName;
  final String? userImage;
  final String? doctorId;
  final String? appointmentDate; // Keep appointmentDate as a String
  final String? appointmentTime;
  final String? doctorImage;

  AppointmentModel({
    this.doctorId,
    this.doctorName,
    this.userName,
    this.userImage,
    this.appointmentDate,
    this.doctorImage,
    this.appointmentId,
    this.appointmentTime,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      appointmentId: map['appointmentId'] as String?,
      doctorName: map['doctorName'] as String?,
      userName: map['userName'] as String?,
      userImage: map['userImage'] as String?,
      doctorId: map['doctorId'] as String?,
      appointmentDate: map['appointmentDate'] is Timestamp
          ? (map['appointmentDate'] as Timestamp).toDate().toIso8601String()
          : map['appointmentDate'] as String?,
      appointmentTime: map['appointmentTime'] as String?,
      doctorImage: map['doctorImage'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'userName': userName,
      'userImage': userImage,
      'appointmentId': appointmentId,
      'appointmentDate': appointmentDate, // Store as String
      'appointmentTime': appointmentTime,
      'doctorImage': doctorImage,
    };
  }
}
