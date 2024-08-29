import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_apponitmnet/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  var searchQuery = ''.obs;
  var onlineUsers = <Map<String, dynamic>>[].obs;
  var usersList = <ChatRoomModel>[].obs;
  var doctorsList = <ChatRoomModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _subscribeToChatUsersList();
    _subscribeToChatDoctorsList();
    _fetchOnlineUsers();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
    _fetchOnlineUsers();
  }

  Future<void> _fetchOnlineUsers() async {
    final querySnapshot = await _firestore
        .collection('chatRooms')
        .where('participants.${firebaseUser?.uid}', isEqualTo: true)
        .get();

    List<Map<String, dynamic>> users = [];

    for (var doc in querySnapshot.docs) {
      final chatRoom =
          ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>);
      final doctorId = chatRoom.participants?.keys.firstWhere(
        (key) => key != firebaseUser?.uid,
        orElse: () => '',
      );

      if (doctorId != null && doctorId.isNotEmpty) {
        final userSnapshot =
            await _firestore.collection("Users").doc(doctorId).get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>;
          final doctorImage = userData['profilePictureUrl'] ?? '';
          final userActive = userData['status'] == 'online';

          if (userActive) {
            if (userData['name'].toLowerCase().contains(searchQuery.value)) {
              users.add({
                'chatRoom': chatRoom,
                'doctorId': doctorId,
                'doctorImage': doctorImage,
                'doctorName': userData['name'],
              });
            }
          }
        }
      }
    }

    onlineUsers.assignAll(users);
  }

  void _subscribeToChatUsersList() {
    final currentUserId = firebaseUser?.uid;

    if (currentUserId == null) {
      print("Current user ID is null");
      return;
    }

    _firestore
        .collection('chatRooms')
        .where('participants.$currentUserId', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      usersList.value = snapshot.docs.map((doc) {
        return ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }, onError: (e) {
      print('Error fetching user chat rooms: $e');
    });
  }

  void _subscribeToChatDoctorsList() {
    final currentUserId = firebaseUser?.uid;

    if (currentUserId == null) {
      print("Current user ID is null");
      return;
    }

    _firestore
        .collection('chatRooms')
        .where('participants.$currentUserId', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      final doctorChatrooms = snapshot.docs.where((doc) {
        final chatRoom = ChatRoomModel.fromMap(doc.data());
        return chatRoom.participants?.keys.any((id) => id != currentUserId) ??
            false;
      }).toList();

      doctorsList.value = doctorChatrooms.map((doc) {
        return ChatRoomModel.fromMap(doc.data());
      }).toList();
    }, onError: (e) {
      print('Error fetching doctor chat rooms: $e');
    });
  }
}
