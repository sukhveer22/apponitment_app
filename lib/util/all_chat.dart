import 'package:app_apponitmnet/util/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/models/chat_model.dart';
import 'package:app_apponitmnet/patient/controllers/chat_list_controller.dart';
import 'package:app_apponitmnet/patient/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'custom_text_field.dart';

class AllChatScreen extends StatefulWidget {
  @override
  _AllChatScreenState createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen>
    with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  final ChatListController chatListController = Get.put(ChatListController());
  final SearchssController searchController = Get.put(SearchssController());

  final TextStyle titleStyle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w900,
    color: AppColors.textColor,
  );

  void _clearChat() async {
    final chatRooms = await _firestore
        .collection('chatRooms')
        .where('participants.${firebaseUser?.uid}', isEqualTo: true)
        .get();

    for (var doc in chatRooms.docs) {
      await doc.reference.delete();
    }
    Get.snackbar('Success', 'All chats cleared');
  }

  Future<void> showSettingsDrawer() async {
    Get.dialog(
      AlertDialog(
        title: Center(child: Text('Settings')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            ListTile(
              leading: Icon(
                CupertinoIcons.chat_bubble_2_fill,
                color: AppColors.textColor,
              ),
              title: Text(
                'Clear All Chats',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _clearChat();
              },
            ),
            // Ensure _selectClearChat() is implemented or remove this entry
            ListTile(
              leading: Icon(
                CupertinoIcons.square_fill_on_square_fill,
                color: AppColors.textColor,
              ),
              title: Text(
                'Select Clear Chat',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // _selectClearChat(); // Implement or remove
              },
            ),

            ListTile(
              leading: Icon(
                Icons.delete,
                color: AppColors.textColor,
              ),
              title: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textColor,
          ),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.delete();
      await _firestore.collection('Users').doc(user?.uid).delete();
      Get.offAllNamed('/login'); // Adjust based on your login route
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        actions: [
          SizedBox(
            width: 10,
          ),
          Text(
            "Message",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 25.sp,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              CupertinoIcons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Get.to(showSettingsDrawer());
            },
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: searchController.textController,
              hintText: "Search...",
              onChanged: searchController.updateSearchQuery,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a search query';
                }
                return null;
              },
              hintStyle: TextStyle(color: Colors.grey),
              helperStyle: TextStyle(color: Colors.blue),
              keyboardType: TextInputType.text,
              focusedBorderColor: Colors.blue,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              borderColor: Colors.grey,
            ),
          ),
          // Horizontal list of online users
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Online",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                  color: AppColors.textColor,
                ),
              )).paddingSymmetric(horizontal: 10),
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 8.0),
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
                  final chatRoom =
                      ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>);
                  final doctorId = chatRoom.participants?.keys.firstWhere(
                    (key) => key != firebaseUser?.uid,
                    orElse: () => '',
                  );
                  return doctorId != null && doctorId.isNotEmpty;
                }).toList();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
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

                    return StreamBuilder<DocumentSnapshot>(
                      stream: _firestore
                          .collection("Users")
                          .doc(doctorId)
                          .snapshots(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircleAvatar(
                            radius: 30,
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (userSnapshot.hasError || !userSnapshot.hasData) {
                          return CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.error),
                          );
                        }

                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        final doctorImage = userData['profilePictureUrl'] ?? '';
                        final doctorName = userData['name'] ?? 'Unknown';
                        return GestureDetector(
                          onTap: () async {
                            Get.to(
                              () => ChatRoomPage(
                                chatroom: chatRoom,
                                targetUserId: doctorId,
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                if (userData['status'] == 'online')
                                  Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.black, width: 2),
                                        ),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              doctorImage.isNotEmpty
                                                  ? NetworkImage(
                                                      doctorImage,
                                                    )
                                                  : null,
                                          child: doctorImage.isEmpty
                                              ? Icon(Icons.person)
                                              : null,
                                        ),
                                      ),
                                      Text(
                                        doctorName,
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Divider(
            color: AppColors.textColor,
            height: 4,
          ),
          // Vertical list of active users
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
                  final chatRoom =
                      ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>);
                  final doctorId = chatRoom.participants?.keys.firstWhere(
                    (key) => key != firebaseUser?.uid,
                    orElse: () => '',
                  );
                  return doctorId != null && doctorId.isNotEmpty;
                }).toList();

                return ListView.builder(
                  itemCount: chatRooms.length,
                  padding: EdgeInsets.symmetric(horizontal: 10),
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

                    return StreamBuilder<DocumentSnapshot>(
                      stream: _firestore
                          .collection("Users")
                          .doc(doctorId)
                          .snapshots(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text('Loading...'),
                          );
                        }

                        if (userSnapshot.hasError || !userSnapshot.hasData) {
                          return ListTile(
                            title: Text('Error loading user data'),
                          );
                        }

                        final userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        final doctorName = userData['name'] ?? 'Unknown';
                        final doctorImage = userData['profilePictureUrl'] ?? '';
                        final userActive = userData['status'] == 'online';
                        final lastMessage = chatRoom.lastMessage ?? '';
                        print(">>>>>>>>>>>>>>>>>????${lastMessage.toString()}");
                        final lastMessageType = chatRoom.lastMessage ?? '';
                        final truncatedMessage =
                            lastMessage.split(' ').take(10).join(' ');
                        return Obx(() {
                          if (doctorName
                              .toLowerCase()
                              .contains(searchController.searchQuery.value)) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Card(
                                color: AppColors.cardColor,
                                // Set card color here
                                margin: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 10.w),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(10.w),
                                  leading: CircleAvatar(
                                    backgroundImage: doctorImage.isNotEmpty
                                        ? NetworkImage(doctorImage)
                                        : null,
                                    child: doctorImage.isEmpty
                                        ? Icon(Icons.person)
                                        : null,
                                  ),
                                  title: Text(
                                    doctorName,
                                    style: titleStyle,
                                  ),
                                  subtitle: lastMessageType == 'image'
                                      ? Image.network(lastMessage,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover)
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            truncatedMessage,
                                            style: TextStyle(
                                              height: 1.2,
                                              // Adjust line height if needed
                                              wordSpacing: 2,
                                              color: Colors.grey,
                                              fontSize: 14.sp,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            // Adds an ellipsis at the end of the text if it overflows
                                            maxLines: 1,
                                            // Limits text to 2 lines
                                            softWrap:
                                                true, // Allows text to wrap at soft line breaks
                                          ),
                                        ),
                                  onTap: () {
                                    Get.to(() => ChatRoomPage(
                                          chatroom: chatRoom,
                                          targetUserId: doctorId,
                                        ));
                                  },
                                ),
                              ),
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
      ).paddingSymmetric(horizontal: 10),
    );
  }
}

class SearchssController extends GetxController {
  final TextEditingController textController = TextEditingController();
  var searchQuery = ''.obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
  }
}
