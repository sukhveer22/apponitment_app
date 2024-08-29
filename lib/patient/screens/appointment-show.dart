import 'package:app_apponitmnet/util/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'appointmentEditScreen.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen>
    with SingleTickerProviderStateMixin {
  final User? firebase = FirebaseAuth.instance.currentUser;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editAppointment(Map<String, dynamic> appointment) {
    Get.to(() => EditAppointmentScreen(appointment: appointment));
  }

  void _deleteAppointment(String appointmentId) {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .delete()
        .then((_) {
      _showConfirmationDialog('Appointment deleted successfully.');
    }).catchError((error) {
      _showConfirmationDialog('Failed to delete appointment: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Pending"),
            Tab(text: "Confirmed"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAppointmentList(isConfirmed: false),
            _buildAppointmentList(isConfirmed: true),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList({required bool isConfirmed}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where(
            'appointmentId',
            isEqualTo: firebase!.uid.toString(),
          )
          .where('isConfirmed', isEqualTo: isConfirmed)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No appointments found.'));
        }
        final appointments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment =
                appointments[index].data() as Map<String, dynamic>;
            final isConfirmed = appointment['isConfirmed'] ?? false;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              elevation: 5,
              child: ListTile(
                leading: appointment['doctorImage'] != null
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(appointment['doctorImage']),
                        radius: 30,
                      )
                    : CircleAvatar(
                        child: Icon(Icons.person),
                        radius: 30,
                      ),
                title: Text(
                  isConfirmed == false
                      ? 'Doctor:${appointment["doctorName"] ?? 'Unknown Doctor'}'
                      : 'Appointment confirmed with ${appointment["doctorName"] ?? 'Unknown Doctor'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                    fontSize: 14.sp,
                  ),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${appointment['appointmentDate']}',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    Text(
                      'Time: ${appointment['appointmentTime']}',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  ],
                ),
                trailing: isConfirmed
                    ? Icon(Icons.check, color: Colors.green)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editAppointment(appointment);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              _deleteAppointment(appointments[index].id);
                            },
                          ),
                        ],
                      ),
                onTap: () {
                  if (isConfirmed) {
                    _showConfirmationDialog('This appointment is confirmed.');
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
