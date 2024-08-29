import 'package:app_apponitmnet/util/doctor_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:app_apponitmnet/models/chat_model.dart';
import 'package:app_apponitmnet/models/user_model.dart';

class SearchsController extends GetxController {
  var searchResults = <UserModel>[].obs;
  var isLoading = true.obs;
  var searchQuery = 'doctor'.obs;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => searchUsers(),
        time: const Duration(milliseconds: 300));
  }

  void searchUsers() async {
    isLoading.value = true;

    try {
      var query = FirebaseFirestore.instance
          .collection("Users")
          .where("name", isGreaterThanOrEqualTo: searchQuery.value);

      if (firebaseUser?.displayName != null) {
        query = query.where("name", isNotEqualTo: firebaseUser?.displayName);
      }

      var snapshot = await query.get();

      searchResults.value = snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      if (searchResults.isEmpty) {
        Get.snackbar("No Results", "No users found matching your search.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
  Future<ChatRoomModel?> getChatRoomModel(String doctorId) async {
    final currentUserId = firebaseUser?.uid;

    if (currentUserId == null) {
      print("Current user ID is null");
      return null;
    }

    final chatroomSnapshot = await firestore
        .collection('chatRoom')
        .where('participants.$currentUserId', isEqualTo: true)
        .where('participants.$doctorId', isEqualTo: true)
        .limit(1)
        .get();

    if (chatroomSnapshot.docs.isNotEmpty) {
      return ChatRoomModel.fromMap(
          chatroomSnapshot.docs.first.data() as Map<String, dynamic>);
    }

    // If no chatroom exists, create a new one
    final newChatRoom = ChatRoomModel(
      chatroomid: Uuid().v1(),
      participants: {
        currentUserId: true,
        doctorId: true,
      },
      lastMessage: '',
    );

    await firestore
        .collection('chatRoom')
        .doc(newChatRoom.chatroomid)
        .set(newChatRoom.toMap());

    return newChatRoom;
  }

  Future<ChatRoomModel?> getChatroomModel() async {
    ChatRoomModel? chatRoom;
    String targetUser =" DoctorData.doctorId";
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("chatRoom")
          .where("participants.${firebaseUser?.uid}", isEqualTo: true)
          .where("participants.${targetUser}", isEqualTo: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var docData = snapshot.docs[0].data();
        chatRoom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      } else {
        var newChatroom = ChatRoomModel(
          chatroomid: Uuid().v1(),
          lastMessage: "",
          participants: {
            firebaseUser?.uid ?? "unknown": true,
            targetUser: true,
          },
        );

        await FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(newChatroom.chatroomid)
            .set(newChatroom.toMap());
        chatRoom = newChatroom;
        Get.log("New Chatroom Created!");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    return chatRoom;
  }
}
class SearchssController extends GetxController {
  final TextEditingController textController = TextEditingController();
  var searchQuery = ''.obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
  }
}
