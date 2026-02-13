// lib/Models/MessageModel.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id; // message ID
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final String senderName;
  final String senderImage;
  final String receiverName;
  final String receiverImage;

  MessageModel({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.senderName,
    required this.senderImage,
    required this.receiverName,
    required this.receiverImage,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "senderId": senderId,
    "receiverId": receiverId,
    "text": text,
    "timestamp": timestamp,
    "senderName": senderName,
    "senderImage": senderImage,
    "receiverName": receiverName,
    "receiverImage": receiverImage,
  };

  factory MessageModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return MessageModel(
      id: id ?? data['id'],
      senderId: data["senderId"],
      receiverId: data["receiverId"],
      text: data["text"],
      timestamp: (data["timestamp"] as Timestamp).toDate(),
      senderName: data["senderName"],
      senderImage: data["senderImage"],
      receiverName: data["receiverName"],
      receiverImage: data["receiverImage"],
    );
  }
}
