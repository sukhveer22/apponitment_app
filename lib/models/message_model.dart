class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  String? imageUrl; // Existing field for image URL
  String? targetUserImage; // Existing field for image URL
  String? targetUserName; // Existing field for image URL
  String? videoUrl; // New field for video URL
  bool? seen;
  DateTime? createdon;

  MessageModel({
    this.messageid,
    this.sender,
    this.text,
    this.imageUrl,
    this.targetUserImage,
    this.targetUserName,
    this.videoUrl, // Include videoUrl in the constructor
    this.seen,
    this.createdon,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    imageUrl = map["imageUrl"]; // Extract imageUrl from map
    targetUserImage = map["targetUserImage"]; // Extract imageUrl from map
    targetUserName = map["targetUserName"]; // Extract imageUrl from map
    videoUrl = map["videoUrl"]; // Extract videoUrl from map
    seen = map["seen"];
    createdon = map["createdon"]?.toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "targetUserName": targetUserName,
      "targetUserImage": targetUserImage,
      "text": text,
      "imageUrl": imageUrl,
      "videoUrl": videoUrl, // Include videoUrl in the map
      "seen": seen,
      "createdon": createdon
    };
  }
}
