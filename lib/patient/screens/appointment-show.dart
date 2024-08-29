import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/patient/controllers/chat_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_apponitmnet/models/appointent_model.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListScreen extends StatelessWidget {
  final ChatListController controller = Get.put(ChatListController());

   ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
      ),
      body: Obx(() {
        if (controller.usersList.isEmpty && controller.doctorsList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            Text('Chat Users', style: Theme.of(context).textTheme.bodySmall),
            ...controller.usersList.map((chatRoom) {
              return ListTile(
                title: Text(chatRoom.chatroomid??""),
                // Add more details about chatRoom as needed
              );
            }).toList(),
            Text('Chat Doctors', style: Theme.of(context).textTheme.bodyLarge),
            ...controller.doctorsList.map((chatRoom) {
              return ListTile(
                title: Text(chatRoom.chatroomid??""),
                // Add more details about chatRoom as needed
              );
            }).toList(),
          ],
        );
      }),
    );
  }
}
class AppointmentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChatListScreen();
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Appointments'),
    //   ),
    //   body: StreamBuilder<QuerySnapshot>(
    //     stream:
    //         FirebaseFirestore.instance.collection('appointments').snapshots(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //
    //       if (snapshot.hasError) {
    //         return Center(child: Text('Error: ${snapshot.error}'));
    //       }
    //
    //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    //         return Center(child: Text('No appointments found.'));
    //       }
    //
    //       final appointments = snapshot.data!.docs
    //           .map((doc) =>
    //               AppointmentModel.fromMap(doc.data() as Map<String, dynamic>))
    //           .toList();
    //
    //       return ListView.builder(
    //         itemCount: appointments.length,
    //         itemBuilder: (context, index) {
    //           final appointment = appointments[index];
    //           return ListTile(
    //             leading: CircleAvatar(
    //               child: appointment.doctorImage.toString().isNotEmpty
    //                   ? Image.asset(appointment.doctorImage.toString())
    //                   : Image.network(
    //                       'https://via.placeholder.com/150'), // Placeholder if image URL is empty
    //             ),
    //             title: Text(appointment.doctorName.toString()),
    //             subtitle: Text(
    //               'Appointment with ${appointment.userName} on ${DateFormat.yMMMd().format(((DateTime.tryParse(appointment.appointmentDate ??"")??DateTime.now())))}',
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}
