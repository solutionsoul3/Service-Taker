import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Models/MessageModel.dart';
import '../Services/chat_service.dart';
import '../Services/notification_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  var messages = <MessageModel>[].obs;
  var chatRoomId = "".obs;

  /// Initialize chat
  /// isProvider = true if current user is provider, false if user
  void initChat(String currentUserId, String otherUserId, bool isProvider) {
    chatRoomId.value = _chatService.getChatRoomId(currentUserId, otherUserId);
    messages.bindStream(
      _chatService.getMessages(currentUserId, chatRoomId.value, isProvider),
    );
  }

  /// Send message
  Future<void> sendMessage({
    required String text,
    required String senderId,
    required String receiverId,
    required String senderName,
    required String senderImage,
    required String receiverName,
    required String receiverImage,
  }) async {
    if (text.isEmpty || chatRoomId.value.isEmpty) return;

    final message = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now(),
      senderName: senderName,
      senderImage: senderImage,
      receiverName: receiverName,
      receiverImage: receiverImage,
    );

    // Save message to Firestore
    await _chatService.sendMessage(message, chatRoomId.value);

    // Detect sender type (user or provider)
    final bool senderIsProvider = await _isProvider(senderId);

    // Get receiver FCM token and phone safely
    String? receiverToken;
    String receiverPhone = '';
    for (final collection in ['User', 'Provider']) {
      final doc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(receiverId)
          .get();
      if (doc.exists) {
        final data = doc.data();
        final token = data?['fcmToken'] as String?;
        final phone = data?['phoneNumber']?.toString();
        if (token != null && token.isNotEmpty) {
          receiverToken = token;
          receiverPhone = phone ?? '';
          break;
        }
      }
    }

    if (receiverToken == null || receiverId == senderId) return;

    /// 🔥 Send push notification with all required fields
    await NotificationService.sendPushNotification(
      token: receiverToken,
      title: senderName,
      body: text,
      userId: senderId, // sender’s userId
      userName: senderName, // sender’s name
      userImage: senderImage, // sender’s image
      chatRoomId: chatRoomId.value,
      receiverId: receiverId, // receiver’s userId
      contactNumber: receiverPhone,
      providerId:
          senderIsProvider ? senderId : receiverId, // correct providerId
    );
  }

  /// Check if user is provider
  Future<bool> _isProvider(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection("Provider").doc(uid).get();
    return doc.exists;
  }

  /// Delete chat
  Future<void> deleteChat(String currentUserId, bool isProvider) async {
    if (chatRoomId.value.isEmpty) return;

    await _chatService.deleteChat(currentUserId, chatRoomId.value, isProvider);
    messages.clear();
  }
}
