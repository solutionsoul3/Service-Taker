import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Models/MessageModel.dart';
import '../Services/chat_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  var messages = <MessageModel>[].obs;

  var chatRoomId = "".obs; // ✅ safe, starts with empty string

  void initChat(String userId, String providerId) {
    chatRoomId.value = _chatService.getChatRoomId(userId, providerId);
    messages.bindStream(_chatService.getMessages(chatRoomId.value));
  }

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

    await _chatService.sendMessage(message, chatRoomId.value);
  }
}
