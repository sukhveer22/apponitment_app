import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/util/appTextStyle.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';  // Only import once

class DoctorNotesScreen extends StatefulWidget {
  const DoctorNotesScreen({super.key});

  @override
  _DoctorNotesScreenState createState() => _DoctorNotesScreenState();
}

class _DoctorNotesScreenState extends State<DoctorNotesScreen> {
  final TextEditingController _noteController = TextEditingController();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    if (userId != null && _noteController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('notes').add({
        'userId': userId,
        'note': _noteController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _noteController.clear();
      Get.snackbar(
        'Note Added',
        'Your note has been added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes', style: AppTextStyles.header),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Enter your note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: _addNote,
              child: Text('Add Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: userId != null
                    ? FirebaseFirestore.instance
                    .collection('notes')
                    .where('userId', isEqualTo: userId)
                    .orderBy('timestamp', descending: true)
                    .snapshots()
                    : Stream.empty(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No notes found.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var noteData = snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;
                      String noteText = noteData['note'];
                      Timestamp timestamp = noteData['timestamp'];
                      DateTime dateTime = timestamp.toDate();
                      String formattedDate =
                      DateFormat('MMMM d, yyyy – h:mm a').format(dateTime);

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: ListTile(
                          title: Text(
                            noteText,
                            style: AppTextStyles.body,
                          ),
                          subtitle: Text(
                            formattedDate,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ).paddingAll(5.w);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
