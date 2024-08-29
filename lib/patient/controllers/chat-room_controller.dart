import 'dart:io';
import 'package:app_apponitmnet/models/chat_model.dart';
import 'package:app_apponitmnet/models/message_model.dart';
import 'package:app_apponitmnet/role_method/select_role_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ChatController extends GetxController {
  ChatController({
    required this.chatroom,
    required this.targetUserId,
  });

  final String targetUserId;
  final ChatRoomModel chatroom;
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  RxList<QueryDocumentSnapshot> messages = <QueryDocumentSnapshot>[].obs;
  var isTyping = false.obs;
  var targetUserTyping = false.obs;
  RxString targetUserImage = "".obs;
  RxString targetUserName = "".obs;
  RxBool isSendingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToMessages();
    monitorTyping();
    fetchTargetUserData(targetUserId);
  }

  Future<void> sendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final File imageFile = File(image.path);
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageRef =
        _storage.ref().child('chat_images').child(fileName);

    try {
      isSendingImage.value = true;
      await storageRef.putFile(imageFile);
      final String downloadUrl = await storageRef.getDownloadURL();
      await _imageMessage(downloadUrl);
    } catch (e) {
      Get.snackbar("Error", "Failed to send image: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSendingImage.value = false;
    }
  }

  Future<void> downloadAndSaveImage(String url) async {
    try {
      final Dio dio = Dio();
      final Directory directory = await getApplicationDocumentsDirectory();
      final String fileName = url.split('/').last.split('?').first;
      final String filePath = '${directory.path}/$fileName';

      await dio.download(url, filePath);
      print('Image downloaded and saved to $filePath');
    } catch (e) {
      print('Error downloading and saving image: $e');
    }
  }

  Future<void> _imageMessage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageid: Uuid().v1(),
        sender: currentUser?.uid ?? "",
        createdon: DateTime.now(),
        imageUrl: imageUrl,
        seen: false,
      );

      try {
        await _firestore
            .collection("chatRooms")
            .doc(chatroom.chatroomid)
            .collection("messages")
            .doc(newMessage.messageid)
            .set(newMessage.toMap());

        chatroom.lastMessage = imageUrl;
        await _firestore
            .collection("chatRooms")
            .doc(chatroom.chatroomid)
            .set(chatroom.toMap());

        print("Image Sent!");
      } catch (e) {
        Get.snackbar("Error", "Failed to send Image: $e",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> clearChat() async {
    try {
      final messagesRef = _firestore
          .collection('chatRooms')
          .doc(chatroom.chatroomid)
          .collection('messages');

      final snapshot = await messagesRef.get();

      if (snapshot.docs.isNotEmpty) {
        final batch = _firestore.batch();
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();

        chatroom.lastMessage = '';
        await _firestore
            .collection('chatRooms')
            .doc(chatroom.chatroomid)
            .set(chatroom.toMap());

        Get.snackbar("Success", "Chat cleared successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Info", "No messages to clear",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to clear chat: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchTargetUserData(String targetUserId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Users').doc(targetUserId).get();
      targetUserImage.value = doc["profilePictureUrl"] ?? "";
      targetUserName.value = doc["name"] ?? "";
      if (UserRole.patient == "patient") {
        if (chatroom.chatroomid!.isNotEmpty) {
          await _firestore
              .collection('chatRooms')
              .doc(chatroom.chatroomid)
              .set({
            "currentUserId": currentUser,
            "targetUserId": targetUserId,
          }, SetOptions(merge: true));
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _listenToMessages() {
    _firestore
        .collection('chatRooms')
        .doc(chatroom.chatroomid)
        .collection('messages')
        .orderBy('createdon')
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs;
    }).onError((error) {
      Get.snackbar("Error", "Failed to load messages: $error",
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  Future<void> sendMessage(String text) async {
    String msg = text.trim();
    if (msg.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        messageid: Uuid().v1(),
        sender: currentUser?.uid ?? "",
        createdon: DateTime.now(),
        text: msg,
        imageUrl: "",
        seen: false,
      );

      try {
        await _firestore
            .collection("chatRooms")
            .doc(chatroom.chatroomid)
            .collection("messages")
            .doc(newMessage.messageid)
            .set(newMessage.toMap());

        chatroom.lastMessage = msg;
        await _firestore
            .collection("chatRooms")
            .doc(chatroom.chatroomid)
            .set(chatroom.toMap());

        print("Message Sent!");
      } catch (e) {
        Get.snackbar("Error", "Failed to send message: $e",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void monitorTyping() {
    _firestore
        .collection("chatRooms")
        .doc(chatroom.chatroomid)
        .collection("typing")
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc.id == currentUser?.uid) {
          isTyping.value = doc.data()['isTyping'] ?? false;
        } else if (doc.id == targetUserId) {
          targetUserTyping.value = doc.data()['isTyping'] ?? false;
        }
      }
    }).onError((error) {
      Get.snackbar("Error", "Failed to monitor typing: $error",
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  void updateTypingStatus(bool typing) {
    _firestore
        .collection("chatRooms")
        .doc(chatroom.chatroomid)
        .collection("typing")
        .doc(currentUser?.uid)
        .set({'isTyping': typing}, SetOptions(merge: true)).catchError((error) {
      Get.snackbar("Error", "Failed to update typing status: $error",
          snackPosition: SnackPosition.BOTTOM);
    });
  }
}

Future<String?> getOrCreateChatRoom(String receiverId) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("User not authenticated");
      return null;
    }

    String senderId = currentUser.uid;
    String chatRoomId = _getChatRoomId(senderId, receiverId);

    DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .get();

    if (roomSnapshot.exists) {
      List<dynamic> users = roomSnapshot['users'];
      if (users.contains(senderId) && users.contains(receiverId)) {
        return chatRoomId;
      } else {
        print('Users mismatch. Re-creating chat room.');
        await FirebaseFirestore.instance
            .collection('chatRooms')
            .doc(chatRoomId)
            .set({
          'chatRoomId': chatRoomId,
          'users': [senderId, receiverId],
          'createdAt': FieldValue.serverTimestamp(),
        });
        return chatRoomId;
      }
    } else {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .set({
        'chatRoomId': chatRoomId,
        'users': [senderId, receiverId],
        'createdAt': FieldValue.serverTimestamp(),
      });
      return chatRoomId;
    }
  } catch (e) {
    print('Error in getting/creating chat room: $e');
    return null;
  }
}

Future<ChatRoomModel?> getChatRoomModel(String doctorId) async {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) {
    print("Current user ID is null");
    return null;
  }

  try {
    final chatroomSnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .where('participants.$currentUserId', isEqualTo: true)
        .where('participants.$doctorId', isEqualTo: true)
        .limit(1)
        .get();

    if (chatroomSnapshot.docs.isNotEmpty) {
      return ChatRoomModel.fromMap(chatroomSnapshot.docs.first.data());
    }

    final newChatRoom = ChatRoomModel(
      chatroomid: Uuid().v1(),
      participants: {currentUserId: true, doctorId: true},
      lastMessage: '',
    );

    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(newChatRoom.chatroomid)
        .set(newChatRoom.toMap());

    return newChatRoom;
  } catch (e) {
    print('Error getting or creating chat room: $e');
    return null;
  }
}

String _getChatRoomId(String senderId, String receiverId) {
  return senderId.compareTo(receiverId) > 0
      ? '$receiverId\_$senderId'
      : '$senderId\_$receiverId';
}
