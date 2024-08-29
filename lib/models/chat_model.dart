import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  Timestamp? lastMessageTime; // Added this line for timestamp

  ChatRoomModel({
    this.chatroomid,
    this.participants,
    this.lastMessage,
    this.lastMessageTime,
  });

  // Constructor to initialize from a map
  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    lastMessageTime = map["lastMessageTime"]; // Map the new field
  }

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "lastMessageTime": lastMessageTime, // Include the new field
    };
  }

  // Create an instance from a Firestore DocumentSnapshot
  factory ChatRoomModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatRoomModel.fromMap(data);
  }
}
