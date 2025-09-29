import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  final String callId;
  final String callerId;
  final String callerName;
  final String callerImage;
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final String callType; // "audio" or "video"
  final String status;   // "ongoing", "ended", "missed"
  final DateTime timestamp;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerImage,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    required this.callType,
    required this.status,
    required this.timestamp,
  });

  // fromMap (Firestore -> Model)
  factory CallModel.fromMap(Map<String, dynamic> map, String id) {
    return CallModel(
      callId: id,
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerImage: map['callerImage'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverImage: map['receiverImage'] ?? '',
      callType: map['callType'] ?? 'audio',
      status: map['status'] ?? 'ongoing',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  // toMap (Model -> Firestore)
  Map<String, dynamic> toMap() {
    return {
      "callerId": callerId,
      "callerName": callerName,
      "callerImage": callerImage,
      "receiverId": receiverId,
      "receiverName": receiverName,
      "receiverImage": receiverImage,
      "callType": callType,
      "status": status,
      "timestamp": timestamp,
    };
  }
}
