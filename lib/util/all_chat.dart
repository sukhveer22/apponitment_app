import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/models/chat_model.dart';
import 'package:app_apponitmnet/patient/controllers/chat_list_controller.dart';
import 'package:app_apponitmnet/patient/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllChatScreen extends StatefulWidget {
  @override
  _AllChatScreenState createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  final ChatListController chatListController = Get.put(ChatListController());
  final SearchsController searchController = Get.put(SearchsController());

  final TextStyle titleStyle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w900,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Users', style: titleStyle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController.textController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // onChanged: searchController.updateSearchQuery,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection('chatRooms')
                    .where('participants.${firebaseUser?.uid}', isEqualTo: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
        
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
        
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No active users.'));
                  }
        
                  final chatRooms = snapshot.data!.docs.where((doc) {
                    final chatRoom = ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>);
                    final doctorId = chatRoom.participants?.keys.firstWhere(
                          (key) => key != firebaseUser?.uid,
                      orElse: () => '',
                    );
                    return doctorId != null && doctorId.isNotEmpty;
                  }).toList();
        
                  return ListView.builder(
                    itemCount: chatRooms.length,
                    itemBuilder: (context, index) {
                      final chatRoom = ChatRoomModel.fromMap(
                          chatRooms[index].data() as Map<String, dynamic>);
                      final doctorId = chatRoom.participants?.keys.firstWhere(
                            (key) => key != firebaseUser?.uid,
                        orElse: () => '',
                      );
        
                      if (doctorId == null || doctorId.isEmpty) {
                        return SizedBox.shrink();
                      }
        
                      return FutureBuilder<DocumentSnapshot>(
                        future: _firestore.collection("Users").doc(doctorId).get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return ListTile(
                              title: Text('Loading...'),
                            );
                          }
        
                          if (userSnapshot.hasError || !userSnapshot.hasData) {
                            return ListTile(
                              title: Text('Error loading user data'),
                            );
                          }
        
                          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                          final doctorName = userData['name'] ?? 'Unknown';
                          final doctorImage = userData['profilePictureUrl'] ?? '';
        
                          return Obx(() {
                            if (doctorName.toLowerCase().contains(searchController.searchQuery.value)) {
                              return ListTile(
                                leading: CircleAvatar(
                                  maxRadius: 30,
                                  backgroundImage: doctorImage.isNotEmpty
                                      ? NetworkImage(doctorImage)
                                      : null,
                                  child: doctorImage.isEmpty
                                      ? Icon(Icons.person)
                                      : null,
                                ),
                                title: Text(doctorName, style: titleStyle),
                                subtitle: Text(chatRoom.lastMessage.toString()),
                                onTap: () async {
                                  await _updateUserStatus(doctorId);
                                  Get.to(
                                        () => ChatRoomPage(
                                      chatroom: chatRoom,
                                      targetUserId: doctorId,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          });
                        },
                      );
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

  Future<void> _updateUserStatus(String userId) async {
    try {
      await _firestore.collection('Users').doc(userId).update({"seen": false});
    } catch (e) {
      print('Failed to update user status: $e');
      Get.snackbar(
        'Error',
        'Failed to update user status.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class SearchsController extends GetxController {
  final TextEditingController textController = TextEditingController();
  var searchQuery = ''.obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
  }
}
