// lib/Services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/MessageModel.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String getChatRoomId(String uid1, String uid2) =>
      uid1.hashCode <= uid2.hashCode ? "${uid1}_$uid2" : "${uid2}_$uid1";

  /// Send message and store chat/message IDs
  Future<void> sendMessage(MessageModel message, String chatRoomId) async {
    final senderIsProvider = await _isProvider(message.senderId);
    final senderCollection = senderIsProvider ? "Provider" : "User";
    final receiverCollection = senderIsProvider ? "User" : "Provider";

    final senderRef = _db
        .collection(senderCollection)
        .doc(message.senderId)
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages");

    final receiverRef = _db
        .collection(receiverCollection)
        .doc(message.receiverId)
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages");

    final docRef = senderRef.doc();
    final messageWithId = message.toMap()..['id'] = docRef.id;

    await docRef.set(messageWithId);
    await receiverRef.doc(docRef.id).set(messageWithId);

    await _updateChatRoomMetadata(
        message, chatRoomId, senderCollection, receiverCollection);
  }

  Future<void> _updateChatRoomMetadata(MessageModel message, String chatRoomId,
      String senderCollection, String receiverCollection) async {
    final chatData = {
      "chatRoomId": chatRoomId,
      "participants": [message.senderId, message.receiverId],
      "names": {
        message.senderId: message.senderName,
        message.receiverId: message.receiverName
      },
      "images": {
        message.senderId: message.senderImage,
        message.receiverId: message.receiverImage
      },
      "lastMessage": message.text,
      "lastMessageTime": Timestamp.fromDate(message.timestamp),
    };

    final senderChatRef = _db
        .collection(senderCollection)
        .doc(message.senderId)
        .collection("chats")
        .doc(chatRoomId);
    final receiverChatRef = _db
        .collection(receiverCollection)
        .doc(message.receiverId)
        .collection("chats")
        .doc(chatRoomId);

    await senderChatRef.set(chatData, SetOptions(merge: true));
    await receiverChatRef.set(chatData, SetOptions(merge: true));
  }

  Stream<List<MessageModel>> getMessages(
      String currentUserId, String chatRoomId, bool isProvider) {
    final collection = isProvider ? "Provider" : "User";
    return _db
        .collection(collection)
        .doc(currentUserId)
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromMap(doc.data(), id: doc.id))
        .toList());
  }

  Future<void> deleteChat(
      String currentUserId, String chatRoomId, bool isProvider) async {
    final collection = isProvider ? "Provider" : "User";
    final messagesRef = _db
        .collection(collection)
        .doc(currentUserId)
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages");
    final messages = await messagesRef.get();
    for (var doc in messages.docs) {
      await doc.reference.delete();
    }
    await _db
        .collection(collection)
        .doc(currentUserId)
        .collection("chats")
        .doc(chatRoomId)
        .delete();
  }

  Future<bool> _isProvider(String uid) async {
    final doc = await _db.collection("Provider").doc(uid).get();
    return doc.exists;
  }
}
