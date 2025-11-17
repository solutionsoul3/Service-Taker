import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/chat-controller.dart';
import '../../Models/ProviderModel.dart';
import '../../Services/notification_service.dart';
import '../../Constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatWithProvider extends StatefulWidget {
  final ProviderModel provider;
  const ChatWithProvider({super.key, required this.provider});

  @override
  State<ChatWithProvider> createState() => _ChatWithProviderState();
}

class _ChatWithProviderState extends State<ChatWithProvider> {
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController _messageController = TextEditingController();

  late String currentUserId;
  String currentUserName = "User";
  String currentUserImage = "https://via.placeholder.com/150";

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;

      // ✅ Save FCM token
      await NotificationService.saveUserToken(
          uid: currentUserId, isProvider: false);

      // ✅ Fetch user's actual name and image from Firestore
      await _fetchUserProfile();

      // ✅ Initialize chat
      chatController.initChat(currentUserId, widget.provider.id, false);
    }
  }

  /// 🔹 Fetch current user's real name and profile image
  Future<void> _fetchUserProfile() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("User")
          .doc(currentUserId)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          currentUserName = data['name'] ?? "User";
          currentUserImage = data['imageUrl'] ?? "https://via.placeholder.com/150";
        });
      } else {
        // If user not found in "User", check "Provider"
        final provDoc = await FirebaseFirestore.instance
            .collection("Provider")
            .doc(currentUserId)
            .get();
        if (provDoc.exists) {
          final data = provDoc.data()!;
          setState(() {
            currentUserName = data['fullName'] ?? "Provider";
            currentUserImage =
                data['imageUrl'] ?? "https://via.placeholder.com/150";
          });
        }
      }
    } catch (e) {
      print("⚠️ Error fetching user profile: $e");
    }
  }

  void showSuccessAnimation(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 12),
                  Text(message,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () => Navigator.of(context).pop());
  }

  Future<void> _deleteChat() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Chat"),
        content: Text(
            "Are you sure you want to delete this chat? This will remove it from your side only."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      await chatController.deleteChat(currentUserId, false);
      showSuccessAnimation(context, "Chat deleted successfully!");
      Future.delayed(Duration(seconds: 2), () => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.logocolor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 35,
                width: 35,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.logocolor, size: 20),
              ),
            ),
            SizedBox(width: 12),
            CircleAvatar(
              backgroundImage: widget.provider.imageUrl.isNotEmpty
                  ? NetworkImage(widget.provider.imageUrl)
                  : AssetImage("assets/images/default.png") as ImageProvider,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.provider.fullName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: _deleteChat,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 35,
                width: 35,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final msgs = chatController.messages;
              if (msgs.isEmpty) return Center(child: Text("No messages yet"));
              return ListView.builder(
                reverse: true,
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  final message = msgs[index];
                  final isMe = message.senderId == currentUserId;
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            isMe ? AppColors.logocolor : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                            color: isMe ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () async {
                    final text = _messageController.text.trim();
                    if (text.isEmpty) return;
                    _messageController.clear();

                    await chatController.sendMessage(
                      text: text,
                      senderId: currentUserId,
                      receiverId: widget.provider.id,
                      senderImage: currentUserImage,
                      receiverImage: widget.provider.imageUrl,
                      senderName: currentUserName,
                      receiverName: widget.provider.fullName,
                    );
                  },
                  child: Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.logocolor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.logocolor.withOpacity(0.5),
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 24.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
