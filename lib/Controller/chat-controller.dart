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
  void initChat(String currentUserId, String otherUserId, bool isProvider) {
    chatRoomId.value =
        _chatService.getChatRoomId(currentUserId, otherUserId);

    messages.bindStream(
      _chatService.getMessages(
        currentUserId,
        chatRoomId.value,
        isProvider,
      ),
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

    // 🔍 Detect sender type
    final bool senderIsProvider = await _isProvider(senderId);

    // 📩 Send message to Firestore
    await _chatService.sendMessage(message, chatRoomId.value);

    // 🔔 Get receiver FCM token
    String? receiverToken;

    for (final collection in ['User', 'Provider']) {
      final doc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(receiverId)
          .get();

      final token = doc.data()?['fcmToken'];
      if (doc.exists && token is String && token.isNotEmpty) {
        receiverToken = token;
        break;
      }
    }

    if (receiverToken == null || receiverId == senderId) return;

    /// 🔥 IMPORTANT LOGIC
    /// If PROVIDER sends → providerId = senderId
    /// If USER sends → providerId = receiverId
    final String providerUid =
    senderIsProvider ? senderId : receiverId;

    await NotificationService.sendPushNotification(
      token: receiverToken,
      title: senderName,
      body: text, // 🔥 UID FIELD
      chatRoomId: chatRoomId.value,
      receiverId: receiverId,
      // ✅ REQUIRED

    );

  }

  /// Check provider
  Future<bool> _isProvider(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection("Provider")
        .doc(uid)
        .get();
    return doc.exists;
  }

  /// Delete chat
  Future<void> deleteChat(String currentUserId, bool isProvider) async {
    if (chatRoomId.value.isEmpty) return;

    await _chatService.deleteChat(
      currentUserId,
      chatRoomId.value,
      isProvider,
    );

    messages.clear();
  }
}
