import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/MessageModel.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String getChatRoomId(String userId, String providerId) {
    return userId.hashCode <= providerId.hashCode
        ? "${userId}_$providerId"
        : "${providerId}_$userId";
  }

  Future<void> sendMessage(MessageModel message, String chatRoomId) async {
    final chatRoomRef = _db.collection("chat_rooms").doc(chatRoomId);

    // 1. Save message in subcollection
    await chatRoomRef.collection("messages").add(message.toMap());

    // 2. Update chat room metadata
    await chatRoomRef.set({
      "participants": [message.senderId, message.receiverId],
      "names": {
        message.senderId: message.senderName,
        message.receiverId: message.receiverName,
      },
      "images": {
        message.senderId: message.senderImage,
        message.receiverId: message.receiverImage,
      },
      "lastMessage": message.text,
      "lastMessageTime": Timestamp.fromDate(message.timestamp),
    }, SetOptions(merge: true));
  }

  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    return _db
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList());
  }
}
