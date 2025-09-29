import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final String senderName;
  final String senderImage;
  final String receiverName;
  final String receiverImage;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.senderName,
    required this.senderImage,
    required this.receiverName,
    required this.receiverImage,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "text": text,
      "timestamp": timestamp,
      "senderName": senderName,
      "senderImage": senderImage,
      "receiverName": receiverName,
      "receiverImage": receiverImage,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map["senderId"] ?? "",
      receiverId: map["receiverId"] ?? "",
      text: map["text"] ?? "",
      timestamp: (map["timestamp"] as Timestamp).toDate(),
      senderName: map["senderName"] ?? "",
      senderImage: map["senderImage"] ?? "",
      receiverName: map["receiverName"] ?? "",
      receiverImage: map["receiverImage"] ?? "",
    );
  }
}
