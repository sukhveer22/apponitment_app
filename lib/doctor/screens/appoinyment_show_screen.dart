import 'package:app_apponitmnet/models/appointent_model.dart';
import 'package:app_apponitmnet/util/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DoctorAppointmentListScreen extends StatefulWidget {
  @override
  _DoctorAppointmentListScreenState createState() =>
      _DoctorAppointmentListScreenState();
}

class _DoctorAppointmentListScreenState
    extends State<DoctorAppointmentListScreen>
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

  Future<void> _confirmDelete(
      BuildContext context, String appointmentId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this appointment?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(appointmentId)
                      .delete();
                  Get.snackbar('Success', 'Appointment deleted successfully');
                } catch (e) {
                  print(e);
                  Get.snackbar('Error', 'Failed to delete appointment: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmAppointment(AppointmentModel appointment) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(firebase!.uid.toString() + appointment.appointmentId.toString())
          .update({'isConfirmed': true});
      Get.snackbar('Success', 'Appointment confirmed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to confirm appointment: $e');
    }
  }

  Widget _buildAppointmentList({required List<AppointmentModel> appointments}) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        bool isConfirmed = appointment.isConfirmed ?? false;
        bool showConfirmButton = _tabController.index == 0 &&
            !isConfirmed;

        return Dismissible(
          key: Key(appointment.appointmentId ?? ''),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _confirmDelete(context, appointment.appointmentId ?? '');
          },
          background: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              leading: CircleAvatar(
                backgroundImage: appointment.doctorImage != null
                    ? NetworkImage(appointment.doctorImage!)
                    : null,
                radius: 30,
              ),
              title: Text(appointment.doctorName ?? 'Unknown Doctor'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.isConfirmed == false
                        ? 'Appointment with ${appointment.userName ?? 'Unknown User'} on ${DateFormat.yMMMd().format(DateTime.tryParse(appointment.appointmentDate ?? '') ?? DateTime.now())}\nTime: ${appointment.appointmentTime ?? 'Not specified'}'
                        : 'Appointment confirm ${appointment.userName ?? 'Unknown User'} on ${DateFormat.yMMMd().format(DateTime.tryParse(appointment.appointmentDate ?? '') ?? DateTime.now())}\nTime: ${appointment.appointmentTime ?? 'Not specified'}',
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      if (showConfirmButton)
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: Size(AppConfig.screenWidth * 0.3, 40),
                          ),
                          child: Text("Confirm",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            _confirmAppointment(appointment);
                          },
                        ),
                      SizedBox(width: 10),
                      if (_tabController.index == 0 && !isConfirmed)
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: Size(AppConfig.screenWidth * 0.3, 40),
                          ),
                          child: Text("Delete",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            _confirmDelete(
                                context, appointment.appointmentId ?? '');
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(child: Text("All Appointments")),
            Tab(child: Text("Confirmed Appointments")),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorId',
                isEqualTo:
                    firebase!.uid) // Filter appointments for the current doctor
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

          final appointments = snapshot.data!.docs
              .map((doc) =>
                  AppointmentModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          final filteredAppointments = _tabController.index == 0
              ?appointments
              : appointments
                  .where((appointment) => appointment.isConfirmed == true)
                  .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentList(appointments: appointments),
              _buildAppointmentList(appointments: filteredAppointments),
            ],
          );
        },
      ),
    );
  }
}
