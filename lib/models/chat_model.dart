import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  Timestamp? lastMessageTime; // Add this line to include the timestamp

  ChatRoomModel({
    this.chatroomid,
    this.participants,
    this.lastMessage,
    this.lastMessageTime,
  });

  // Update the constructor to handle the new field
  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    lastMessageTime = map["lastMessageTime"]; // Map the new field
  }

  // Update toMap to include the new field
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "lastMessageTime": lastMessageTime, // Include the new field
    };
  }
}
